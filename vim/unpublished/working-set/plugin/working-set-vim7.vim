if v:version < 800

ruby <<EOF
  require 'socket'

  class WorkingSetConnection
    attr_accessor :socket, :listener_thread

    # def initialize(host = "localhost", port = 3930)
    #   @host = host
    #   @port = port
    #   build_socket
    # end

    def initialize(socket_path = ".working_set_socket")
      @socket_path = socket_path
      build_socket
    end

    def build_socket
      # self.socket = UNIXSocket.new @host, @port
      self.socket = UNIXSocket.new @socket_path
    end

    def close
      socket.close
    end

    def search(term)
      send_message "search_changed", term
    end

    def sync
      send_message "tell_selected_item"
      wait_for_sync
    end

    def wait_for_sync
      wait_for_response do |file_path, row, col|
        VIM::command ":e #{file_path}"
        VIM::command ":norm #{row}gg" if row
        VIM::command ":norm #{col}|" if col
      end
    end

    def select_next_item
      send_message "select_next_item"
      sync
    end

    def select_prev_item
      send_message "select_prev_item"
      sync
    end

    private

    def send_message(msg, arg = nil, should_retry = true)
      arg = arg.sub('|', '\|') if arg
      socket.puts [msg, arg].compact.join("|")
    rescue Errno::EPIPE => e
      if should_retry
        build_socket
        send_message(msg, arg, false)
      else
        raise e
      end
    end

    def wait_for_response
      response = socket.gets
      if response
        parts = response.chomp.split("|")
        yield(*parts) if block_given?
      else
        nil
      end
    end

  end
EOF

if !exists("g:WorkingSetSearchPrefix")
  let g:WorkingSetSearchPrefix = ""
endif

if !exists("g:WorkingSetSocketPath")
  let g:WorkingSetSocketPath = ".working_set_socket"
endif

function! s:WS_EnsureConnection()
  ruby << EOF
    $WS_connection ||= WorkingSetConnection.new VIM::evaluate("g:WorkingSetSocketPath")
EOF
endfunction

function! s:WS_search(term)
  call s:WS_EnsureConnection()
  let searchString = g:WorkingSetSearchPrefix . " " . a:term
  ruby << EOF
  VIM::message("Search: #{VIM::evaluate('searchString').inspect}")
  $WS_connection.search(VIM::evaluate('searchString'))
EOF
endfunction

function! s:WS_search_current_word()
  let wordUnderCursor = expand("<cword>")
  call s:WS_search("-w " . wordUnderCursor)
endfunction

function! s:WS_sync()
  call s:WS_EnsureConnection()
  ruby << EOF
  $WS_connection.sync()
EOF
endfunction

function! s:WS_select_next_item()
  call s:WS_EnsureConnection()
  ruby << EOF
  $WS_connection.select_next_item
EOF
endfunction

function! s:WS_select_prev_item()
  call s:WS_EnsureConnection()
  ruby << EOF
  $WS_connection.select_prev_item
EOF
endfunction

function! s:WS_wait_for_sync()
  call s:WS_EnsureConnection()
  ruby << EOF
  $WS_connection.wait_for_sync
EOF
endfunction

command! -nargs=1 WS call s:WS_search(<f-args>)
command! WSSync call s:WS_sync()
command! WSSelectNextItem call s:WS_select_next_item()
command! WSSelectPrevItem call s:WS_select_prev_item()
command! WSSearchCurrentWord call s:WS_search_current_word()
command! WSWaitForSync call s:WS_wait_for_sync()

if !exists('g:WorkingSetSkipMappings')
  nnoremap <silent> <C-n> :WSSelectNextItem<CR>
  nnoremap <silent> <C-p> :WSSelectPrevItem<CR>
  nnoremap <silent> <Leader>* *N:WSSearchCurrentWord<CR>
  nnoremap <silent> <Leader><Leader> :WSWaitForSync<CR>
endif

endif

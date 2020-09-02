if v:version >= 800

let g:WorkingSetSocketPath   = get(g:, 'WorkingSetSocketPath', '.working_set_socket')
let g:WorkingSetSearchPrefix = get(g:, 'WorkingSetSearchPrefix', '')

" Connection Management
" =====================

func! s:EnsureConnection()
  if exists("g:WSchannel") && ch_status(g:WSchannel) == "open"
    " Connected, do nothing.
  else
    call s:Connect(g:WorkingSetSocketPath)
  endif
endfunc

func! s:Connect(socketfile)
  if exists("g:WSjob") && job_status(g:WSjob) == "run"
    call job_stop(g:WSjob)
  endif

  let g:WSjob = job_start("socat - UNIX-CONNECT:" . a:socketfile, { "err_cb": function("s:ErrorHandler"), "out_cb": function("s:BasicInputHandler") })
  let g:WSchannel = job_getchannel(g:WSjob)

  if ch_status(g:WSchannel) != "open"
    echomsg "Unable to connect to .working_set_socket"
  endif
endfunc

" Handles basic msg from Working Set, which is normally a file|row|col msg.
" When other inputs are expected, a specific handler should be specified.
func! s:BasicInputHandler(channel, msg)
  call s:SyncLocation(a:msg)
endfunc

func! s:ErrorHandler(channel, msg)
  echomsg "WS Error: " . a:msg
endfunc

" Low Level API Functions
" =======================

func! s:SyncLocation(msg)
  let parts = split(a:msg, "|")
  if a:msg == "" || len(parts) > 3
    echomsg "WS Sync confused: " . a:msg
  else
    if len(parts) > 0
      exe 'e' parts[0]
    endif
    if len(parts) > 1
      exe 'norm' parts[1] . 'gg'
    endif
    if len(parts) > 2
      exe 'norm' parts[2] . '|'
    endif
  endif
endfunc

func! s:SendMsg(msg, ...)
  call s:EnsureConnection()
  if exists("a:2")
    call ch_sendraw(g:WSchannel, a:msg . "\n", { 'callback' : function(a:1, [a:2]) })
  elseif exists("a:1")
    call ch_sendraw(g:WSchannel, a:msg . "\n", { 'callback' : function(a:1) })
  else
    call ch_sendraw(g:WSchannel, a:msg . "\n")
  endif
endfunc

" Medium Level API Functions
" ==========================

func! s:Sync()
  call s:SendMsg("tell_selected_item")
endfunc

func! s:Search(term)
  call s:SendMsg("search_changed|" . a:term)
endfunc

func! s:SelectNextItem()
  call s:SendMsg("select_next_item")
  call s:Sync()
endfunc

func! s:SelectPrevItem()
  call s:SendMsg("select_prev_item")
  call s:Sync()
endfunc

" High Level API Functions
" ========================

func! s:SearchWithPrefix(term)
  echomsg "WS Search: " . a:term
  call s:Search(g:WorkingSetSearchPrefix . " " . a:term)
endfunc

func! s:SearchCurrentWord()
  let wordUnderCursor = expand("<cword>")
  call s:SearchWithPrefix("-w " . wordUnderCursor)
endfunc

func! s:Grab(pasteCmd)
  call s:SendMsg("tell_selected_item_content", "s:HandleGrabbedItem", a:pasteCmd)
endfunc

func! s:HandleGrabbedItem(pasteCmd, channel, msg)
  let line = substitute(a:msg, '^\s*', '', '')
  call setreg('"', line, 'l')
  exe 'normal ""' . a:pasteCmd
endfunc

command! WSSelectNextItem call s:SelectNextItem()
command! WSSelectNextItem call s:SelectNextItem()

" Command mappings
" ================

command! -nargs=1 WS call s:SearchWithPrefix(<f-args>)
command! WSSync call s:Sync()
command! -nargs=1 WSGrab call s:Grab(<f-args>)
command! WSSelectNextItem call s:SelectNextItem()
command! WSSelectPrevItem call s:SelectPrevItem()
command! WSSearchCurrentWord call s:SearchCurrentWord()

if !exists('g:WorkingSetSkipMappings')
  nnoremap <silent> <C-n>     :WSSelectNextItem<CR>
  nnoremap <silent> <C-p>     :WSSelectPrevItem<CR>
  nnoremap <silent> <Leader>* *N:WSSearchCurrentWord<CR>
  nnoremap <silent> <Leader>p :WSGrab p<CR>
  nnoremap <silent> <Leader>P :WSGrab P<CR>
endif

endif

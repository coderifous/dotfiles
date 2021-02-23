command Todo :e ~/.todo

let s:done_icon     = "✔"
let s:notdone_icon  = "❒"
let s:canceled_icon = "✘"
let s:pushed_icon   = "⍄"

function s:now_timestamp()
  let timestamp = strftime("%b %e, %l:%M%p")
  let timestamp = substitute(timestamp, "  ", " ", "g")
  let timestamp = substitute(timestamp, "AM", "am", "")
  let timestamp = substitute(timestamp, "PM", "pm", "")
  return timestamp
endfunction

function STL_ToggleTodoDone(include_timestamp)
  let save_cursor  = getpos(".")

  " FML this didn't work for multibyte char
  " let first_char = getline('.')[col('.')-1]
  normal! ^
  normal! "lyl
  let first_char = @l

  if first_char == s:done_icon
    " Mark as not done
    s/ \[.*\]//e
    execute "normal! xi".s:notdone_icon

  elseif first_char == s:notdone_icon
    " Mark as done
    if a:include_timestamp
      execute "normal! xi".s:done_icon." [".s:now_timestamp()."]"
    else
      execute "normal! xi".s:done_icon
    endif

  elseif first_char == s:canceled_icon
    execute "normal! xi".s:notdone_icon

  elseif first_char == s:pushed_icon
    execute "normal! xi".s:notdone_icon

  else
    execute "normal! i".s:notdone_icon." "
  end

  call setpos('.', save_cursor)
endfunction

function STL_ToggleTodoCanceled()
  let save_cursor  = getpos(".")

  " FML this didn't work for multibyte char
  " let first_char = getline('.')[col('.')-1]
  normal! ^
  normal! "lyl
  let first_char = @l

  if first_char != s:canceled_icon
    " Mark canceled
    execute "normal! xi".s:canceled_icon
  else
    execute "normal! xi".s:notdone_icon
  end

  call setpos('.', save_cursor)
endfunction

function STL_ToggleTodoPushed()
  let save_cursor  = getpos(".")

  " FML this didn't work for multibyte char
  " let first_char = getline('.')[col('.')-1]
  normal! ^
  normal! "lyl
  let first_char = @l

  if first_char != s:pushed_icon
    " Mark canceled
    execute "normal! xi".s:pushed_icon
  else
    execute "normal! xi".s:notdone_icon
  end

  call setpos('.', save_cursor)
endfunction

function STL_ToggleSectionTitle()
  let regionName = synIDattr(synID(line("."), col("."), 0), "name")
  if regionName == "simpleTodoTitle"
    normal! jddk
  else
    normal! yypVr-k
  endif
endfunction

function STL_ListPagesComp(ArgLead, CmdLine, CursorPos)
  return system("note page list")
endfunction

function STL_CreateAndOpenPage(name)
  let filePath = system("note page create '" . a:name . "'")
  execute 'edit ' . filePath
endfunction

function STL_OpenPageByName(name)
  execute 'edit ~/notebook/pages/' . a:name . '.todo.txt'
endfunction


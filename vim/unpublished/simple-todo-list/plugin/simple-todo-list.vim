command Todo :e ~/.todo

function STL_ToggleTodoLogged()
  let done_icon    = "✔"
  let notdone_icon = "❒"
  let save_cursor  = getpos(".")

  " FML this didn't work for multibyte char
  " let first_char = getline('.')[col('.')-1]
  normal! ^
  normal! "lyl
  let first_char = @l

  if first_char == done_icon
    " Move to log
    normal! dd
    call search("DONE LOG")
    normal! jp

  elseif first_char == notdone_icon
    " Move to todo list
    normal! dd
    call search("TODO LIST", "b")
    normal! jp

  else
    " do nothing
  end

  call setpos('.', save_cursor)
endfunction

function STL_ToggleTodoDone()
  let done_icon    = "✔"
  let notdone_icon = "❒"
  let save_cursor  = getpos(".")

  " FML this didn't work for multibyte char
  " let first_char = getline('.')[col('.')-1]
  normal! ^
  normal! "lyl
  let first_char = @l

  if first_char == done_icon
    " Mark as not done
    s/ \[.*\]//
    execute "normal! xi".notdone_icon

  elseif first_char == notdone_icon
    " Mark as done
    let date_command = "date ".shellescape("+%h %d, %Y %l:%M%p")
    let timestamp = substitute(system(date_command), "\n", "", "")
    execute "normal! xi".done_icon." [".timestamp."]"

  else
    execute "normal! i".notdone_icon." "
  end

  call setpos('.', save_cursor)
endfunction

function STL_ToggleTodoDoneAndLogged()
  call STL_ToggleTodoDone()
  call STL_ToggleTodoLogged()
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


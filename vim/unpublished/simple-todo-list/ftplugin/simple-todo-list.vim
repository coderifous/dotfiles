" Simple Todo List filetype plugin
" Language:   Simple Todo List
" Maintainer: Jim Garvin <jim@thegarvin.com>

if (exists("b:loaded_simpletodolugin"))
  finish
endif

command! -buffer -nargs=1 CreatePage call STL_CreateAndOpenPage(<f-args>)

command! -buffer -complete=custom,STL_ListPagesComp -nargs=1 OpenPage call STL_OpenPageByName(<f-args>)

command! -buffer FindPage call fzf#run(fzf#wrap({ 'sink': function('STL_OpenPageByName'), 'source':'note page list' }))

nnoremap <buffer> <silent> <Leader>d :call STL_ToggleTodoDone(0)<CR>
nnoremap <buffer> <silent> <Leader>m :call STL_ToggleTodoDone(1)<CR>
nnoremap <buffer> <silent> <Leader>T :call STL_ToggleSectionTitle()<CR>
nnoremap <buffer> <silent> <Leader>x :call STL_ToggleTodoCanceled()<CR>
nnoremap <buffer> <silent> <Leader>> :call STL_ToggleTodoPushed()<CR>

nnoremap <buffer> <C-n> /^----<CR><CR>
nnoremap <buffer> <C-p> ?^----<CR>n<CR>

nnoremap <buffer> <silent> <Leader>o :FindPage<CR>

set formatoptions+=t

let b:loaded_simpletodolugin = 1

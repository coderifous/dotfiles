" Vim syntax file
" Language:   Simple Todos
" Maintainer: Jim Garvin <jim@thegarvin.com>
" Filenames:  *.todo.txt

if exists("b:current_syntax")
  finish
endif

syntax sync fromstart
set foldmethod=syntax

syn region simpleTodoSection start=/^[^-].\+\n----\+$/  end=/\n[^-].\+\n----\+$/me=s-1 keepend contains=simpleTodoTitle,simpleTodoBody
syn region simpleTodoBody    start=/./ end=/__nothing_matches__/ contained fold contains=simpleTodoTaskOpen,simpleTodoTaskDone,simpleTodoTaskCanceled,simpleTodoTaskPushed
syn match simpleTodoTaskOpen     /^ *❒ .\+$/ contained
syn match simpleTodoTaskDone     /^ *✔ .\+$/ contained
syn match simpleTodoTaskCanceled /^ *✘ .\+$/ contained
syn match simpleTodoTaskPushed   /^ *⍄ .\+$/ contained
syn region simpleTodoTitle   start=/^[^-].\+\n\z\(----\+$\)/ end=/^\z1/ contained

hi def link simpleTodoBody         Normal
hi def link simpleTodoTitle        PreProc
hi def link simpleTodoTaskOpen     Function
hi def link simpleTodoTaskDone     Type
hi def link simpleTodoTaskCanceled Comment
hi def link simpleTodoTaskPushed   Comment

let b:current_syntax = "simple-todo"

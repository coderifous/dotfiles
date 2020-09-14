unlet b:current_syntax
syntax include @HTML $VIMRUNTIME/syntax/html.vim
syntax region coffeeHtmlString matchgroup=coffeeHeredoc
\      start=+'''\\(\\_\\s*<\\w\\)\\@=+ end=+\\(\\w>\\_\\s*\\)\\@<='''+
\      contains=@HTML
syn sync minlines=300

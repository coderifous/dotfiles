" syn match jsMissingSemicolonError /[^,;{}(]\ze\n[\t ]*[^.}\n\t ]/ display containedin=ALLBUT,javaScriptLineComment,javaScriptComment
" hi def link jsMissingSemicolonError Error

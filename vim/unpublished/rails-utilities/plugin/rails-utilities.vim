" Rails Utilities plugin
" Maintainer: Jim Garvin <jim@thegarvin.com>

function! AutovivifyMissingTestFile()
  let sourceFile = expand("%")
  let targetFile  = 'spec/' . system("echo " . sourceFile . " | sed 's,^app/,,' | sed 's/.rb$/_spec.rb/'")
  call system("touch " . targetFile)
  exe 'vsplit' l:targetFile
endfunction

command! AVV :call AutovivifyMissingTestFile()

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal smartindent nocindent
setlocal cinwords=do,else,for,if,switch,case,when,while

" Disable left-flushing of comments, as suggested in help for smartindent.
inoremap <buffer> # X#

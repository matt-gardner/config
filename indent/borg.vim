if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal smartindent autoindent cinwords= nocindent indentexpr= cinoptions+=+0

" Indenting with 'smartindent' causes lines starting with '#' to be
" automatically de-indented, and the '#' character placed in the first column.
" Docs suggest this as a work-around if this behavior is not desired.
inoremap <buffer> # X<Backspace>#

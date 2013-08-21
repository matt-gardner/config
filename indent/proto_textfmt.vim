" Vim indent file
" Language:    Text-Format Protocol Buffer
" Author:      Mark Lodato <lodato@google.com>
" Last Change: 2012 Oct 18
"
" To use:
"
"   :set ft=proto_textfmt
"
" Based on vb.vim and http://stackoverflow.com/questions/4829244.

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=ProtoTextfmtGetIndent(v:lnum)
setlocal indentkeys=0{,0<<>,0},0<>>,o,O,!^F

fun! ProtoTextfmtGetIndent(lnum)

  " Find the first non-blank, non-comment line above the current line.
  let lnum = a:lnum
  while lnum > 0
    let lnum = prevnonblank(lnum - 1)
    let prev_line = getline(lnum)
    if prev_line !~ '^\s*#'
      break
    endif
  endwhile

  " Use a zero indent at the start of the file.
  if lnum == 0
    return 0
  endif

  let this_line = getline(a:lnum)
  let ind = indent(lnum)

  " Indent blocks enclosed by <> or {}.
  " Find a real opening brace
  let bracepos = match(prev_line, '[<>{}]', matchend(prev_line, '^\s*[>}]'))
  while bracepos != -1
    let brace = strpart(prev_line, bracepos, 1)
    if brace == '<' || brace == '{'
      let ind = ind + &sw
    else
      let ind = ind - &sw
    endif
    let bracepos = match(prev_line, '[<>{}]', bracepos + 1)
  endwhile
  let bracepos = matchend(this_line, '^\s*[>}]')
  if bracepos != -1
    let ind = ind - &sw
  endif

  return ind

endfun

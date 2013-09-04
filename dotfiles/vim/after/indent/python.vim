" Indent Python in the Google way.
"
" A version of this also lives at the external style guide:
"   http://code.google.com/p/google-styleguide/source/browse/trunk/google_python_style.vim
"
" If you don't want this, do:
"   let no_google_python_indent = 1
" in your .vimrc file.
"
" If you don't want recursive 4 space indents (the style guide standard), do:
"   let no_google_python_recursive_indent = 1
" in your .vimrc file.

if exists("g:no_google_python_indent") && g:no_google_python_indent
  finish
endif

setlocal indentexpr=GetGooglePythonIndent(v:lnum)
echom "LOADING"
echom &indentexpr

if exists("*GetGooglePythonIndent")
  finish
endif

let s:maxoff = 50 " maximum number of lines to look backwards.

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

if exists("g:no_google_python_recursive_indent")
  if g:no_google_python_recursive_indent
    finish
  endif
endif

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

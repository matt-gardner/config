" Vim indent file
" Language: Borgmon
" Author: Yi-An Huang (yian@google.com)
"
" Global Variables:
" g:borgmon_template_arg_indent:
"   use a custom indent for arguments in a template definition. default is
"   'shiftwidth'.  Use 8 to be consistent with the common template.
" g:borgmon_alert_clause_extra_indent:
"   as shown in the following snippet:
"   [foo=bar]
"     => notify "email"
"       message "message";
"   message can either align with the space after =>, or with notify. The
"   default is former. Set this variable to 1 to use the latter.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal autoindent
setlocal indentexpr=GetBorgmonIndent(v:lnum)
setlocal indentkeys=!^F,o,O,0},0],0),>,0{,0+,0-,0<*>,0/,0%,0<<>,0&,=,0\|,0<!>
setlocal indentkeys+=0=and,0=or,0=xor,0=unless,0=for,0=interval,0=continue
setlocal indentkeys+=0=uncaught

function! GetBorgmonIndent(lnum)
  " Special rules if we are continuing the last line.
  if getline(a:lnum - 1) =~ '\\$'
    " move { to the first column. We should check if this is part of template
    " but that is somewhat expensive.
    if getline(a:lnum) =~ '^\s*{$'
      return 0
    endif

    if a:lnum > 1 && getline(a:lnum - 2) =~ '\\$'
      return indent(a:lnum - 1)
    endif
    if getline(a:lnum - 1) =~ '^\s*template' &&
       \ exists('g:borgmon_template_arg_indent')
      return indent(a:lnum - 1) + g:borgmon_template_arg_indent
    else
      return indent(a:lnum - 1) + &sw
    endif
  endif

  " Search backwards for the previous non-empty line.
  let prev_lnum = prevnonblank(a:lnum - 1)
  let prev_line = getline(prev_lnum)
  while prev_lnum > 0 && prev_line =~ '^\s*#'
    let prev_lnum = prevnonblank(prev_lnum - 1)
    let prev_line = getline(prev_lnum)
  endwhile

  " This is the first non-empty line, use zero indent.
  if prev_lnum == 0
    return 0
  endif

  " Find the beginning of the current block.
  call cursor(a:lnum, 1)
  " Search backward for a block open marker (, [, { or <<<. ignoring those
  " already closed by end markers, also ignoring matches inside comments or
  " strings.
  let [block_lnum, block_column] = searchpairpos('(\|\[\|{\|<<<', '',
    \ ')\|\]\|}\|>>>', 'nbW', "synIDattr(synID(line('.'), col('.'), 1), 'name')"
    \ . " =~ '\\(Comment\\|String\\)$'")

  " If not in any block, align with the previous non-empty line.
  if block_lnum == 0
    return indent(prev_lnum)
  endif

  let cur_line = getline(a:lnum)
  let block_line = getline(block_lnum)
  let block_type = strpart(block_line, block_column - 1, 1)
  let block_base_indent = indent(block_lnum)

  " If inside ( block, indent unless it is a ). indent two levels for operators.
  if block_type == '('
    if cur_line =~ '^\s*)'
      return block_base_indent
    elseif cur_line =~ '^\s*\(\(and\|or\|xor\|unless\)\>\|[+\-*/%><&|!=]\)'
      return block_base_indent + 2 * &sw
    else
      return block_base_indent + &sw
    endif
  endif

  " If inside [ block, indent unless it is a ].
  if block_type == '['
    if cur_line =~ '^\s*]'
      return block_base_indent
    else
      return block_base_indent + &sw
    endif
  endif

  " Check we are inside a rules <<< block, which doesn't have to be the
  " innermost block.
  let in_ruleset = searchpair('\<rules\s*<<<', '', '>>>', 'nbW',
    \ "synIDattr(synID(line('.'), col('.'), 1), 'name')"
    \ . " =~ '\\(Comment\\|String\\)$'") > 0

  " Apply simple indent rules if we are not part of rules or we are closing a
  " { or <<< block.
  if block_type == '{'
    if cur_line =~ '^\s*}'
      return block_base_indent
    elseif !in_ruleset
      return block_base_indent + &sw
    endif
  endif

  if block_type == '<'
    if cur_line =~ '^\s*>>>'
      return block_base_indent
    elseif !in_ruleset
      if prev_lnum <= block_lnum
        return block_base_indent
      else
        return indent(prev_lnum)
      endif
    endif
  endif

  " If we are in a rules block, we are typically in a statement in the form of
  " a = b; or a => b;.
  " Depending on whether we saw = or ; first, we are on either the LHS (a) or
  " RHS (b) of the statement. So we search for the last seen symbol within the
  " current block, which can be either ';', '=', or '{' denoting neither
  " symbols were seen, i.e., the first statement within this block.
  let stopline = block_lnum + 1
  let middle = ';\|\(\_s\|\w\)\zs=>\?\ze\(\_s\|\w\)'
  " Search backward for a block open marker (, [, { or <<<. ignoring those
  " already closed by end markers, also ignoring matches inside comments or
  " strings.
  let [sym_lnum, sym_column] = searchpairpos('(\|\[\|{', middle , ')\|\]\|}',
    \  'nbW', "synIDattr(synID(line('.'), col('.'), 1), 'name')"
    \ . " =~ '\\(Comment\\|String\\)$'", stopline)
  let sym_type = sym_lnum == 0 ? '{' :
    \ strpart(getline(sym_lnum), sym_column - 1, 2)

  " First line of LHS, easy case.
  if (sym_type[0] == '{' || sym_type[0] == ';') && sym_lnum == prev_lnum
    return block_base_indent + &sw
  endif

  " RHS of alert rules
  if sym_type == '=>'
    if exists('g:borgmon_alert_clause_extra_indent')
      let extra_indent = g:borgmon_alert_clause_extra_indent
    else
      let extra_indent = 0
    endif
    return indent(sym_lnum) + &sw + extra_indent
  endif

  " Otherwise, determine the base indent and indent more for operators.
  if sym_type[0] == '='  " RHS of assignment
    let base_indent = indent(sym_lnum) + &sw
  else                   " LHS minus the first line
    let base_indent = block_base_indent + &sw
    " additional keywords that lead to indentation
    if cur_line =~ '^\s*\(for\|interval\|continue\|uncaught\)\>'
      return base_indent + &sw
    endif
  endif

  if cur_line =~ '^\s*\(\(and\|or\|xor\|unless\)\>\|[+\-*/%><&|!=]\)'
    return base_indent + &sw
  else
    return base_indent
  endif
endfunction

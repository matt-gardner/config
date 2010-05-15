" LaTeX filetype
"	  Language: LaTeX (ft=tex)
"	Maintainer: Srinath Avadhanula
"		 Email: srinath@fastmail.fm

if !exists('s:initLatexSuite')
	let s:initLatexSuite = 1
	exec 'so '.expand('<sfile>:p:h').'/latex-suite/main.vim'

	silent! do LatexSuite User LatexSuiteInitPost
endif

set sw=2
set iskeyword+=:
set iskeyword+=-
set winaltkeys=no

silent! do LatexSuite User LatexSuiteFileType

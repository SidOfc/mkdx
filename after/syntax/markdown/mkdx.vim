if (exists('g:mkdx#settings') && g:mkdx#settings.highlight.enable != 1) | finish | endif

if hlexists('Comment')
  syntax match mkdxListItem '^[ \t]*\([0-9.]\+\|[-*]\) '
  highlight default link mkdxListItem Comment
endif

if hlexists('gitcommitUnmergedFile')
  syntax match mkdxCheckboxEmpty '\[ \]'
  highlight default link mkdxCheckboxEmpty gitcommitUnmergedFile
endif

if hlexists('gitcommitBranch')
  syntax match mkdxCheckboxPending '\[-\]'
  highlight default link mkdxCheckboxPending gitcommitBranch
endif

if hlexists('gitcommitSelectedFile')
  syntax match mkdxCheckboxComplete '\[x\]'
  highlight default link mkdxCheckboxComplete gitcommitSelectedFile
endif

if hlexists('markdownCodeDelimiter')
  syntax match mkdxTildeFence '^[ \t]*\~\~\~\w*'
  highlight default link mkdxTildeFence markdownCodeDelimiter

  if hlexists('markdownCode')
    syn region markdownCode matchgroup=markdownCodeDelimiter start="^\s*\~\~\~\~*.*$" end="^\s*\~\~\~\~*\ze\s*$" keepend
  endif
endif

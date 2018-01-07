syntax match mkdxListItem '^[ \t]*\([0-9.]\+\|[-*]\)'
syntax match mkdxCheckboxEmpty '\[ \]'
syntax match mkdxCheckboxPending '\[-\]'
syntax match mkdxCheckboxComplete '\[x\]'
syntax clear mkdNonListItemBlock

highlight default link mkdxListItem Comment
highlight default link mkdxCheckboxEmpty gitcommitUnmergedFile
highlight default link mkdxCheckboxPending gitcommitBranch
highlight default link mkdxCheckboxComplete gitcommitSelectedFile

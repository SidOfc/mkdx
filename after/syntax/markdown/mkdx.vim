if (exists('g:mkdx#settings') && g:mkdx#settings.highlight.enable != 1) | finish | endif

" https://github.com/mattly/vim-markdown-enhancements/blob/master/after/syntax/markdown.vim
" the table highlighting and CriticMarkup are taken from this repo, which is now read-only,
" thanks @mattly for your contribution, and once again some time later ;)
syn region  mkdxTable start="^\%(\[.*\]\n\)\{}.*|.*\n[-|\:\. ]\+$" end="^\%(\n\[.*\]\n\)\{-}\ze\%(\n[^|]\+\n\)\{-}$" keepend contains=mkdxTableHeader,mkdxTableHeadDelimiter,mkdxTableDelimiter,mkdxTableCaption
syn match   mkdxTableDelimiter "|" contained
syn match   mkdxTableAlign "[\.:]" contained
syn region  mkdxTableHeader start="^\zs.*\ze\n[-|\:\. ]\+$" end="$" nextgroup=mkdxTableHeadDelimiter contained contains=mkdxTableDelimiter
syn match   mkdxTableHeadDelimiter "^[-|\:\.\ ]\+$" contained contains=mkdxTableDelimiter,mkdxTableAlign
syn region  mkdxTableCaption matchgroup=mkdxTableCaptionDelimiter start="^\[" end="\]$" keepend contained

syn match   mkdxListItem '^[ \t]*\([0-9.]\+\|[-*]\) '
syn match   mkdxCheckboxEmpty '\[ \]'
syn match   mkdxCheckboxPending '\[-\]'
syn match   mkdxCheckboxComplete '\[x\]'
syn match   mkdxTildeFence '^[ \t]*\~\~\~\w*'
syn region  mkdxBoldItalic matchgroup=mkdxBoldItalicDelimiter start="[\*_]\{3}" end="[\*_]\{3}" keepend concealends
syn region  mkdxInlineCode matchgroup=mkdxInlineCodeDelimiter start="``\@!" end="``\@!" keepend concealends

syn match   mkdxKbdText '\%(kbd>\)\@<=[^ >]\+\%(<\/\?kbd\)\@='
syn match   mkdxKbdOpening '<kbd>'
syn match   mkdxKbdEnding '<\/kbd>'

" CriticMarkup
" reference: http://criticmarkup.com
syn region mkdxCriticAddition matchgroup=mdCriticAdd start=/{++/ end=/++}/ contains=mdCriticAddStartMark, mdCriticAddEndMark concealends
syn match  mkdxCriticAddStartMark /{++/ contained conceal
syn match  mkdxCriticAddEndMark /++}/ contained conceal
syn region mkdxCriticDeletion matchgroup=mdCriticDel start=/{--/ end=/--}/ contains=mdCriticDelStartMark,mdCriticDelEndMark concealends
syn match  mkdxCriticDelStartMark /{--/ contained conceal
syn match  mkdxCriticDelEndMark /--}/ contained conceal
syn region mkdxCriticSubRemove start=/{\~\~/ end=/.\(\~>\)\@=/ keepend
syn match  mkdxCriticSubStartMark /{\~\~/ contained containedin=mdCriticSubRemove conceal
syn region mkdxCriticSubstitute start=/\~>/ end=/\~\~}/ keepend
syn match  mkdxCriticSubTransMark /\~>/ contained containedin=mdCriticSubstitute conceal
syn match  mkdxCriticSubEndMark /\~\~}/ contained containedin=mdCriticSubstitute conceal
syn region mkdxCriticComment matchgroup=mdCriticExtra start=/{>>/ end=/<<}/ concealends
syn region mkdxCriticHighlight matchgroup=mdCriticExtra start=/{==/ end=/==}/ concealends

if hlexists('Constant')
  highlight default link mkdxTableHeader Constant
  highlight default link mkdxKbdText     Constant
endif

if hlexists('Delimiter')
  highlight default link mkdxTableDelimiter        Delimiter
  highlight default link mkdxTableHeadDelimiter    Delimiter
  highlight default link mkdxTableCaptionDelimiter Delimiter
  highlight default link mkdxBoldItalicDelimiter   Delimiter
  highlight default link mkdxBoldItalic            Delimiter
  highlight default link mkdxKbdOpening            Delimiter
  highlight default link mkdxKbdEnding             mkdxKbdOpening
endif

if hlexists('Identifier')
  highlight default link mkdxTableAlign Identifier
endif

if hlexists('Comment')
  highlight default link mkdxListItem     Comment
  highlight default link mkdxTableCaption Comment
endif

if hlexists('gitcommitUnmergedFile')
  highlight default link mkdxCheckboxEmpty gitcommitUnmergedFile
endif

if hlexists('gitcommitBranch')
  highlight default link mkdxCheckboxPending gitcommitBranch
endif

if hlexists('gitcommitSelectedFile')
  highlight default link mkdxCheckboxComplete gitcommitSelectedFile
endif

if hlexists('markdownCodeDelimiter')
  highlight default link mkdxTildeFence markdownCodeDelimiter
endif

if hlexists('markdownCode')
  highlight default link mkdxInlineCode           markdownCode
  highlight default link mkdxInlineCodeDelimiter  markdownCodeDelimiter
  syn region markdownCode matchgroup=markdownCodeDelimiter start="^\s*\~\~\~\~*.*$" end="^\s*\~\~\~\~*\ze\s*$" keepend
endif

if hlexists('htmlStrike')
    highlight default link mkdxStrikeThrough htmlStrike
    syn region mkdxStrikeThrough matchgroup=markdownStrikeThroughDelimiter start="\S\@<=\~\~\|\~\~\S\@=" end="\S\@<=\~\~\|\~\~\S\@=" keepend contains=markdownLineStart
endif

hi default link mkdxCriticAdd              DiffText
hi default link mkdxCriticAddition         DiffAdd
hi default link mkdxCriticDel              DiffText
hi default link mkdxCriticDeletion         DiffDelete
hi default link mkdxCriticSubRemove        DiffDelete
hi default link mkdxCriticSubstitute       DiffAdd
hi default link mkdxCriticSubStartMark     DiffText
hi default link mkdxCriticSubTransMark     DiffText
hi default link mkdxCriticSubEndMark       DiffText
hi default link mkdxCriticComment          Comment
hi default link mkdxCriticHighlight        Todo
hi default link mkdxCriticExtra            DiffText

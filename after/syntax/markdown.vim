if (g:mkdx#settings.highlight.enable != 1) | finish | endif

" https://github.com/mattly/vim-markdown-enhancements/blob/master/after/syntax/markdown.vim
" the table highlighting and CriticMarkup are taken from this repo, which is now read-only,
" thanks @mattly for your contribution, and once again some time later ;)
"
" guide (todo): https://github.com/fletcher/MultiMarkdown/wiki/MultiMarkdown-Syntax-Guide
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

syn match   mkdxLink '\(https\?:\)\?\/\/[^ ]\{-}\(\.[^ ]\+\)\{0,}\(\.\w\+\)\(\/[^ ]\+\)\?'
syn match   mkdxKbdText '\%(kbd>\)\@<=[^ >]\+\%(<\/\?kbd\)\@='
syn match   mkdxKbdOpening '<kbd>'
syn match   mkdxKbdEnding '<\/kbd>'

if (g:mkdx#settings.links.conceal == 1)
  syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" keepend contained conceal contains=markdownUrl
endif

" CriticMarkup
" reference: http://criticmarkup.com
syn region mkdxCriticAddition matchgroup=mkdxCriticAdd start=/{++/ end=/++}/ contains=mkdxCriticAddStartMark, mkdxCriticAddEndMark concealends
syn match  mkdxCriticAddStartMark /{++/ contained conceal
syn match  mkdxCriticAddEndMark /++}/ contained conceal
syn region mkdxCriticDeletion matchgroup=mkdxCriticDel start=/{--/ end=/--}/ contains=mkdxCriticDelStartMark,mkdxCriticDelEndMark concealends
syn match  mkdxCriticDelStartMark /{--/ contained conceal
syn match  mkdxCriticDelEndMark /--}/ contained conceal
syn region mkdxCriticSubRemove start=/{\~\~/ end=/.\(\~>\)\@=/ keepend
syn match  mkdxCriticSubStartMark /{\~\~/ contained containedin=mkdxCriticSubRemove conceal
syn region mkdxCriticSubstitute start=/\~>/ end=/\~\~}/ keepend
syn match  mkdxCriticSubTransMark /\~>/ contained containedin=mkdxCriticSubstitute
syn match  mkdxCriticSubEndMark /\~\~}/ contained containedin=mkdxCriticSubstitute conceal
syn region mkdxCriticComment matchgroup=mkdxCriticExtra start=/{>>/ end=/<<}/ concealends
syn region mkdxCriticHighlight matchgroup=mkdxCriticExtra start=/{==/ end=/==}/ concealends

if hlexists('markdownUrl')
  highlight default link mkdxLink markdownUrl
endif

if hlexists('Constant')
  highlight default link mkdxTableHeader Constant
  highlight default link mkdxKbdText     Constant
endif

if hlexists('Delimiter')
  highlight default link mkdxTableDelimiter        Delimiter
  highlight default link mkdxTableHeadDelimiter    Delimiter
  highlight default link mkdxTableCaptionDelimiter Delimiter
  highlight default link mkdxBoldItalicDelimiter   Delimiter
  highlight default link mkdxKbdOpening            Delimiter
  highlight default link mkdxKbdEnding             mkdxKbdOpening

  let real_syn_id = synIDtrans(hlID("mkdxBoldItalicDelimiter"))
  let cterm_fg    = synIDattr(real_syn_id, 'fg', 'cterm')
  let gui_fg      = synIDattr(real_syn_id, 'fg', 'gui')

  if (empty(cterm_fg)) | let cterm_fg = '224'    | endif
  if (empty(gui_fg))   | let gui_fg   = 'Orange' | endif

  exe 'highlight default mkdxBoldItalic ctermfg=' .  cterm_fg . ' guifg=' . gui_fg . ' cterm=bold,italic gui=bold,italic'
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

if (mkdx#in_rtp('syntax/yaml.vim') && g:mkdx#settings.highlight.frontmatter.yaml)
  " below code is taken from vim-pandoc-syntax:
  " https://github.com/vim-pandoc/vim-pandoc-syntax/blob/0d1129e5cf1b0e3a90e923c3b5f40133bf153f7c/syntax/pandoc.vim#L558-L565
  try
    unlet! b:current_syntax
    syn include @YAML syntax/yaml.vim
    syn region mkdxYAMLHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^-\{3}\ze\n.\+/ end=/^\([-.]\)\1\{2}$/ keepend contains=@YAML containedin=TOP
  catch /E484/
    syn region mkdxYAMLHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^-\{3}\ze\n.\+/ end=/^\([-.]\)\1\{2}$/ containedin=TOP
  endtry
endif

if (mkdx#in_rtp('syntax/toml.vim') && g:mkdx#settings.highlight.frontmatter.toml)
  try
    unlet! b:current_syntax
    syn include @TOML syntax/toml.vim
    syn region mkdxTOMLHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^+\{3}\ze\n.\+/ end=/^+++$/ keepend contains=@TOML containedin=TOP transparent
  catch /E484/
    syn region mkdxTOMLHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^+\{3}\ze\n.\+/ end=/^+++$/ containedin=TOP
  endtry
endif

if (mkdx#in_rtp('syntax/json.vim') && g:mkdx#settings.highlight.frontmatter.json)
  try
    unlet! b:current_syntax
    syn include @JSON syntax/json.vim
    syn region mkdxJSONHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^{\ze\n.\+/ end=/^+++$/ keepend contains=@TOML containedin=TOP transparent
  catch /E484/
    syn region mkdxJSONHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^{\ze\n.\+/ end=/^}$/ containedin=TOP
  endtry
endif

hi default link mkdxCriticAdd          DiffText
hi default link mkdxCriticAddition     DiffAdd
hi default link mkdxCriticDel          DiffText
hi default link mkdxCriticDeletion     DiffDelete
hi default link mkdxCriticSubRemove    DiffDelete
hi default link mkdxCriticSubstitute   DiffAdd
hi default link mkdxCriticSubStartMark DiffText
hi default link mkdxCriticSubTransMark DiffText
hi default link mkdxCriticSubEndMark   DiffText
hi default link mkdxCriticComment      Comment
hi default link mkdxCriticHighlight    Todo
hi default link mkdxCriticExtra        DiffText

if exists('b:did_ftplugin') | finish | else | let b:did_ftplugin = 1 | endif
let s:defaults          = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'restore_visual':          1,
      \ 'enter':                   { 'enable': 1, 'shift': 0, 'malformed': 1, 'o': 1, 'shifto': 1 },
      \ 'map':                     { 'prefix': '<leader>', 'enable': 1 },
      \ 'tokens':                  { 'enter': ['-', '*', '>'], 'bold': '**', 'italic': '*',
      \                              'list': '-', 'fence': '', 'header': '#', 'strike': '' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'], 'update_tree': 2, 'initial_state': ' ' },
      \ 'toc':                     { 'text': 'TOC', 'list_token': '-', 'position': 0, 'update_on_write': 0,
      \                              'details': { 'enable': 0, 'summary': 'Click to expand {{toc.text}}',
      \                                           'nesting_level': -1, 'child_count': 5, 'child_summary': 'show {{count}} items' } },
      \ 'table':                   { 'divider': '|', 'header_divider': '-',
      \                              'align': { 'left': [], 'center': [], 'right': [],
      \                                         'default': 'center' } },
      \ 'links':                   { 'external': { 'enable': 0, 'timeout': 3, 'host': '', 'relative': 1,
      \                                            'user_agent':  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/9001.0.0000.000 vim-mkdx/1.9.1' },
      \                              'fragment': { 'jumplist': 1, 'complete': 1 } },
      \ 'highlight':               { 'enable': 0 },
      \ 'auto_update':             { 'enable': 1 },
      \ 'fold':                    { 'enable': 0, 'components': ['toc', 'fence'] }
    \ }

if exists('g:mkdx#map_prefix')              | let s:defaults.map.prefix = g:mkdx#map_prefix                         | endif
if exists('g:mkdx#map_keys')                | let s:defaults.map.enable = g:mkdx#map_keys                           | endif
if exists('g:mkdx#checkbox_toggles')        | let s:defaults.checkbox.toggles = g:mkdx#checkbox_toggles             | endif
if exists('g:mkdx#checklist_update_tree')   | let s:defaults.checkbox.update_tree = g:mkdx#checklist_update_tree    | endif
if exists('g:mkdx#restore_visual')          | let s:defaults.restore_visual = g:mkdx#restore_visual                 | endif
if exists('g:mkdx#header_style')            | let s:defaults.tokens.header = g:mkdx#header_style                    | endif
if exists('g:mkdx#table_header_divider')    | let s:defaults.table.header_divider = g:mkdx#table_header_divider     | endif
if exists('g:mkdx#table_divider')           | let s:defaults.table.divider = g:mkdx#table_divider                   | endif
if exists('g:mkdx#enhance_enter')           | let s:defaults.enter.enable = g:mkdx#enhance_enter                    | endif
if exists('g:mkdx#list_tokens')             | let s:defaults.tokens.enter = g:mkdx#list_tokens                      | endif
if exists('g:mkdx#fence_style')             | let s:defaults.tokens.fence = g:mkdx#fence_style                      | endif
if exists('g:mkdx#handle_malformed_indent') | let s:defaults.enter.malformed = g:mkdx#handle_malformed_indent       | endif
if exists('g:mkdx#link_as_img_pat')         | let s:defaults.image_extension_pattern = g:mkdx#link_as_img_pat       | endif
if exists('g:mkdx#bold_token')              | let s:defaults.tokens.bold = g:mkdx#bold_token                        | endif
if exists('g:mkdx#italic_token')            | let s:defaults.tokens.italic = g:mkdx#italic_token                    | endif
if exists('g:mkdx#list_token')              | let s:defaults.tokens.list = g:mkdx#list_token                        | endif
if exists('g:mkdx#toc_list_token')          | let s:defaults.toc.list_token = g:mkdx#toc_list_token                 | endif
if exists('g:mkdx#toc_text')                | let s:defaults.toc.text = g:mkdx#toc_text                             | endif
if exists('g:mkdx#checkbox_initial_state')  | let s:defaults.checkbox.initial_state = g:mkdx#checkbox_initial_state | endif

if (!exists('g:mkdx#settings_initialized'))
  let g:mkdx#settings             = mkdx#MergeSettings(s:defaults, exists('g:mkdx#settings') ? g:mkdx#settings : {})
  let g:mkdx#settings_initialized = 1
  call mkdx#guard_settings()
endif

" backwards compat <= 1.8.0
noremap         <silent> <Plug>(mkdx-checkbox-next)      :call      mkdx#ToggleCheckboxState()<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-prev)      :call      mkdx#ToggleCheckboxState(1)<Cr>
noremap         <silent> <Plug>(mkdx-toggle-quote)       :call      mkdx#ToggleQuote()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checkbox)    :call      mkdx#ToggleCheckboxTask()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checklist)   :call      mkdx#ToggleChecklist()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-list)        :call      mkdx#ToggleList()<Cr>

noremap         <silent> <Plug>(mkdx-checkbox-next-n)    :call      mkdx#ToggleCheckboxState()<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-prev-n)    :call      mkdx#ToggleCheckboxState(1)<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-next-v)    :call      mkdx#ToggleCheckboxState()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-prev-v)    :call      mkdx#ToggleCheckboxState(1)<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-quote-n)     :call      mkdx#ToggleQuote()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-quote-v)     :call      mkdx#ToggleQuote()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checkbox-n)  :call      mkdx#ToggleCheckboxTask()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checkbox-v)  :call      mkdx#ToggleCheckboxTask()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checklist-n) :call      mkdx#ToggleChecklist()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checklist-v) :call      mkdx#ToggleChecklist()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-list-n)      :call      mkdx#ToggleList()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-list-v)      :call      mkdx#ToggleList()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-demote-header)      :<C-U>call mkdx#ToggleHeader()<Cr>
noremap         <silent> <Plug>(mkdx-promote-header)     :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap         <silent> <Plug>(mkdx-wrap-link-n)        :<C-U>call mkdx#WrapLink()<Cr>
noremap         <silent> <Plug>(mkdx-wrap-link-v)        :call      mkdx#WrapLink('v')<Cr>
noremap         <silent> <Plug>(mkdx-jump-to-header)     :call      mkdx#JumpToHeader()<Cr>
noremap         <silent> <Plug>(mkdx-tableize)           :call      mkdx#Tableize()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-quickfix-links)     :call      mkdx#QuickfixDeadLinks()<Cr>
noremap         <silent> <Plug>(mkdx-quickfix-toc)       :call      mkdx#QuickfixHeaders()<Cr>
noremap         <silent> <Plug>(mkdx-generate-toc)       :call      mkdx#GenerateTOC()<Cr>
noremap         <silent> <Plug>(mkdx-update-toc)         :call      mkdx#UpdateTOC()<Cr>
noremap         <silent> <Plug>(mkdx-gen-or-upd-toc)     :call      mkdx#GenerateOrUpdateTOC()<Cr>
noremap         <silent> <Plug>(mkdx-text-italic-n)      :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic, 'mkdx-text-italic-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-bold-n)        :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold, 'mkdx-text-bold-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-inline-code-n) :<C-U>call mkdx#WrapText('n', '`', '`', 'mkdx-text-inline-code-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-strike-n)      :<C-U>call mkdx#WrapStrike('n', 'mkdx-text-strike-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-italic-v)      :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic)<Cr>
noremap         <silent> <Plug>(mkdx-text-bold-v)        :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold)<Cr>
noremap         <silent> <Plug>(mkdx-text-inline-code-v) :<C-U>call mkdx#WrapText('v', '`', '`')<Cr>
noremap         <silent> <Plug>(mkdx-text-strike-v)      :<C-U>call mkdx#WrapStrike('v')<Cr>
noremap         <silent> <Plug>(mkdx-toggle-to-kbd-n)    :call      mkdx#ToggleToKbd()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-to-kbd-v)    :<C-U>call mkdx#ToggleToKbd('v')<Cr>
noremap         <silent> <Plug>(mkdx-shift-o)            :<C-U>call mkdx#ShiftOHandler()<Cr>
noremap         <silent> <Plug>(mkdx-o)                  :<C-U>call mkdx#OHandler()<Cr>
inoremap        <silent> <Plug>(mkdx-enter)              <C-R>=mkdx#EnterHandler()<Cr>:setlocal autoindent<Cr>
inoremap        <silent> <Plug>(mkdx-shift-enter)        <C-R>=mkdx#ShiftEnterHandler()<Cr>
inoremap        <silent> <Plug>(mkdx-insert-kbd)         <kbd></kbd>F<
inoremap        <silent> <Plug>(mkdx-fence-tilde)        <C-R>=mkdx#InsertFencedCodeBlock('~')<Cr>kA
inoremap        <silent> <Plug>(mkdx-fence-backtick)     <C-R>=mkdx#InsertFencedCodeBlock('`')<Cr>kA
inoremap        <silent> <Plug>(mkdx-ctrl-n-compl)       <C-R>=mkdx#InsertCtrlNHandler()<Cr>
inoremap        <silent> <Plug>(mkdx-ctrl-p-compl)       <C-R>=mkdx#InsertCtrlPHandler()<Cr>
inoremap <expr> <silent> <Plug>(mkdx-link-compl)         mkdx#CompleteLink()

if (g:mkdx#settings.links.fragment.complete)
  setlocal completefunc=mkdx#Complete
  setlocal pumheight=15
  setlocal iskeyword+=\-
  setlocal completeopt+=noinsert,menuone
endif

if (g:mkdx#settings.fold.enable)
  setlocal foldmethod=expr
  setlocal foldexpr=mkdx#fold(v:lnum)
endif

if (has('autocmd'))
  augroup MkdxAutocommands
    au!
    au BufWritePre *.md silent! call mkdx#BeforeWrite()
  augroup END
endif

if g:mkdx#settings.map.enable == 1
  let s:gv       = g:mkdx#settings.restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ ['Toggle\ checkbox\ backward',      1, 'n', '-',      '<Plug>(mkdx-checkbox-prev-n)',         ':call mkdx#ToggleCheckboxState(1)<cr>'],
        \ ['Toggle\ checkbox\ forward',       1, 'n', '=',      '<Plug>(mkdx-checkbox-next-n)',         ':call mkdx#ToggleCheckboxState()<cr>'],
        \ ['Toggle\ checkbox\ forward',       1, 'v', '-',      '<Plug>(mkdx-checkbox-prev-v)',         ':call mkdx#ToggleCheckboxState()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ checkbox\ backward',      1, 'v', '=',      '<Plug>(mkdx-checkbox-next-v)',         ':call mkdx#ToggleCheckboxState(1)<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Promote\ header',                 1, 'n', '[',      '<Plug>(mkdx-promote-header)',          ':<C-U>call mkdx#ToggleHeader(1)<cr>'],
        \ ['Demote\ header',                  1, 'n', ']',      '<Plug>(mkdx-demote-header)',           ':<C-U>call mkdx#ToggleHeader()<cr>'],
        \ ['Toggle\ quote',                   1, 'n', "'",      '<Plug>(mkdx-toggle-quote-n)',          ':call mkdx#ToggleQuote()<cr>'],
        \ ['Toggle\ quote',                   1, 'v', "'",      '<Plug>(mkdx-toggle-quote-v)',          ':call mkdx#ToggleQuote()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ checkbox',                1, 'n', "t",      '<Plug>(mkdx-toggle-checkbox-n)',       ':call mkdx#ToggleCheckboxTask()<cr>'],
        \ ['Toggle\ checkbox',                1, 'v', "t",      '<Plug>(mkdx-toggle-checkbox-v)',       ':call mkdx#ToggleCheckboxTask()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ checklist',               1, 'n', "lt",     '<Plug>(mkdx-toggle-checklist-n)',      ':call mkdx#ToggleChecklist()<cr>'],
        \ ['Toggle\ checklist',               1, 'v', "lt",     '<Plug>(mkdx-toggle-checklist-v)',      ':call mkdx#ToggleChecklist()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ list',                    1, 'n', "ll",     '<Plug>(mkdx-toggle-list-n)',           ':call mkdx#ToggleList()<cr>'],
        \ ['Toggle\ list',                    1, 'v', "ll",     '<Plug>(mkdx-toggle-list-v)',           ':call mkdx#ToggleList()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Wrap\ link',                      1, 'n', 'ln',     '<Plug>(mkdx-wrap-link-n)',             ':<C-U>call mkdx#WrapLink()<cr>'],
        \ ['Wrap\ link',                      1, 'v', 'ln',     '<Plug>(mkdx-wrap-link-v)',             ':<C-U>call mkdx#WrapLink("v")<cr>'],
        \ ['Italic',                          1, 'n', '/',      '<Plug>(mkdx-text-italic-n)',           ':<C-U>call mkdx#WrapText("n", g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic, "mkdx-text-italic-n")<Cr>'],
        \ ['Italic',                          1, 'v', '/',      '<Plug>(mkdx-text-italic-v)',           ':<C-U>call mkdx#WrapText("v", g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic)<Cr>'],
        \ ['Bold',                            1, 'n', 'b',      '<Plug>(mkdx-text-bold-n)',             ':<C-U>call mkdx#WrapText("n", g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold, "mkdx-text-bold-n")<Cr>'],
        \ ['Bold',                            1, 'v', 'b',      '<Plug>(mkdx-text-bold-v)',             ':<C-U>call mkdx#WrapText("v", g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold)<Cr>'],
        \ ['Inline\ code',                    1, 'n', '`',      '<Plug>(mkdx-text-inline-code-n)',      ':<C-U>call mkdx#WrapText("n", "`", "`", "mkdx-text-inline-code-n")<cr>'],
        \ ['Inline\ code',                    1, 'v', '`',      '<Plug>(mkdx-text-inline-code-v)',      ':<C-U>call mkdx#WrapText("v", "`", "`")<cr>'],
        \ ['Strike\ through',                 1, 'n', 's',      '<Plug>(mkdx-text-strike-n)',           ':<C-U>call mkdx#WrapText("n", "<strike>", "</strike>", "mkdx-text-strike-n")<cr>'],
        \ ['Strike\ through',                 1, 'v', 's',      '<Plug>(mkdx-text-strike-v)',           ':<C-U>call mkdx#WrapText("v", "<strike>", "</strike>")<cr>'],
        \ ['Convert\ to\ table',              1, 'v', ',',      '<Plug>(mkdx-tableize)',                ':call mkdx#Tableize()<cr>:call mkdx#MaybeRestoreVisual()<Cr>'],
        \ ['Generate\ /\ Update\ TOC',        1, 'n', 'i',      '<Plug>(mkdx-gen-or-upd-toc)',          ':call mkdx#GenerateOrUpdateTOC()<cr>'],
        \ ['Open\ TOC\ in\ quickfix',         1, 'n', 'I',      '<Plug>(mkdx-quickfix-toc)',            ':call mkdx#QuickfixHeaders()<cr>'],
        \ ['Open\ dead\ links\ in\ quickfix', 1, 'n', 'L',      '<Plug>(mkdx-quickfix-links)',          ':call mkdx#QuickfixDeadLinks()<cr>'],
        \ ['Jump\ to\ header',                1, 'n', 'j',      '<Plug>(mkdx-jump-to-header)',          ':call mkdx#JumpToHeader()<cr>'],
        \ ['Toggle\ to\ kbd\ tag',            1, 'n', 'k',      '<Plug>(mkdx-toggle-to-kbd-n)',         ':call mkdx#ToggleToKbd()<cr>'],
        \ ['Toggle\ to\ kbd\ tag',            1, 'v', 'k',      '<Plug>(mkdx-toggle-to-kbd-v)',         ':call mkdx#ToggleToKbd("v")<cr>'],
        \ ['Insert\ kbd\ tag',                0, 'i', '<<tab>', '<Plug>(mkdx-insert-kbd)',              '<kbd></kbd>2hcit'],
        \ ['Backtick\ fenced\ code\ block',   0, 'i', '```',    '<Plug>(mkdx-fence-backtick)',          '<C-R>=mkdx#FencedCodeBlock("`")<Cr>kA'],
        \ ['tilde\ fenced\ code\ block',      0, 'i', '~~~',    '<Plug>(mkdx-fence-tilde)',             '<C-R>=mkdx#FencedCodeBlock("~")<Cr>kA']
        \ ]

  if (g:mkdx#settings.links.fragment.complete)
    if (!hasmapto('<Plug>(mkdx-ctrl-n-compl)', 'i'))
      imap <buffer><silent> <C-n> <Plug>(mkdx-ctrl-n-compl)
    endif

    if (!hasmapto('<Plug>(mkdx-ctrl-p-compl)', 'i'))
      imap <buffer><silent> <C-p> <Plug>(mkdx-ctrl-p-compl)
    endif

    if (!hasmapto('<Plug>(mkdx-link-compl)', 'i'))
      imap <buffer><silent> # <Plug>(mkdx-link-compl)
    endif
  endif

  if (g:mkdx#settings.enter.enable)
    setlocal formatoptions-=r
    setlocal autoindent

    if (!hasmapto('<Plug>(mkdx-shift-enter)', 'i') && g:mkdx#settings.enter.shift)
      imap <buffer><silent> <S-CR> <Plug>(mkdx-shift-enter)
    endif

    if (!hasmapto('<Plug>(mkdx-enter)', 'i'))
      imap <buffer><silent> <Cr> <Plug>(mkdx-enter)
    endif

    if (!hasmapto('<Plug>(mkdx-o)', 'n') && g:mkdx#settings.enter.o)
      nmap <buffer><silent> o <Plug>(mkdx-o)
    endif

    if (!hasmapto('<Plug>(mkdx-shift-o)', 'n') && g:mkdx#settings.enter.shifto)
      nmap <buffer><silent> O <Plug>(mkdx-shift-o)
    end
  endif

  for [label, prefix, mapmode, binding, plug, cmd] in s:bindings
    let mapping = (prefix ? g:mkdx#settings.map.prefix : '') . binding

    if ((mapcheck(mapping, mapmode) == "") && !hasmapto(plug, mapmode))
      if (!empty(cmd) && has('menu'))
        exe mapmode . 'noremenu <silent> <script> Plugin.mkdx.' . label . (mapmode == 'v' ? '\ (Visual)' : '') . '<tab>' . mapping . ' ' . cmd
      end

      exe mapmode . 'map <buffer> ' . mapping . ' ' . plug
    endif
  endfor
endif

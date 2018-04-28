if exists('b:did_ftplugin') | finish | else | let b:did_ftplugin = 1 | endif
let s:defaults          = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'restore_visual':          1,
      \ 'enter':                   { 'enable': 1, 'malformed': 1, 'o': 1, 'shifto': 1 },
      \ 'map':                     { 'prefix': '<leader>', 'enable': 1 },
      \ 'tokens':                  { 'enter': ['-', '*', '>'], 'bold': '**', 'italic': '*',
      \                              'list': '-', 'fence': '', 'header': '#' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'], 'update_tree': 2, 'initial_state': ' ' },
      \ 'toc':                     { 'text': 'TOC', 'list_token': '-', 'position': 0,
      \                              'details': { 'enable': 0, 'summary': 'Click to expand {{toc.text}}' } },
      \ 'table':                   { 'divider': '|', 'header_divider': '-',
      \                              'align': { 'left': [], 'center': [], 'right': [],
      \                                         'default': 'center' } },
      \ 'links':                   { 'external': { 'enable': 0, 'timeout': 3, 'host': '', 'relative': 1,
      \                                            'user_agent':  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/9001.0.0000.000 vim-mkdx/1.4.3' },
      \                              'fragment': { 'jumplist': 1 } },
      \ 'highlight':               { 'enable': 0 }
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

let g:mkdx#settings = exists('g:mkdx#settings_initialized') ? g:mkdx#settings : mkdx#MergeSettings(s:defaults, exists('g:mkdx#settings') ? g:mkdx#settings : {})
let g:mkdx#settings_initialized = 1

noremap         <Plug>(mkdx-checkbox-next)      :call      mkdx#ToggleCheckboxState()<Cr>
noremap         <Plug>(mkdx-checkbox-prev)      :call      mkdx#ToggleCheckboxState(1)<Cr>
noremap         <Plug>(mkdx-toggle-quote)       :call      mkdx#ToggleQuote()<Cr>
noremap         <Plug>(mkdx-toggle-checkbox)    :call      mkdx#ToggleCheckboxTask()<Cr>
noremap         <Plug>(mkdx-toggle-checklist)   :call      mkdx#ToggleChecklist()<Cr>
noremap         <Plug>(mkdx-toggle-list)        :call      mkdx#ToggleList()<Cr>
noremap         <Plug>(mkdx-demote-header)      :<C-U>call mkdx#ToggleHeader()<Cr>
noremap         <Plug>(mkdx-promote-header)     :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap         <Plug>(mkdx-wrap-link-n)        :<C-U>call mkdx#WrapLink()<Cr>
noremap         <Plug>(mkdx-wrap-link-v)        :call      mkdx#WrapLink('v')<Cr>
noremap         <Plug>(mkdx-jump-to-header)     :call      mkdx#JumpToHeader()<Cr>
noremap         <Plug>(mkdx-tableize)           :call      mkdx#Tableize()<Cr>
noremap         <Plug>(mkdx-quickfix-links)     :call      mkdx#QuickfixDeadLinks()<Cr>
noremap         <Plug>(mkdx-quickfix-toc)       :call      mkdx#QuickfixHeaders()<Cr>
noremap         <Plug>(mkdx-generate-toc)       :call      mkdx#GenerateTOC()<Cr>
noremap         <Plug>(mkdx-update-toc)         :call      mkdx#UpdateTOC()<Cr>
noremap         <Plug>(mkdx-gen-or-upd-toc)     :call      mkdx#GenerateOrUpdateTOC()<Cr>
noremap         <Plug>(mkdx-text-italic-n)      :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic, 'mkdx-text-italic-n')<Cr>
noremap         <Plug>(mkdx-text-bold-n)        :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold, 'mkdx-text-bold-n')<Cr>
noremap         <Plug>(mkdx-text-inline-code-n) :<C-U>call mkdx#WrapText('n', '`', '`', 'mkdx-text-inline-code-n')<Cr>
noremap         <Plug>(mkdx-text-strike-n)      :<C-U>call mkdx#WrapText('n', '<strike>', '</strike>', 'mkdx-text-strike-n')<Cr>
noremap         <Plug>(mkdx-text-italic-v)      :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic)<Cr>
noremap         <Plug>(mkdx-text-bold-v)        :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold)<Cr>
noremap         <Plug>(mkdx-text-inline-code-v) :<C-U>call mkdx#WrapText('v', '`', '`')<Cr>
noremap         <Plug>(mkdx-text-strike-v)      :<C-U>call mkdx#WrapText('v', '<strike>', '</strike>')<Cr>
noremap         <Plug>(mkdx-toggle-to-kbd-n)    :call      mkdx#ToggleToKbd()<Cr>
noremap         <Plug>(mkdx-toggle-to-kbd-v)    :<C-U>call mkdx#ToggleToKbd('v')<Cr>
noremap         <Plug>(mkdx-shift-o)            :<C-U>call mkdx#ShiftOHandler()<Cr>
noremap         <Plug>(mkdx-o)                  :<C-U>call mkdx#OHandler()<Cr>
inoremap        <Plug>(mkdx-enter)              <C-R>=mkdx#EnterHandler()<Cr>
inoremap        <Plug>(mkdx-insert-kbd)         <kbd></kbd>2hcit
inoremap        <Plug>(mkdx-fence-tilde)        <C-R>=mkdx#InsertFencedCodeBlock('~')<Cr>kA
inoremap        <Plug>(mkdx-fence-backtick)     <C-R>=mkdx#InsertFencedCodeBlock('`')<Cr>kA
inoremap        <Plug>(mkdx-ctrl-n-compl)       <C-R>=mkdx#InsertCtrlNHandler()<Cr>
inoremap        <Plug>(mkdx-ctrl-p-compl)       <C-R>=mkdx#InsertCtrlPHandler()<Cr>
inoremap <expr> <Plug>(mkdx-link-compl)         mkdx#CompleteLink()

if g:mkdx#settings.map.enable == 1
  let s:gv       = g:mkdx#settings.restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ ['Toggle\ checkbox\ backward',      1, 'n', '-',      '<Plug>(mkdx-checkbox-prev)',           ':call mkdx#ToggleCheckboxState(1)<cr>'],
        \ ['Toggle\ checkbox\ forward',       1, 'n', '=',      '<Plug>(mkdx-checkbox-next)',           ':call mkdx#ToggleCheckboxState()<cr>'],
        \ ['Toggle\ checkbox\ forward',       1, 'v', '-',      '<Plug>(mkdx-checkbox-prev)' . s:gv,    ':call mkdx#ToggleCheckboxState()<cr>' . s:gv],
        \ ['Toggle\ checkbox\ backward',      1, 'v', '=',      '<Plug>(mkdx-checkbox-next)' . s:gv,    ':call mkdx#ToggleCheckboxState(1)<cr>' . s:gv],
        \ ['Promote\ header',                 1, 'n', '[',      '<Plug>(mkdx-promote-header)',          ':<C-U>call mkdx#ToggleHeader(1)<cr>'],
        \ ['Demote\ header',                  1, 'n', ']',      '<Plug>(mkdx-demote-header)',           ':<C-U>call mkdx#ToggleHeader()<cr>'],
        \ ['Toggle\ quote',                   1, 'n', "'",      '<Plug>(mkdx-toggle-quote)',            ':call mkdx#ToggleQuote()<cr>'],
        \ ['Toggle\ quote',                   1, 'v', "'",      '<Plug>(mkdx-toggle-quote)' . s:gv,     ':call mkdx#ToggleQuote()<cr>' . s:gv],
        \ ['Toggle\ checkbox',                1, 'n', "t",      '<Plug>(mkdx-toggle-checkbox)',         ':call mkdx#ToggleCheckboxTask()<cr>'],
        \ ['Toggle\ checkbox',                1, 'v', "t",      '<Plug>(mkdx-toggle-checkbox)' . s:gv,  ':call mkdx#ToggleCheckboxTask()<cr>' . s:gv],
        \ ['Toggle\ checklist',               1, 'n', "lt",     '<Plug>(mkdx-toggle-checklist)',        ':call mkdx#ToggleChecklist()<cr>'],
        \ ['Toggle\ checklist',               1, 'v', "lt",     '<Plug>(mkdx-toggle-checklist)' . s:gv, ':call mkdx#ToggleChecklist()<cr>' . s:gv],
        \ ['Toggle\ list',                    1, 'n', "ll",     '<Plug>(mkdx-toggle-list)',             ':call mkdx#ToggleList()<cr>'],
        \ ['Toggle\ list',                    1, 'v', "ll",     '<Plug>(mkdx-toggle-list)' . s:gv,      ':call mkdx#ToggleList()<cr>' . s:gv],
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
        \ ['Convert\ to\ table',              1, 'v', ',',      '<Plug>(mkdx-tableize)',                ':call mkdx#Tableize()<cr>'],
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

  setlocal completefunc=mkdx#Complete
  setlocal pumheight=15
  imap <buffer><silent> <C-n> <Plug>(mkdx-ctrl-n-compl)
  imap <buffer><silent> <C-p> <Plug>(mkdx-ctrl-p-compl)

  if (g:mkdx#settings.enter.enable)
    setlocal formatoptions-=r
    imap <buffer><silent> <Cr> <Plug>(mkdx-enter)

    if (!hasmapto('<Plug>(mkdx-o)') && g:mkdx#settings.enter.o)
      nmap <buffer><silent> o <Plug>(mkdx-o)
    endif

    if (!hasmapto('<Plug>(mkdx-shift-o)') && g:mkdx#settings.enter.shifto)
      nmap <buffer><silent> O <Plug>(mkdx-shift-o)
    end
  endif

  for [label, prefix, mapmode, binding, plug, cmd] in s:bindings
    let mapping = (prefix ? g:mkdx#settings.map.prefix : '') . binding

    if ((mapcheck(mapping, mapmode) == "") && !hasmapto(plug))
      if (!empty(cmd) && has('menu'))
        exe mapmode . 'noremenu <silent> <script> Plugin.mkdx.' . label . (mapmode == 'v' ? '\ (Visual)' : '') . '<tab>' . mapping . ' ' . cmd
      end

      exe mapmode . 'map <buffer> ' . mapping . ' ' . plug
    endif
  endfor
endif

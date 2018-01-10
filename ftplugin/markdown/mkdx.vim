if exists('b:did_ftplugin') | finish | else | let b:did_ftplugin = 1 | endif
let s:defaults = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'restore_visual':          1,
      \ 'enter':                   { 'enable': 1, 'malformed': 1, 'o': 1 },
      \ 'map':                     { 'prefix': '<leader>', 'enable': 1 },
      \ 'tokens':                  { 'enter': ['-', '*', '>'], 'bold': '**', 'italic': '*', 'list': '-', 'fence': '', 'header': '#' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'], 'update_tree': 2, 'initial_state': ' ' },
      \ 'toc':                     { 'text': "TOC", 'list_token': '-' },
      \ 'table':                   { 'divider': '|', 'header_divider': '-' },
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

fun! s:merge_settings(...)
  let target = deepcopy(get(a:000, 0, {}))
  let a      = get(a:000, 1, {})
  let b      = get(a:000, 2, {})

  for [setting, value] in items(target)
    let aa = has_key(a, setting) ? a[setting] : -1
    let bb = has_key(b, setting) ? b[setting] : -1

    if (type(value) == type({}))
      let target[setting] = s:merge_settings(target[setting], (type(aa) == type({}) ? aa : {}), (type(bb) == type({}) ? bb : {}))
    else
      let target[setting] = bb != -1 ? bb : (aa != -1 ? aa : value)
    endif
  endfor

  return target
endfun

let g:mkdx#settings = exists('g:mkdx#settings_initialized') ? g:mkdx#settings : s:merge_settings(s:defaults, exists('g:mkdx#settings') ? g:mkdx#settings : {})
let g:mkdx#settings_initialized = 1

noremap <silent> <Plug>(mkdx-checkbox-next)      :call      mkdx#ToggleCheckboxState()<Cr>
noremap <silent> <Plug>(mkdx-checkbox-prev)      :call      mkdx#ToggleCheckboxState(1)<Cr>
noremap <silent> <Plug>(mkdx-toggle-quote)       :call      mkdx#ToggleQuote()<Cr>
noremap <silent> <Plug>(mkdx-toggle-checkbox)    :call      mkdx#ToggleCheckboxTask()<Cr>
noremap <silent> <Plug>(mkdx-toggle-checklist)   :call      mkdx#ToggleChecklist()<Cr>
noremap <silent> <Plug>(mkdx-toggle-list)        :call      mkdx#ToggleList()<Cr>
noremap <silent> <Plug>(mkdx-demote-header)      :<C-U>call mkdx#ToggleHeader()<Cr>
noremap <silent> <Plug>(mkdx-promote-header)     :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-n)        :<C-U>call mkdx#WrapLink()<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-v)        :<C-U>call mkdx#WrapLink('v')<Cr>
noremap <silent> <Plug>(mkdx-tableize)           :call      mkdx#Tableize()<Cr>
noremap <silent> <Plug>(mkdx-quickfix-toc)       :call      mkdx#QuickfixHeaders()<Cr>
noremap <silent> <Plug>(mkdx-generate-toc)       :call      mkdx#GenerateTOC()<Cr>
noremap <silent> <Plug>(mkdx-update-toc)         :call      mkdx#UpdateTOC()<Cr>
noremap <silent> <Plug>(mkdx-gen-or-upd-toc)     :call      mkdx#GenerateOrUpdateTOC()<Cr>
noremap <silent> <Plug>(mkdx-text-italic-n)      :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic, 'mkdx-text-italic-n')<Cr>
noremap <silent> <Plug>(mkdx-text-bold-n)        :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold, 'mkdx-text-bold-n')<Cr>
noremap <silent> <Plug>(mkdx-text-inline-code-n) :<C-U>call mkdx#WrapText('n', '`', '`', 'mkdx-text-inline-code-n')<Cr>
noremap <silent> <Plug>(mkdx-text-strike-n)      :<C-U>call mkdx#WrapText('n', '<strike>', '</strike>', 'mkdx-text-strike-n')<Cr>
noremap <silent> <Plug>(mkdx-text-italic-v)      :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic)<Cr>
noremap <silent> <Plug>(mkdx-text-bold-v)        :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold)<Cr>
noremap <silent> <Plug>(mkdx-text-inline-code-v) :<C-U>call mkdx#WrapText('v', '`', '`')<Cr>
noremap <silent> <Plug>(mkdx-text-strike-v)      :<C-U>call mkdx#WrapText('v', '<strike>', '</strike>')<Cr>

if g:mkdx#settings.map.enable == 1
  let s:fstyle   = g:mkdx#settings.tokens.fence == '~' ? '~~~' : (g:mkdx#settings.tokens.fence == '`' ? '```' : '')
  let s:fbtick   = empty(s:fstyle) ? '```' : s:fstyle
  let s:ftilde   = empty(s:fstyle) ? '~~~' : s:fstyle
  let s:gv       = g:mkdx#settings.restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ ['Toggle\ checkbox\ backward',    1, 'n',     '-',      '<Plug>(mkdx-checkbox-prev)'],
        \ ['Toggle\ checkbox\ forward',     1, 'n',     '=',      '<Plug>(mkdx-checkbox-next)'],
        \ ['Toggle\ checkbox\ forward',     1, 'v',     '-',      '<Plug>(mkdx-checkbox-prev)' . s:gv],
        \ ['Toggle\ checkbox\ backward',    1, 'v',     '=',      '<Plug>(mkdx-checkbox-next)' . s:gv],
        \ ['Promote\ header',               1, 'n',     '[',      '<Plug>(mkdx-promote-header)'],
        \ ['Demote\ header',                1, 'n',     ']',      '<Plug>(mkdx-demote-header)'],
        \ ['Toggle\ quote',                 1, 'n',     "'",      '<Plug>(mkdx-toggle-quote)'],
        \ ['Toggle\ quote',                 1, 'v',     "'",      '<Plug>(mkdx-toggle-quote)' . s:gv],
        \ ['Toggle\ checkbox',              1, 'n',     "t",      '<Plug>(mkdx-toggle-checkbox)'],
        \ ['Toggle\ checkbox',              1, 'v',     "t",      '<Plug>(mkdx-toggle-checkbox)' . s:gv],
        \ ['Toggle\ checklist',             1, 'n',     "lt",     '<Plug>(mkdx-toggle-checklist)'],
        \ ['Toggle\ checklist',             1, 'v',     "lt",     '<Plug>(mkdx-toggle-checklist)' . s:gv],
        \ ['Toggle\ list',                  1, 'n',     "ll",     '<Plug>(mkdx-toggle-list)'],
        \ ['Toggle\ list',                  1, 'v',     "ll",     '<Plug>(mkdx-toggle-list)' . s:gv],
        \ ['Wrap\ link',                    1, 'n',     'ln',     '<Plug>(mkdx-wrap-link-n)'],
        \ ['Wrap\ link',                    1, 'v',     'ln',     '<Plug>(mkdx-wrap-link-v)'],
        \ ['Italic',                        1, 'n',     '/',      '<Plug>(mkdx-text-italic-n)'],
        \ ['Italic',                        1, 'v',     '/',      '<Plug>(mkdx-text-italic-v)'],
        \ ['Bold',                          1, 'n',     'b',      '<Plug>(mkdx-text-bold-n)'],
        \ ['Bold',                          1, 'v',     'b',      '<Plug>(mkdx-text-bold-v)'],
        \ ['Inline\ code',                  1, 'n',     '`',      '<Plug>(mkdx-text-inline-code-n)'],
        \ ['Inline\ code',                  1, 'v',     '`',      '<Plug>(mkdx-text-inline-code-v)'],
        \ ['Strike\ through',               1, 'n',     's',      '<Plug>(mkdx-text-strike-n)'],
        \ ['Strike\ through',               1, 'v',     's',      '<Plug>(mkdx-text-strike-v)'],
        \ ['Convert to table',              1, 'v',     ',',      '<Plug>(mkdx-tableize)'],
        \ ['Generate\ /\ Update\ TOC',      1, 'n',     'i',      '<Plug>(mkdx-gen-or-upd-toc)'],
        \ ['Open\ TOC\ in\ quickfix',       1, 'n',     'I',      '<Plug>(mkdx-quickfix-toc)'],
        \ ['Insert\ kbd\ tag',              0, 'i',     '<<tab>', '<kbd></kbd>2hcit'],
        \ ['Backtick\ fenced\ code\ block', 0, 'inore', '```',    s:fbtick . '' . s:fbtick . 'kA'],
        \ ['tilde\ fenced\ code\ block',    0, 'inore', '~~~',    s:ftilde . '' . s:ftilde . 'kA']
        \ ]

  if (g:mkdx#settings.enter.enable)
    imap <buffer><silent> <Cr> <C-R>=mkdx#EnterHandler()<Cr>

    if (g:mkdx#settings.enter.o)
      nmap <buffer><silent> o A<Cr>
    endif
  endif

  for [label, prefix, mapmode, binding, expr] in s:bindings
    let full_mapping = (prefix ? g:mkdx#settings.map.prefix : '') . binding
    let plug_mapping = get(matchlist(binding, '<Plug>([^)]\+)'), 0, -1)

    if (mapcheck(full_mapping, mapmode) == "") && (!plug_mapping || !hasmapto(plug_mapping))
      exe mapmode . 'map <buffer> ' . full_mapping . ' ' . expr
      " if (has('gui'))
      exe mapmode . 'menu <script> Plugin.mkdx.' . label . (mapmode == 'v' ? '\ (Visual)' : '') . '<TAB> ' . full_mapping . (mapmode == 'i' ? '<C-O>' : '') . ':silent call feedkeys(' . full_mapping . ')'
      " endif
    endif
  endfor
endif

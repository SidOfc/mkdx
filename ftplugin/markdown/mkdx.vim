if exists('b:did_ftplugin')                  | finish | else | let b:did_ftplugin = 1             | endif
if !exists('g:mkdx#map_prefix')              | let g:mkdx#map_prefix = '<leader>'                 | endif
if !exists('g:mkdx#map_keys')                | let g:mkdx#map_keys = 1                            | endif
if !exists('g:mkdx#checkbox_toggles')        | let g:mkdx#checkbox_toggles = [' ', '-', 'x']      | endif
if !exists('g:mkdx#checklist_update_tree')   | let g:mkdx#checklist_update_tree = 2               | endif
if !exists('g:mkdx#restore_visual')          | let g:mkdx#restore_visual = 1                      | endif
if !exists('g:mkdx#header_style')            | let g:mkdx#header_style = '#'                      | endif
if !exists('g:mkdx#table_header_divider')    | let g:mkdx#table_header_divider = '-'              | endif
if !exists('g:mkdx#table_divider')           | let g:mkdx#table_divider = '|'                     | endif
if !exists('g:mkdx#enhance_enter')           | let g:mkdx#enhance_enter = 1                       | endif
if !exists('g:mkdx#list_tokens')             | let g:mkdx#list_tokens = ['-', '*', '>']           | endif
if !exists('g:mkdx#fence_style')             | let g:mkdx#fence_style = ''                        | endif
if !exists('g:mkdx#handle_malformed_indent') | let g:mkdx#handle_malformed_indent = 1             | endif
if !exists('g:mkdx#link_as_img_pat')         | let g:mkdx#link_as_img_pat = 'a\?png\|jpe\?g\|gif' | endif
if !exists('g:mkdx#bold_token')              | let g:mkdx#bold_token = '**'                       | endif
if !exists('g:mkdx#italic_token')            | let g:mkdx#italic_token = '*'                      | endif
if !exists('g:mkdx#list_token')              | let g:mkdx#list_token = '-'                        | endif
if !exists('g:mkdx#toc_list_token')          | let g:mkdx#toc_list_token = g:mkdx#list_token      | endif
if !exists('g:mkdx#toc_text')                | let g:mkdx#toc_text = 'TOC'                        | endif
if !exists('g:mkdx#checkbox_initial_state')  | let g:mkdx#checkbox_initial_state = ' '            | endif

noremap <silent> <Plug>(mkdx-checkbox-next)      :call      mkdx#ToggleCheckbox()<Cr>
noremap <silent> <Plug>(mkdx-checkbox-prev)      :call      mkdx#ToggleCheckbox(1)<Cr>
noremap <silent> <Plug>(mkdx-toggle-quote)       :call      mkdx#ToggleQuote()<Cr>
noremap <silent> <Plug>(mkdx-toggle-checkbox)    :call      mkdx#ToggleCheckbox()<Cr>
noremap <silent> <Plug>(mkdx-toggle-checklist)   :call      mkdx#ToggleChecklist()<Cr>
noremap <silent> <Plug>(mkdx-toggle-list)        :call      mkdx#ToggleList()<Cr>
noremap <silent> <Plug>(mkdx-demote-header)      :<C-U>call mkdx#ToggleHeader()<Cr>
noremap <silent> <Plug>(mkdx-promote-header)     :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-n)        :<C-U>call mkdx#WrapLink()<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-v)        :<C-U>call mkdx#WrapLink('v')<Cr>
noremap <silent> <Plug>(mkdx-tableize)           :call      mkdx#Tableize()<Cr>
noremap <silent> <Plug>(mkdx-enhance-enter-i)    :call      mkdx#EnterHandler()<Cr>
noremap <silent> <Plug>(mkdx-generate-toc)       :call      mkdx#GenerateTOC()<Cr>
noremap <silent> <Plug>(mkdx-update-toc)         :call      mkdx#UpdateTOC()<Cr>
noremap <silent> <Plug>(mkdx-gen-or-upd-toc)     :call      mkdx#GenerateOrUpdateTOC()<Cr>
noremap <silent> <Plug>(mkdx-text-italic-n)      :<C-U>call mkdx#WrapText('n', g:mkdx#italic_token, g:mkdx#italic_token, 'mkdx-text-italic-n')<Cr>
noremap <silent> <Plug>(mkdx-text-bold-n)        :<C-U>call mkdx#WrapText('n', g:mkdx#bold_token, g:mkdx#bold_token, 'mkdx-text-bold-n')<Cr>
noremap <silent> <Plug>(mkdx-text-inline-code-n) :<C-U>call mkdx#WrapText('n', '`', '`', 'mkdx-text-inline-code-n')<Cr>
noremap <silent> <Plug>(mkdx-text-strike-n)      :<C-U>call mkdx#WrapText('n', '<strike>', '</strike>', 'mkdx-text-strike-n')<Cr>
noremap <silent> <Plug>(mkdx-text-italic-v)      :<C-U>call mkdx#WrapText('v', g:mkdx#italic_token, g:mkdx#italic_token)<Cr>
noremap <silent> <Plug>(mkdx-text-bold-v)        :<C-U>call mkdx#WrapText('v', g:mkdx#bold_token, g:mkdx#bold_token)<Cr>
noremap <silent> <Plug>(mkdx-text-inline-code-v) :<C-U>call mkdx#WrapText('v', '`', '`')<Cr>
noremap <silent> <Plug>(mkdx-text-strike-v)      :<C-U>call mkdx#WrapText('v', '<strike>', '</strike>')<Cr>

if g:mkdx#map_keys == 1
  let s:fstyle   = g:mkdx#fence_style == '~' ? '~~~' : (g:mkdx#fence_style == '`' ? '```' : '')
  let s:fbtick   = empty(s:fstyle) ? '```' : s:fstyle
  let s:ftilde   = empty(s:fstyle) ? '~~~' : s:fstyle
  let s:gv       = g:mkdx#restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ [1, 'n',     '-',      '<Plug>(mkdx-checkbox-prev)'],
        \ [1, 'n',     '=',      '<Plug>(mkdx-checkbox-next)'],
        \ [1, 'v',     '-',      '<Plug>(mkdx-checkbox-prev)' . s:gv],
        \ [1, 'v',     '=',      '<Plug>(mkdx-checkbox-next)' . s:gv],
        \ [1, 'n',     '[',      '<Plug>(mkdx-promote-header)'],
        \ [1, 'n',     ']',      '<Plug>(mkdx-demote-header)'],
        \ [1, 'n',     "'",      '<Plug>(mkdx-toggle-quote)'],
        \ [1, 'v',     "'",      '<Plug>(mkdx-toggle-quote)' . s:gv],
        \ [1, 'n',     "t",      '<Plug>(mkdx-toggle-checkbox)'],
        \ [1, 'v',     "t",      '<Plug>(mkdx-toggle-checkbox)' . s:gv],
        \ [1, 'n',     "lt",     '<Plug>(mkdx-toggle-checklist)'],
        \ [1, 'v',     "lt",     '<Plug>(mkdx-toggle-checklist)' . s:gv],
        \ [1, 'n',     "ll",     '<Plug>(mkdx-toggle-list)'],
        \ [1, 'v',     "ll",     '<Plug>(mkdx-toggle-list)' . s:gv],
        \ [1, 'n',     'ln',     '<Plug>(mkdx-wrap-link-n)'],
        \ [1, 'v',     'ln',     '<Plug>(mkdx-wrap-link-v)'],
        \ [1, 'n',     '/',      '<Plug>(mkdx-text-italic-n)'],
        \ [1, 'n',     'b',      '<Plug>(mkdx-text-bold-n)'],
        \ [1, 'n',     '`',      '<Plug>(mkdx-text-inline-code-n)'],
        \ [1, 'n',     's',      '<Plug>(mkdx-text-strike-n)'],
        \ [1, 'v',     '/',      '<Plug>(mkdx-text-italic-v)'],
        \ [1, 'v',     'b',      '<Plug>(mkdx-text-bold-v)'],
        \ [1, 'v',     '`',      '<Plug>(mkdx-text-inline-code-v)'],
        \ [1, 'v',     's',      '<Plug>(mkdx-text-strike-v)'],
        \ [1, 'v',     ',',      '<Plug>(mkdx-tableize)'],
        \ [1, 'n',     'i',      '<Plug>(mkdx-gen-or-upd-toc)'],
        \ [0, 'i',     '<<tab>', '<kbd></kbd>2hcit'],
        \ [0, 'inore', '```',    s:fbtick . '' . s:fbtick . 'kA'],
        \ [0, 'inore', '~~~',    s:ftilde . '' . s:ftilde . 'kA'],
        \ [0, 'n',     'o',      'A<Cr>']]

  if (g:mkdx#enhance_enter)
    imap <buffer><silent> <Cr> <Esc><Plug>(mkdx-enhance-enter-i)
  endif

  for [prefix, mapmode, binding, expr] in s:bindings
    let full_mapping = (prefix ? g:mkdx#map_prefix : '') . binding

    if mapcheck(full_mapping, mapmode) == ""
      exe mapmode . 'map <buffer> ' . full_mapping . ' ' . expr
    endif
  endfor
endif

if exists('g:loaded_mkdx')                | finish | else | let g:loaded_mkdx = 1                | endif
if !exists('g:mkdx#map_prefix')           | let g:mkdx#map_prefix = '<leader>'                   | endif
if !exists('g:mkdx#map_keys')             | let g:mkdx#map_keys = 1                              | endif
if !exists('g:mkdx#checkbox_toggles')     | let g:mkdx#checkbox_toggles = [' ', '\~', 'x']       | endif
if !exists('g:mkdx#restore_visual')       | let g:mkdx#restore_visual = 1                        | endif
if !exists('g:mkdx#header_style')         | let g:mkdx#header_style = '#'                        | endif
if !exists('g:mkdx#table_header_divider') | let g:mkdx#table_header_divider = '-'                | endif
if !exists('g:mkdx#table_divider')        | let g:mkdx#table_divider = '|'                       | endif
if !exists('g:mkdx#enhance_enter')        | let g:mkdx#enhance_enter = 1                         | endif
if !exists('g:mkdx#list_tokens')          | let g:mkdx#list_tokens = ['-', '*', '>']             | endif
if !exists('g:mkdx#fence_style')          | let g:mkdx#fence_style = ''                          | endif
if !exists('g:mkdx#toc_text')             | let g:mkdx#toc_text = 'TOC'                          | endif
if !exists('g:mkdx#toc_list_token')       | let g:mkdx#toc_list_token = '-'                      | endif

noremap <silent> <Plug>(mkdx-checkbox-next)   :call mkdx#ToggleCheckbox()<Cr>
noremap <silent> <Plug>(mkdx-checkbox-prev)   :call mkdx#ToggleCheckbox(1)<Cr>
noremap <silent> <Plug>(mkdx-toggle-quote)    :call mkdx#ToggleQuote()<Cr>
noremap <silent> <Plug>(mkdx-demote-header)   :<C-U>call mkdx#ToggleHeader()<Cr>
noremap <silent> <Plug>(mkdx-promote-header)  :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-n)     :<C-U>call mkdx#WrapLink()<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-v)     :<C-U>call mkdx#WrapLink('v')<Cr>
noremap <silent> <Plug>(mkdx-tableize)        :call mkdx#Tableize()<Cr>
noremap <silent> <Plug>(mkdx-enhance-enter-i) :call mkdx#EnterHandler()<Cr>
noremap <silent> <Plug>(mkdx-generate-toc)    :call mkdx#GenerateTOC()<Cr>
noremap <silent> <Plug>(mkdx-update-toc)      :call mkdx#UpdateTOC()<Cr>
noremap <silent> <Plug>(mkdx-gen-or-upd-toc)  :call mkdx#GenerateOrUpdateTOC()<Cr>

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
        \ [1, 'n',     'ln',     '<Plug>(mkdx-wrap-link-n)'],
        \ [1, 'v',     'ln',     '<Plug>(mkdx-wrap-link-v)'],
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
      exe mapmode . 'map <buffer><silent><unique> ' . full_mapping . ' ' . expr
    endif
  endfor
endif

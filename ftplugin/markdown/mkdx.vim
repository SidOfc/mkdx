if exists('g:loaded_mkdx')                | finish | else | let g:loaded_mkdx = 1                | endif
if !exists('g:mkdx#map_prefix')           | let g:mkdx#map_prefix = '<leader>'                   | endif
if !exists('g:mkdx#map_keys')             | let g:mkdx#map_keys = 1                              | endif
if !exists('g:mkdx#checkbox_toggles')     | let g:mkdx#checkbox_toggles = [' ', '\~', 'x', '\!'] | endif
if !exists('g:mkdx#restore_visual')       | let g:mkdx#restore_visual = 1                        | endif
if !exists('g:mkdx#header_style')         | let g:mkdx#header_style = '#'                        | endif
if !exists('g:mkdx#table_header_divider') | let g:mkdx#table_header_divider = '-'                | endif
if !exists('g:mkdx#table_divider')        | let g:mkdx#table_divider = '|'                       | endif
if !exists('g:mkdx#enhance_enter')        | let g:mkdx#enhance_enter = 1                         | endif
if !exists('g:mkdx#list_tokens')          | let g:mkdx#list_tokens = ['-', '*', '>']             | endif

noremap <silent> <Plug>(mkdx-checkbox-next)   :call mkdx#ToggleCheckbox()<Cr>
noremap <silent> <Plug>(mkdx-checkbox-prev)   :call mkdx#ToggleCheckbox(1)<Cr>
noremap <silent> <Plug>(mkdx-toggle-quote)    :call mkdx#ToggleQuote()<Cr>
noremap <silent> <Plug>(mkdx-demote-header)   :<C-U>call mkdx#ToggleHeader()<Cr>
noremap <silent> <Plug>(mkdx-promote-header)  :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-n)     :<C-U>call mkdx#WrapLink()<Cr>
noremap <silent> <Plug>(mkdx-wrap-link-v)     :<C-U>call mkdx#WrapLink('v')<Cr>
noremap <silent> <Plug>(mkdx-tableize)        :call mkdx#Tableize()<Cr>
noremap <silent> <Plug>(mkdx-enhance-enter-i) :call mkdx#EnterHandler()<Cr>

if g:mkdx#map_keys == 1
  let s:gv       = g:mkdx#restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ ['n', '-', '<Plug>(mkdx-checkbox-prev)'],
        \ ['n', '=', '<Plug>(mkdx-checkbox-next)'],
        \ ['v', '-', '<Plug>(mkdx-checkbox-prev)' . s:gv],
        \ ['v', '=', '<Plug>(mkdx-checkbox-next)' . s:gv],
        \ ['n', '[', '<Plug>(mkdx-promote-header)'],
        \ ['n', ']', '<Plug>(mkdx-demote-header)'],
        \ ['n', "'", '<Plug>(mkdx-toggle-quote)'],
        \ ['v', "'", '<Plug>(mkdx-toggle-quote)' . s:gv],
        \ ['n', 'ln', '<Plug>(mkdx-wrap-link-n)'],
        \ ['v', 'ln', '<Plug>(mkdx-wrap-link-v)'],
        \ ['v', ',', '<Plug>(mkdx-tableize)']]

  if (g:mkdx#enhance_enter)
    if (exists('g:loaded_endwise') && g:loaded_endwise)
      iunmap <Cr>
    endif

    imap <buffer><silent><unique> <Cr> <Esc><Plug>(mkdx-enhance-enter-i)
  endif

  for [mapmode, binding, expr] in s:bindings
    let full_mapping = g:mkdx#map_prefix . binding

    if mapcheck(full_mapping, mapmode) == ""
      exe mapmode . 'map <buffer><silent><unique> ' . full_mapping . ' ' . expr
    endif
  endfor
endif

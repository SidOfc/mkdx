if exists('g:loaded_mkdx')
  finish
endif

if !exists('g:mkdx#map_prefix')
  let g:mkdx#map_prefix = '<leader>'
endif

if !exists('g:mkdx#map_keys')
  let g:mkdx#map_keys = 1
endif

if !exists('g:mkdx#checkbox_toggles')
  let g:mkdx#checkbox_toggles = [' ', '\~', 'x', '\!']
endif

if !exists('g:mkdx#checkbox_revis')
  let g:mkdx#checkbox_revis = 1
endif

if !exists('g:mkdx#header_style')
  let g:mkdx#header_style = '#'
endif

if g:mkdx#map_keys == 1
  let s:gv = g:mkdx#checkbox_revis == 1 ? 'gv' : ''

  exe "nnoremap <silent> " . g:mkdx#map_prefix . "- :call mkdx#ToggleCheckbox(0)<Cr>"
  exe "nnoremap <silent> " . g:mkdx#map_prefix . "= :call mkdx#ToggleCheckbox(1)<Cr>"

  exe "nnoremap <silent> " . g:mkdx#map_prefix . "[ :call mkdx#ToggleHeader(1)<Cr>"
  exe "nnoremap <silent> " . g:mkdx#map_prefix . "] :call mkdx#ToggleHeader(0)<Cr>"

  exe "vnoremap <silent> " . g:mkdx#map_prefix . "- :call mkdx#ToggleCheckboxList(0)<Cr>" . s:gv
  exe "vnoremap <silent> " . g:mkdx#map_prefix . "= :call mkdx#ToggleCheckboxList(1)<Cr>" . s:gv

  exe "vnoremap <silent> " . g:mkdx#map_prefix . "ln :call mkdx#WrapLink()<Cr>"
endif

let g:loaded_mkdx = 1

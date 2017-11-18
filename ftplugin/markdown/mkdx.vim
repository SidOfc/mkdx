if exists('g:loaded_mkdx')
  finish
else
  let g:loaded_mkdx = 1
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

if !exists('g:mkdx#table_divider')
  let g:mkdx#table_divider = '|'
endif

if g:mkdx#map_keys == 1
  let s:gv = g:mkdx#checkbox_revis == 1 ? 'gv' : ''

  exe 'nnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . '- :call mkdx#ToggleCheckbox(1)<Cr>'
  exe 'nnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . '= :call mkdx#ToggleCheckbox()<Cr>'

  exe 'nnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . '[ :call mkdx#ToggleHeader(1)<Cr>'
  exe 'nnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . '] :call mkdx#ToggleHeader()<Cr>'

  exe 'vnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . '- :call mkdx#ToggleCheckboxList(1)<Cr>' . s:gv
  exe 'vnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . '= :call mkdx#ToggleCheckboxList()<Cr>' . s:gv

  exe 'vnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . 'ln :call mkdx#WrapLink()<Cr>'

  exe 'vnoremap <buffer> <silent> <unique> ' . g:mkdx#map_prefix . ', :call mkdx#Tableize()<Cr>'
endif

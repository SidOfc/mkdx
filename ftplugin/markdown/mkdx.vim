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

if !exists('g:mkdx#restore_visual')
  let g:mkdx#restore_visual = 1
endif

if !exists('g:mkdx#header_style')
  let g:mkdx#header_style = '#'
endif

if !exists('g:mkdx#table_header_divider')
  let g:mkdx#table_header_divider = '='
endif

if !exists('g:mkdx#table_divider')
  let g:mkdx#table_divider = '|'
endif

if g:mkdx#map_keys == 1
  let s:gv       = g:mkdx#restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ ['n', '-', ':call mkdx#ToggleCheckbox(1)<Cr>'],
        \ ['n', '=', ':call mkdx#ToggleCheckbox()<Cr>'],
        \ ['v', '-', ':call mkdx#ToggleCheckbox(1)<Cr>' . s:gv],
        \ ['v', '=', ':call mkdx#ToggleCheckbox()<Cr>' . s:gv],
        \ ['n', '[', ':call mkdx#ToggleHeader(1)<Cr>'],
        \ ['n', ']', ':call mkdx#ToggleHeader()<Cr>'],
        \ ['n', "'", ':call mkdx#ToggleQuote()<Cr>'],
        \ ['v', "'", ':call mkdx#ToggleQuote()<Cr>' . s:gv],
        \ ['n', 'ln', ':call mkdx#WrapLink()<Cr>'],
        \ ['v', 'ln', ':call mkdx#WrapLink("v")<Cr>'],
        \ ['v', ',', ':call mkdx#Tableize()<Cr>']
        \ ]

  for [mapmode, binding, funcstr] in s:bindings
    let full_mapping = g:mkdx#map_prefix . binding

    if mapcheck(full_mapping, mapmode) == ""
      exe mapmode . 'noremap <buffer> <silent> <unique> ' . full_mapping . ' ' . funcstr
    endif
  endfor
endif

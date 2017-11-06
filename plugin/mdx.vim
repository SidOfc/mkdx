if exists('g:loaded_mxd')
  finish
endif

if !exists('g:mdx#map_prefix')
  let g:mdx#map_prefix = '<leader>'
endif

if !exists('g:mdx#map_keys')
  let g:mdx#map_keys = 1
endif

if !exists('g:mdx#checkbox_toggles')
  let g:mdx#checkbox_toggles = [" ", "\\~", "x", "\\!"]
endif

if g:mdx#map_keys == 1
  exe "nnoremap " . g:mdx#map_prefix . "- :call mdx#ToggleCheckbox(0)<Cr>"
  exe "nnoremap " . g:mdx#map_prefix . "= :call mdx#ToggleCheckbox(1)<Cr>"
  exe "vnoremap " . g:mdx#map_prefix . "ln :call mdx#WrapLink()<Cr>"
endif

let g:loaded_mdx = 1

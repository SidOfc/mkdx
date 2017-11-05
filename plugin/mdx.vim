if exists('g:loaded_mxd')
  finish
endif

let g:loaded_mdx = 1

nnoremap <Leader><Leader>h :call mdx#HelloWorld()

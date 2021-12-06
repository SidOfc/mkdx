let s:defaults = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'restore_visual':          1,
      \ 'gf_on_steroids':          0,
      \ 'enter':                   { 'enable': 1, 'shift': 0, 'malformed': 1, 'o': 1, 'shifto': 1, 'increment': 1 },
      \ 'tab':                     { 'enable': 1 },
      \ 'map':                     { 'prefix': '<leader>', 'enable': 1 },
      \ 'tokens':                  { 'enter': ['-', '*', '>'], 'bold': '**', 'italic': '*',
      \                              'list': '-', 'fence': '', 'header': '#', 'strike': '' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'], 'update_tree': 2, 'initial_state': ' ' },
      \ 'toc':                     { 'text': 'TOC', 'list_token': '-', 'position': 0, 'update_on_write': 0,
      \                              'details': { 'enable': 0, 'summary': 'Click to expand {{toc.text}}',
      \                                           'nesting_level': -1, 'child_count': 5, 'child_summary': 'show {{count}} items' } },
      \ 'table':                   { 'divider': '|', 'header_divider': '-',
      \                              'align': { 'left': [], 'center': [], 'right': [],
      \                                         'default': 'center' } },
      \ 'links':                   { 'external': { 'enable': 0, 'timeout': 3, 'host': '', 'relative': 1,
      \                                            'user_agent':  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/9001.0.0000.000 vim-mkdx/1.10.0' },
      \                              'fragment': { 'jumplist': 1, 'complete': 1 },
      \                              'conceal': 1 },
      \ 'highlight':               { 'enable': 0, 'frontmatter': { 'yaml': 1, 'toml': 0, 'json': 0 } },
      \ 'auto_update':             { 'enable': 1 },
      \ 'fold':                    { 'enable': 0, 'components': ['toc', 'fence'] }
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

if (!exists('g:mkdx#settings_initialized'))
  let g:mkdx#settings             = mkdx#MergeSettings(s:defaults, exists('g:mkdx#settings') ? g:mkdx#settings : {})
  let g:mkdx#settings_initialized = 1
  call mkdx#guard_settings()
endif

function! mkdx#configure(...)
  let g:mkdx#settings = mkdx#MergeSettings(s:defaults, get(a:000, 0, {}))
endfunction

if exists('g:mkdx#map_prefix')              | let g:mkdx#defaults.map.prefix = g:mkdx#map_prefix                         | endif
if exists('g:mkdx#map_keys')                | let g:mkdx#defaults.map.enable = g:mkdx#map_keys                           | endif
if exists('g:mkdx#checkbox_toggles')        | let g:mkdx#defaults.checkbox.toggles = g:mkdx#checkbox_toggles             | endif
if exists('g:mkdx#checklist_update_tree')   | let g:mkdx#defaults.checkbox.update_tree = g:mkdx#checklist_update_tree    | endif
if exists('g:mkdx#restore_visual')          | let g:mkdx#defaults.restore_visual = g:mkdx#restore_visual                 | endif
if exists('g:mkdx#header_style')            | let g:mkdx#defaults.tokens.header = g:mkdx#header_style                    | endif
if exists('g:mkdx#table_header_divider')    | let g:mkdx#defaults.table.header_divider = g:mkdx#table_header_divider     | endif
if exists('g:mkdx#table_divider')           | let g:mkdx#defaults.table.divider = g:mkdx#table_divider                   | endif
if exists('g:mkdx#enhance_enter')           | let g:mkdx#defaults.enter.enable = g:mkdx#enhance_enter                    | endif
if exists('g:mkdx#list_tokens')             | let g:mkdx#defaults.tokens.enter = g:mkdx#list_tokens                      | endif
if exists('g:mkdx#fence_style')             | let g:mkdx#defaults.tokens.fence = g:mkdx#fence_style                      | endif
if exists('g:mkdx#handle_malformed_indent') | let g:mkdx#defaults.enter.malformed = g:mkdx#handle_malformed_indent       | endif
if exists('g:mkdx#link_as_img_pat')         | let g:mkdx#defaults.image_extension_pattern = g:mkdx#link_as_img_pat       | endif
if exists('g:mkdx#bold_token')              | let g:mkdx#defaults.tokens.bold = g:mkdx#bold_token                        | endif
if exists('g:mkdx#italic_token')            | let g:mkdx#defaults.tokens.italic = g:mkdx#italic_token                    | endif
if exists('g:mkdx#list_token')              | let g:mkdx#defaults.tokens.list = g:mkdx#list_token                        | endif
if exists('g:mkdx#toc_list_token')          | let g:mkdx#defaults.toc.list_token = g:mkdx#toc_list_token                 | endif
if exists('g:mkdx#toc_text')                | let g:mkdx#defaults.toc.text = g:mkdx#toc_text                             | endif
if exists('g:mkdx#checkbox_initial_state')  | let g:mkdx#defaults.checkbox.initial_state = g:mkdx#checkbox_initial_state | endif

if (!exists('g:mkdx#settings_initialized') || !exists('*dictwatcheradd'))
  let g:mkdx#settings             = mkdx#MergeSettings(g:mkdx#defaults, exists('g:mkdx#settings') ? g:mkdx#settings : {})
  let g:mkdx#settings_initialized = 1
  call mkdx#guard_settings()
endif

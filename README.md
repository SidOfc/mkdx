# mkdx.vim
---

mkdx.vim is a `markdown` plugin that aims to reduce the time you spend formatting your
markdown documents. It does this by adding some configurable mappings for files with a
markdown **filetype**. Functionality is included for toggling _checkboxes_,
_header levels_ and _quotes_ in addition to _wrapping a visual selection in a link_ and
_converting CSV data to a markdown table_. Visit `:h mkdx` or `:h mkdx-helptags` for
more information.

## Variables

### `g:mkdx#map_prefix`

All mappings are prefixed with a single prefix key.
If you do not like the default (`<leader>`) you can override it:

```viml
" :h mkdx-var-map-prefix
let g:mkdx#map_prefix = '<leader>'
```

### `g:mkdx#map_keys`

If you'd rather full control over what is mapped, you can opt-out all together by setting it to `0`:

```viml
" :h mkdx-var-map-keys
let g:mkdx#map_keys = 1
```

### `g:mkdx#checkbox_toggles`

This setting defines the list of states to use when toggling a checkbox.
It can be overridden by setting it to a list of your choosing. Note that special characters must be escaped!

```viml
" :h mkdx-var-checbox-toggles
let g:mkdx#checkbox_toggles = [' ', '\~', 'x', '\!']
```

### `g:mkdx#checkbox_revis`

This setting enables the restoration of the last visual selection after toggling a list of checkboxes:

```viml
" :h mkdx-var-checbox-revis
let g:mkdx#checbox_revis = 1
```

### `g:mkdx#header_style`

If you want to use a different style for markdown headings (h1, h2, etc...).

```viml
" :h mkdx-var-header-style
let g:mkdx#header_style = '#'
```

### `g:mkdx#table_divider`

You can also change the separator used in markdown tables.

```viml
" :h mkdx-var-table-divider
let g:mkdx#table_divider = '|'
```

## Examples and Mappings

- [Toggling checkboxes](#toggling-checkboxes)
- [Toggling headers](#toggling-headers)
- [Toggling Quotes](#toggling-quotes)
- [Wrap selection in link](#wrap-selection-in-link)
- [Convert CSV to table](#convert-csv-to-table)

### Toggling Checkboxes

Checkboxes can be toggled using <kbd>\<leader\></kbd>+<kbd>=</kbd> and <kbd>\<leader\></kbd>+<kbd>-</kbd>.
Toggling a checkbox means going to the previous or next mark in the list of [`g:mkdx#checbox_toggles`](#gmkdxcheckbox_toggles)

![mkdx toggle checkbox](doc/gifs/vim-mkdx-toggle-checkbox.gif)

### Toggling Headers

![mkdx toggle header](doc/gifs/vim-mkdx-toggle-heading.gif)

### Toggling Quotes

![mkdx toggle quotes](doc/gifs/vim-mkdx-toggle-quote.gif)

### Wrap selection in link

![mkdx wrap selection in link](doc/gifs/vim-mkdx-wrap-link.gif)

### Convert CSV to table

![mkdx convert csv to table](doc/gifs/vim-mkdx-tableize.gif)

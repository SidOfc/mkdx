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
If a mapping contains <kbd>\<PREFIX\></kbd> key, it is the value of this variable.
If you do not like the default (`<leader>`) you can override it:

```viml
" :h mkdx-var-map-prefix
let g:mkdx#map_prefix = '<leader>'
```

### `g:mkdx#map_keys`

If you'd rather full control over what is mapped, you can opt-out all together by setting it to `0`.

```viml
" :h mkdx-var-map-keys
let g:mkdx#map_keys = 1
```

### `g:mkdx#checkbox_toggles`

This setting defines the list of states to use when toggling a checkbox.
It can be overridden by setting it to a list of your choosing. Note that special characters must be escaped!

```viml
" :h mkdx-var-checkbox-toggles
let g:mkdx#checkbox_toggles = [' ', '\~', 'x', '\!']
```

### `g:mkdx#restore_visual`

This setting enables the restoration of the last visual selection after performing an action in visual mode:

```viml
" :h mkdx-var-restore_visual
let g:mkdx#restore_visual = 1
```

### `g:mkdx#header_style`

If you want to use a different style for markdown headings (h1, h2, etc...).

```viml
" :h mkdx-var-header-style
let g:mkdx#header_style = '#'
```

### `g:mkdx#table_header_divider`

You can change the separator used for table headings in markdown tables.

```viml
" :h mkdx-var-table-header-divider
let g:mkdx#table_header_divider = '='
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

![mkdx toggle checkbox](doc/gifs/vim-mkdx-toggle-checkbox.gif)

Checkboxes can be toggled using <kbd>\<PREFIX\></kbd>+<kbd>=</kbd> and <kbd>\<PREFIX\></kbd>+<kbd>-</kbd>.
Toggling a checkbox means going to the previous or next mark in the list of [`g:mkdx#checkbox_toggles`](#gmkdxcheckbox_toggles).

```viml
" :h mkdx-mapping-toggle-checkbox-forward
" :h mkdx-mapping-toggle-checkbox-backward
" :h mkdx-function-toggle-checkbox
```

### Toggling Headers

![mkdx toggle header](doc/gifs/vim-mkdx-toggle-heading.gif)

Increment or decrement a heading with <kbd>\<PREFIX\></kbd>+<kbd>[</kbd> and <kbd>\<PREFIX\></kbd>+<kbd>]</kbd>.
These mappings cycle backward and forward between h1 and h6, wrapping around both ends.
The header character can be changed using [`g:mkdx#header_style`](#gmkdxheader_style).

```viml
" :h mkdx-mapping-increment-header-level
" :h mkdx-mapping-decrement-header-level
" :h mkdx-function-toggle-header
```

### Toggling Quotes

![mkdx toggle quotes](doc/gifs/vim-mkdx-toggle-quote.gif)

Toggle quotes on the current line or a visual selection with <kbd>\<PREFIX\></kbd>+<kbd>'</kbd>.

```viml
" :h mkdx-mapping-toggle-quote
" :h mkdx-function-toggle-quote
```

### Wrap selection in link

![mkdx wrap selection in link](doc/gifs/vim-mkdx-wrap-link.gif)

Wrap visually selected text in an empty markdown link with <kbd>\<PREFIX\></kbd>+<kbd>l</kbd><kbd>n</kbd>

```viml
" :h mkdx-mapping-expand-selection-to-link
" :h mkdx-function-wrap-link
```

### Convert CSV to table

![mkdx convert csv to table](doc/gifs/vim-mkdx-tableize.gif)

Convert visually selected CSV rows to a markdown table with <kbd>\<PREFIX\></kbd>+<kbd>,</kbd>.
The first row will be used as a header.A separator will be inserted below the header.
The divider (`|`) as well as the header divider can be changed with [`g:mkdx#table_divider`](#gmkdxtable_divider)
and [`g:mkdx#table_header_divider`](#gmkdxtable_header_divider).

```viml
" :h mkdx-mapping-csv-to-markdown-table
" :h mkdx-function-tableize
```

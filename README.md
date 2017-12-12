# mkdx.vim

**If this README is displayed incorrectly, please see the version on [github.com](https://github.com/SidOfc/mkdx).**

mkdx.vim is a `markdown` plugin that aims to reduce the time you spend formatting your
markdown documents. It does this by adding some configurable mappings for files with a
markdown **filetype**. Functions are included to handle lists, checkboxes (even lists of checkboxes!), fenced code blocks,
shortcuts, headers and links. In addition to that, this plugin provides a mapping to convert a selection
of CSV data to a markdown table. Visit `:h mkdx` or `:h mkdx-helptags` for more information.

A copy can be found on [vim.sourceforge.io](https://vim.sourceforge.io/scripts/script.php?script_id=5620).
This plugin is also compatible with [repeat.vim](https://github.com/tpope/vim-repeat) by Tim Pope.
Every _normal_ mode mapping can be repeated with the `.` command. Below you will find configurable
settings and examples with default mappings.

# TOC

- [mkdx.vim](#mkdxvim)
- [TOC](#toc)
- [Install](#install)
- [Variables](#variables)
    - [`g:mkdx#map_prefix`](#gmkdxmap_prefix)
    - [`g:mkdx#map_keys`](#gmkdxmap_keys)
    - [`g:mkdx#checkbox_toggles`](#gmkdxcheckbox_toggles)
    - [`g:mkdx#checklist_update_tree`](#gmkdxchecklist_update_tree)
    - [`g:mkdx#restore_visual`](#gmkdxrestore_visual)
    - [`g:mkdx#header_style`](#gmkdxheader_style)
    - [`g:mkdx#table_header_divider`](#gmkdxtable_header_divider)
    - [`g:mkdx#table_divider`](#gmkdxtable_divider)
    - [`g:mkdx#enhance_enter`](#gmkdxenhance_enter)
    - [`g:mkdx#list_tokens`](#gmkdxlist_tokens)
    - [`g:mkdx#fence_style`](#gmkdxfence_style)
    - [`g:mkdx#toc_text`](#gmkdxtoc_text)
    - [`g:mkdx#toc_list_token`](#gmkdxtoc_list_token)
    - [`g:mkdx#handle_malformed_indent`](#gmkdxhandle_malformed_indent)
    - [`g:mkdx#link_as_img_pat`](#gmkdxlink_as_img_pat)
- [Examples and Mappings](#examples-and-mappings)
    - [Insert fenced code block](#insert-fenced-code-block)
    - [Insert `<kbd></kbd>` shortcut](#insert-kbdkbd-shortcut)
    - [List items](#list-items)
    - [Toggling Checkboxes](#toggling-checkboxes)
    - [Toggling Headers](#toggling-headers)
    - [Toggling Quotes](#toggling-quotes)
    - [Wrap text in link](#wrap-text-in-link)
    - [Convert CSV to table](#convert-csv-to-table)
    - [Generate or update TOC](#generate-or-update-toc)

# Install

This plugin should work in _vim_ as well as _nvim_, no clue about _gvim_ but since this plugin only manipulates
text and is written in vimL, it will probably work there too. To install, use a plugin manager of choice like
[Vundle](https://github.com/VundleVim/Vundle.vim) or [Pathogen](https://github.com/tpope/vim-pathogen).

**[Vundle](https://github.com/VundleVim/Vundle.vim)**
```viml
Plugin 'SidOfc/mkdx'

:so $MYVIMRC
:PluginInstall
```

**[NeoBundle](https://github.com/Shougo/neobundle.vim)**
```viml
NeoBundle 'SidOfc/mkdx'

:so $MYVIMRC
:NeoBundleInstall
```

**[vim-plug](https://github.com/junegunn/vim-plug)**
```viml
Plug 'SidOfc/mkdx'

:so $MYVIMRC
:PlugInstall
```

**[Pathogen](https://github.com/tpope/vim-pathogen)**
```sh
cd ~/.vim/bundle
git glone https://github.com/SidOfc/mkdx
```

# Variables

## `g:mkdx#map_prefix`

All mappings are prefixed with a single prefix key.
If a mapping contains <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd> key, it is the value of this variable.
If you do not like the default (`<leader>`) you can override it:

```viml
" :h mkdx-var-map-prefix
let g:mkdx#map_prefix = '<leader>'
```

## `g:mkdx#map_keys`

If you'd rather full control over what is mapped, you can opt-out all together by setting it to `0`.
**Note** that the plugin checks if a keybind exists before creating it. You can safely override every mapping this plugin sets.

```viml
" :h mkdx-var-map-keys
let g:mkdx#map_keys = 1
```

## `g:mkdx#checkbox_toggles`

This setting defines the list of states to use when toggling a checkbox.
It can be overridden by setting it to a list of your choosing. Note that special characters must be escaped!
Also, the list of toggles **must** contain at the very least, 3 items!
The reason for this is that [`g:mkdx#checklist_update_tree`](#gmkdxchecklist_update_tree) uses these
to be able to work with a user supplied list of toggles.

```viml
" :h mkdx-var-checkbox-toggles
let g:mkdx#checkbox_toggles = [' ', '-', 'x']
```

## `g:mkdx#checklist_update_tree`

With this setting on, checkboxes that are toggled within checklists (lists of checkboxes) cause parent and child list items
to be updated automatically. The states from [`g:mkdx#checkbox_toggles`](#gmkdxcheckbox_toggles) are used to check and
update the statusses of any parents. Children are force updated to the same token of their parent. To disable this behaviour
entirely, set this value to `0`. If you do not want children to be updated, set this value to `1` instead.

```viml
" :h mkdx-var-checklist-update-tree
let g:mkdx#checklist_update_tree = 2
```

## `g:mkdx#restore_visual`

This setting enables the restoration of the last visual selection after performing an action in visual mode:

```viml
" :h mkdx-var-restore-visual
let g:mkdx#restore_visual = 1
```

## `g:mkdx#header_style`

If you want to use a different style for markdown headings (h1, h2, etc...).

```viml
" :h mkdx-var-header-style
let g:mkdx#header_style = '#'
```

## `g:mkdx#table_header_divider`

You can change the separator used for table headings in markdown tables.

```viml
" :h mkdx-var-table-header-divider
let g:mkdx#table_header_divider = '-'
```

## `g:mkdx#table_divider`

You can also change the separator used in markdown tables.

```viml
" :h mkdx-var-table-divider
let g:mkdx#table_divider = '|'
```
## `g:mkdx#enhance_enter`

This setting enables auto-appending list items when you are editing a markdown list.
When <kbd>enter</kbd> is pressed, a function is executed to detect wether or not to insert a new list item
or just do a regular enter. unordered lists and numbered lists are both handled correctly.

```viml
" :h mkdx-var-enhance-enter
let g:mkdx#enhance_enter = 1
```

## `g:mkdx#list_tokens`

Used by [`g:mkdx#enhance_enter`](#gmkdxenhance_enter). This is the list of tokens that are supported by default.
Since numbers are handled differently, they are not included in this list but they are supported.

```viml
" :h mkdx-var-list-tokens
let g:mkdx#list_tokens = ['-', '*', '>']
```

## `g:mkdx#fence_style`

Defines the fencing style to use when [inserting a fenced code block](#insert-fenced-code-block).
By default it is set to an empty string, in which case typing tildes will result in a fenced code block
using tildes and typing backticks results in a code block using backticks.

This value can be set to a `` ` `` or a `~` character. When set, the same style will always be used for
fenced code blocks.

```viml
" :h mkdx-var-fence-style
let g:mkdx#fence_style = ''
```

## `g:mkdx#toc_text`

Defines the text to use for the table of contents header itself.

```viml
" :h mkdx-var-toc-text
let g:mkdx#toc_text = 'TOC'
```

## `g:mkdx#toc_list_token`

To change the list token used in the TOC, set `g:mkdx#toc_list_token` to a different value.

```viml
" :h mkdx-var-toc-list-token
let g:mkdx#toc_list_token = '-'
```

## `g:mkdx#handle_malformed_indent`

This setting defines behaviour to use when working with improperly indented
markdown lists. At the moment it works for checklist items that do not have an
`indent()` which is divisible by `shiftwidth`. In which case the indent will
be rounded up to the next indent if it is greater than `&sw / 2` otherwise it
will be rounded down to the previous indent.

~~~viml
" :h mkdx-var-handle-malformed-indent
let g:mkdx#handle_malformed_indent = 1
~~~

## `g:mkdx#link_as_img_pat`

Defines the extensions to search for when identifying the type of link that
will be generated when [wrapping text in a link](#wrap-text-in-link). Setting it to an empty string
disables image wrapping and a regular empty markdown link will be used instead.

~~~viml
" :h mkdx-var-link-as-img-pat
let g:mkdx#link_as_img_pat = 'a\?png\|jpe\?g\|gif'
~~~

# Examples and Mappings

Mappings can be turned off all together with [`g:mkdx#map_keys`](#gmkdxmap_keys).
The plugin checks if a mapping exists before creating it. If it exists, it will not create the mapping.
In case a mapping that this plugin provides doesn't work, please check if you have it in your _.vimrc_.

## Insert fenced code block

|Backtick|Tilde|
|--------|-----|
|![mkdx fenced codeblock backticks](doc/gifs/vim-mkdx-fenced-backtick.gif)|![mkdx fenced codeblock tilde](doc/gifs/vim-mkdx-fenced-squiggly.gif)|

As seen in the gifs, entering either 3 consecutive `` ` `` or `~` characters in _insert_ mode will complete the block
and put the cursor at the end of the opening fence to allow adding a language. The behaviour is controlled
by [`g:mkdx#map_keys`](#gmkdxmap_keys) and like other mappings, it is only mapped if no mapping exists.

Fence style can be controlled using [`g:mkdx#fence_style`](#gmkdxfence_style). This allows you to use one style
for both `` ` `` and `~` blocks.

**Note** that if you want to copy the _{rhs}_ of this mapping in a mapping in your vimrc, you will need to replace
`<C-o>` with a literal `^o` character. In vim, this can be achieved by pressing <kbd>ctrl</kbd>+<kbd>v</kbd> followed
by <kbd>ctrl</kbd>+<kbd>o</kbd>.

```viml
" :h mkdx-mapping-insert-fenced-code-block
  inoremap <buffer><silent><unique> ~~~ ~~~<Enter>~~~<C-o>k<C-o>A
  inoremap <buffer><silent><unique> ``` ```<Enter>```<C-o>k<C-o>A
```

## Insert `<kbd></kbd>` shortcut

![mkdx insert keyboard shortcut](doc/gifs/vim-mkdx-insert-kbd.gif)

This mapping works in _insert_ mode by pressing <kbd>\<</kbd>+<kbd>tab</kbd>.
This mapping is just a regular `imap` that inserts `<kbd></kbd>` and puts your cursor in the tag afterwards.
The behaviour is controlled by [`g:mkdx#map_keys`](#gmkdxmap_keys) and like other mappings,
it is only mapped if no mapping exists.

**Note** that if you want to copy the _{rhs}_ of this mapping in a mapping in your vimrc, you will need to replace
`<C-o>` with a literal `^o` character. In vim, this can be achieved by pressing <kbd>ctrl</kbd>+<kbd>v</kbd> followed
by <kbd>ctrl</kbd>+<kbd>o</kbd>.

```viml
" :h mkdx-mapping-insert-kbd-shortcut
imap <buffer><silent><unique> <<Tab> <kbd></kbd><C-o>2h<C-o>cit
```

## List items

|Unordered|Numbered|
|---------|--------|
|![mkdx unordered list](doc/gifs/vim-mkdx-unordered-list.gif)|![mkdx numbered list](doc/gifs/vim-mkdx-numbered-list.gif)|

When [`g:mkdx#enhance_enter`](#gmkdxenhance_enter) is set (default on), new list tokens will be inserted when
editing a markdown list. This happens on any <kbd>enter</kbd> in _insert_ mode or <kbd>o</kbd> in normal mode.
Additionally, if the list item contains a checkbox (`[ ]` - any state possible) that will also be appended to
the newly inserted item.

```viml
" :h mkdx-mapping-list-items
" :h mkdx-var-enhance-enter
" :h mkdx-var-list-tokens
" :h mkdx-function-enter-handler
```

## Toggling Checkboxes

|Examples|
|--------|
|![mkdx toggle checkbox](doc/gifs/vim-mkdx-toggle-checkbox.gif)|
|![mkdx update checklist](doc/gifs/vim-mkdx-checklist-updater.gif)|

Checkboxes can be toggled using <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>=</kbd> and <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>-</kbd>.
Toggling a checkbox means going to the previous or next mark in the list of [`g:mkdx#checkbox_toggles`](#gmkdxcheckbox_toggles).
When toggling an item which is nested in a list, the parent and child list items will be updated as well.
Automatic updating of checkboxes can be disabled by setting [`g:mkdx#checklist_update_tree`](#gmkdxchecklist_update_tree).
All manipulations work fine in visual as well as normal mode.

A file might not always be indented correctly, the solution to this is [`g:mkdx#handle_malformed_indent`](#gmkdxhandle_malformed_indent).
This setting is enabled by default, it rounds invalid (indentation not divisible by `:h shiftwidth`) either up or down
to the nearest heading level. In the examples below, the `shiftwidth` is set to `4`. The second item is indented by `3` spaces and the
third item is indented by `5` spaces. since `3` is closer to `4` than `0`, it will become `4`. In the case of `5`, it's closer to `4` than `8`
and will also become `4`.

| off | on |
|:---:|:--:|
|![mkdx toggle checkbox malformed off](doc/gifs/vim-mkdx-checklist-malformed-off.gif)|![mkdx toggle checkbox malformed on](doc/gifs/vim-mkdx-checklist-malformed-on.gif)|

```viml
" :h mkdx-mapping-toggle-checkbox-forward
" :h mkdx-mapping-toggle-checkbox-backward
" :h mkdx-function-toggle-checkbox
```

## Toggling Headers

![mkdx toggle header](doc/gifs/vim-mkdx-toggle-heading.gif)

Increment or decrement a heading with <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>[</kbd> and <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>]</kbd>.
These mappings cycle backward and forward between h1 and h6, wrapping around both ends.
The header character can be changed using [`g:mkdx#header_style`](#gmkdxheader_style).

```viml
" :h mkdx-mapping-increment-header-level
" :h mkdx-mapping-decrement-header-level
" :h mkdx-function-toggle-header
```

## Toggling Quotes

![mkdx toggle quotes](doc/gifs/vim-mkdx-toggle-quote.gif)

Toggle quotes on the current line or a visual selection with <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>'</kbd>.

```viml
" :h mkdx-mapping-toggle-quote
" :h mkdx-function-toggle-quote
```

## Wrap text in link

![mkdx wrap text in link](doc/gifs/vim-mkdx-wrap-link.gif)

Wrap the word under the cursor or a visual selection in an empty markdown link
with <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>l</kbd><kbd>n</kbd>. You'll end up in **insert** mode with your
cursor between the parens, e.g. `(|)` where the pipe (`|`) character is the cursor.

If what you're wrapping is an image (only works with visual selections at the moment), an image link will be created
instead. To disable this behaviour, see: [`g:mkdx#link_as_img_pat`](#gmkdxlink_as_img_pat).

```viml
" :h mkdx-mapping-expand-selection-to-link
" :h mkdx-function-wrap-link
```

## Convert CSV to table

![mkdx convert csv to table](doc/gifs/vim-mkdx-tableize-2.gif)

Convert visually selected CSV rows to a markdown table with <kbd>[\<PREFIX\>](#gmkdxmap_prefix)</kbd>+<kbd>,</kbd>.
The first row will be used as a header.A separator will be inserted below the header.
The divider (`|`) as well as the header divider can be changed with [`g:mkdx#table_divider`](#gmkdxtable_divider)
and [`g:mkdx#table_header_divider`](#gmkdxtable_header_divider). Currently, this is only a very simple function.
It cannot handle quoted CSV yet. All it does is split rows by comma's (`,`).

```viml
" :h mkdx-mapping-csv-to-markdown-table
" :h mkdx-function-tableize
```

## Generate or update TOC

![mkdx generate or update table of contents](doc/gifs/vim-mkdx-gen-or-upd-toc.gif)

Press <kbd>[\<PREFIX\>](#gmkdx_map_prefix)</kbd><kbd>i</kbd> to insert a table of contents
at cursor position if one does not exist, otherwise updates the existing TOC.
the text used in the heading can be changed using [`g:mkdx#toc_text`](#gmkdxtoc_text) and the
list style can be changed using [`g:mkdx#toc_list_token`](#gmkdxtoc_list_token).
Stuff inside fenced code blocks is excluded too.

```viml
" :h mkdx-mapping-generate-or-update-toc
" :h mkdx-function-generate-toc
" :h mkdx-function-update-toc
" :h mkdx-function-generate-or-update-toc
```

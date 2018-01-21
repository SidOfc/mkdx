# mkdx.vim [![GitHub tag](https://img.shields.io/github/tag/SidOfc/mkdx.svg?label=version)](releases) [![GitHub stars](https://img.shields.io/github/stars/SidOfc/mkdx.svg)](https://github.com/SidOfc/mkdx/stargazers) [![GitHub issues](https://img.shields.io/github/issues/SidOfc/mkdx.svg)](https://github.com/SidOfc/mkdx/issues)

**If this README is displayed incorrectly, please see the version on [github.com](https://github.com/SidOfc/mkdx).**

mkdx.vim is a `markdown` plugin that aims to reduce the time you spend formatting your
markdown documents. It does this by adding some configurable mappings for files with a
markdown **filetype**. Functions are included to handle lists, checkboxes (even lists of checkboxes!), fenced code blocks,
shortcuts, headers and links. In addition to that, this plugin provides a mapping to convert a selection
of CSV data to a markdown table. And even then, there is more... visit `:h mkdx` or `:h mkdx-helptags` for more information.

My inspiration for this plugin largely came from Emacs' Org mode. One of my colleagues at work uses Org mode,
whenever he's working on his checklists, it seems to require little to no effort to toggle checkboxes within nested lists.
Org mode does two (probably many more) things very well, it gives you a place to put notes, and you can work on those notes very efficiently with mappings.
This plugin aims to be a solution for the latter as for the former, different plugins can be installed.
All the markdown plugins for Vim that I've tried basically serve a different purpose, most provide better syntax highlighting
and some add other handy functions / mappings. This is my definition of a "markdown utility kit". One which I hope to improve in ways that I alone couldn't imagine :)
It includes all the tools needed to be able to quickly and efficiently update, write and edit markdown files.
The markdown flavor will be similar to what you would see in GFM by default, but is not strictly enforced.
A lot of the "G" in "GFM" can be replaced with your own flavors instead. See: [`:h mkdx-settings`](#gmkdxsettings).

A copy can be found on [vim.sourceforge.io](https://vim.sourceforge.io/scripts/script.php?script_id=5620).
This plugin is also compatible with [repeat.vim](https://github.com/tpope/vim-repeat) by Tim Pope.
Every _normal_ mode mapping can be repeated with the `.` command. Below you will find configurable
settings and examples with default mappings.

# TOC

- [mkdx.vim](#mkdxvim---)
- [TOC](#toc)
- [Changelog](#changelog)
    - [21-01-2018 VERSION 0.8.0](#21-01-2018-version-080)
    - [13-01-2018 VERSION 0.7.1](#13-01-2018-version-071)
    - [13-01-2018 VERSION 0.7.0](#13-01-2018-version-070)
- [Install](#install)
- [`g:mkdx#settings`](#gmkdxsettings)
    - [`g:mkdx#settings.image_extension_pattern`](#gmkdxsettingsimage_extension_pattern)
    - [`g:mkdx#settings.restore_visual`](#gmkdxsettingsrestore_visual)
    - [`g:mkdx#settings.map.prefix`](#gmkdxsettingsmapprefix)
    - [`g:mkdx#settings.map.enable`](#gmkdxsettingsmapenable)
    - [`g:mkdx#settings.checkbox.toggles`](#gmkdxsettingscheckboxtoggles)
    - [`g:mkdx#settings.checkbox.update_tree`](#gmkdxsettingscheckboxupdate_tree)
    - [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state)
    - [`g:mkdx#settings.tokens.header`](#gmkdxsettingstokensheader)
    - [`g:mkdx#settings.tokens.enter`](#gmkdxsettingstokensenter)
    - [`g:mkdx#settings.tokens.fence`](#gmkdxsettingstokensfence)
    - [`g:mkdx#settings.tokens.italic`](#gmkdxsettingstokensitalic)
    - [`g:mkdx#settings.tokens.bold`](#gmkdxsettingstokensbold)
    - [`g:mkdx#settings.tokens.list`](#gmkdxsettingstokenslist)
    - [`g:mkdx#settings.table.header_divider`](#gmkdxsettingstableheader_divider)
    - [`g:mkdx#settings.table.divider`](#gmkdxsettingstabledivider)
    - [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable)
    - [`g:mkdx#settings.enter.o`](#gmkdxsettingsentero)
    - [`g:mkdx#settings.enter.shifto`](#gmkdxsettingsentershifto)
    - [`g:mkdx#settings.enter.malformed`](#gmkdxsettingsentermalformed)
    - [`g:mkdx#settings.toc.text`](#gmkdxsettingstoctext)
    - [`g:mkdx#settings.toc.list_token`](#gmkdxsettingstoclist_token)
    - [`g:mkdx#settings.highlight.enable`](#gmkdxsettingshighlightenable)
- [Mappings](#mappings)
- [Unmapping functionality](#unmapping-functionality)
- [Examples](#examples)
    - [Insert fenced code block](#insert-fenced-code-block)
    - [Insert `<kbd></kbd>` shortcut](#insert-kbdkbd-shortcut)
    - [List items](#list-items)
    - [Toggling lists, checklists or checkboxes](#toggling-lists-checklists-or-checkboxes)
        - [Checkboxes](#checkboxes)
        - [Lists](#lists)
        - [Checklists](#checklists)
    - [Checking Checkboxes / Checklists](#checking-checkboxes--checklists)
    - [Toggling and promoting / demoting Headers](#toggling-and-promoting--demoting-headers)
    - [Toggling Quotes](#toggling-quotes)
    - [Wrapping text](#wrapping-text)
        - [As a link](#as-a-link)
        - [As bold / italic / inline-code / strikethrough](#as-bold--italic--inline-code--strikethrough)
    - [Convert CSV to table](#convert-csv-to-table)
    - [Generate or update TOC](#generate-or-update-toc)
    - [Open TOC in quickfix window](#open-toc-in-quickfix-window)
    - [Open TOC using fzf instead of quickfix window](#open-toc-using-fzf-instead-of-quickfix-window)
- [Roadmap](#roadmap)
- [Contributing](#contributing)

# Changelog

The latest changes will be visible in this list.
See [CHANGELOG.md](CHANGELOG.md) for older changes.

## 21-01-2018 VERSION 0.8.0

- Fix some issues with `mkdx#WrapLink`.
- `mkdx#WrapLink` handles selections that include newline character correctly.
- Headers can now also be toggled on / off using `mkdx#ToggleHeader`.
- When deleting a list item anywhere in the list, following list items are decremented by 1.
- Added more tests for
    - decrementing list items
    - promoting / demoting headers
    - Wrapping links and images

## 13-01-2018 VERSION 0.7.1

Add support for <kbd>shift</kbd>+<kbd>O</kbd> in addition to <kbd>enter</kbd> and <kbd>O</kbd> in normal mode.
This will put your cursor on a new empty list item above the current line.

## 13-01-2018 VERSION 0.7.0

Add menu support in terminal vim and gvim if it `:has('menu')`.

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

# `g:mkdx#settings`

All the settings used in mkdx are defined in a `g:mkdx#settings` hash.
If you still have other `g:mkdx#` variables in your _.vimrc_, they should be replaced with an entry in `g:mkdx#settings` instead.
Going forward, no new `g:mkdx#` variables will be added, **only** `g:mkdx#settings` will be extended. For the first major release of mkdx,
I'm planning to remove all `g:mkdx#` variables, except `g:mkdx#settings`. To see a mapping of new settings from old variables, see [this README](https://github.com/SidOfc/mkdx/blob/1a80ab700e6a02459879a8fd1e9e26ceca4f52c4/README.md#gmkdxsettings).

~~~viml
let g:mkdx#settings = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'restore_visual':          1,
      \ 'enter':                   { 'enable': 1, 'malformed': 1, 'o': 1 },
      \ 'map':                     { 'prefix': '<leader>', 'enable': 1 },
      \ 'tokens':                  { 'enter': ['-', '*', '>'],
      \                              'bold': '**', 'italic': '*',
      \                              'list': '-', 'fence': '',
      \                              'header': '#' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'],
      \                              'update_tree': 2,
      \                              'initial_state': ' ' },
      \ 'toc':                     { 'text': "TOC", 'list_token': '-' },
      \ 'table':                   { 'divider': '|',
      \                              'header_divider': '-' },
      \ 'highlight':               { 'enable': 0 }
    \ }
~~~

To overwrite a setting, simply write it as seen above in your _.vimrc_:

~~~viml
let g:mkdx#settings = { 'enter': { 'enable': 0 } }
~~~

Will disable the [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable) setting.
For backwards compatibility, `g:mkdx#` variables are merged into the defaults, this behaviour will be removed in version 1.0.0.
This happens before any `g:mkdx#settings` hash defined in _.vimrc_ is merged with the defaults.
So while `g:mkdx#` variables still work, they are overwritten when you explicitly define them in
a `g:mkdx#settings` variable.

Settings defined in _.vimrc_ are merged with the defaults during initial loading of the plugin.
To overwrite a setting while editing:

~~~viml
:let g:mkdx#settings.enter.enable = 0
~~~

For help, see:

~~~viml
" :h mkdx-settings
~~~

## `g:mkdx#settings.image_extension_pattern`

Defines the extensions to search for when identifying the type of link that
will be generated when [wrapping text in a link](#as-a-link). Setting it to an empty string
disables image wrapping and a regular empty markdown link will be used instead.

~~~viml
" :h mkdx-setting-image-extension-pattern
let g:mkdx#settings = { 'image_extension_pattern': 'a\?png\|jpe\?g\|gif' }
~~~

## `g:mkdx#settings.restore_visual`

This setting enables the restoration of the last visual selection after performing an action in visual mode:

```viml
" :h mkdx-setting-restore-visual
let g:mkdx#settings = { 'restore_visual': 1 }
```

## `g:mkdx#settings.map.prefix`

All mappings are prefixed with a single prefix key.
If a mapping contains <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd> key, it is the value of this variable.
If you do not like the default (`<leader>`) you can override it:

```viml
" :h mkdx-setting-map-prefix
let g:mkdx#settings = { 'map': { 'prefix': '<leader>' } }
```

## `g:mkdx#settings.map.enable`

If you'd rather full control over what is mapped, you can opt-out all together by setting it to `0`.
**Note** that the plugin checks if a keybind exists before creating it. You can safely override every mapping this plugin sets.

```viml
" :h mkdx-setting-map-enable
let g:mkdx#settings = { 'map': { 'enable': 1 } }
```

## `g:mkdx#settings.checkbox.toggles`

This setting defines the list of states to use when toggling a checkbox.
It can be overridden by setting it to a list of your choosing. Note that special characters must be escaped!
Also, the list of toggles **must** contain at the very least, 3 items!
The reason for this is that [`g:mkdx#settings.checkbox.update_tree`](#gmkdxsettingscheckboxupdate_tree) uses these
to be able to work with a user supplied list of toggles.

```viml
" :h mkdx-setting-checkbox-toggles
let g:mkdx#settings = { 'checkbox': { 'toggles': [' ', '-', 'x'] } }
```

## `g:mkdx#settings.checkbox.update_tree`

With this setting on, checkboxes that are toggled within checklists (lists of checkboxes) cause parent and child list items
to be updated automatically. The states from [`g:mkdx#settings.checkbox.toggles`](#gmkdxsettingscheckboxtoggles) are used to check and
update the statusses of any parents. Children are force updated to the same token of their parent. To disable this behaviour
entirely, set this value to `0`. If you do not want children to be updated, set this value to `1` instead.

```viml
" :h mkdx-setting-checkbox-update-tree
let g:mkdx#settings = { 'checkbox': { 'update_tree': 2 } }
```

## `g:mkdx#settings.checkbox.initial_state`

When toggling between checkbox/checklist lines, this defines
what the default value of each inserted checkbox should be.

~~~viml
" :h mkdx-setting-checkbox-initial-state
let g:mkdx#settings = { 'checkbox': { 'initial_state': ' ' } }
~~~

## `g:mkdx#settings.tokens.header`

If you want to use a different style for markdown headings (h1, h2, etc...).

```viml
" :h mkdx-setting-tokens-header
let g:mkdx#settings = { 'tokens': { 'header': '#' } }
```
## `g:mkdx#settings.tokens.enter`

Used by [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable). This is the list of tokens that are supported by default.
Since numbers are handled differently, they are not included in this list but they are supported.

```viml
" :h mkdx-setting-tokens-enter
let g:mkdx#settings = { 'tokens': { 'enter': ['-', '*', '>'] } }
```

## `g:mkdx#settings.tokens.fence`

Defines the fencing style to use when [inserting a fenced code block](#insert-fenced-code-block).
By default it is set to an empty string, in which case typing tildes will result in a fenced code block
using tildes and typing backticks results in a code block using backticks.

This value can be set to a `` ` `` or a `~` character. When set, the same style will always be used for
fenced code blocks.

```viml
" :h mkdx-setting-tokens-fence
let g:mkdx#settings = { 'tokens': { 'fence': '' } }
```

## `g:mkdx#settings.tokens.italic`

This token is used for italicizing the current word under the cursor or a visual selection of text.
See [this section](#as-bold--italic--inline-code--strikethrough) for more details.

~~~viml
" :h mkdx-setting-tokens-italic
let g:mkdx#settings = { 'tokens': { 'italic': '*' } }
~~~

## `g:mkdx#settings.tokens.bold`

This token is used for bolding the current word under the cursor or a visual selection of text.
See [Styling text](#styling-text) for more details.

~~~viml
" :h mkdx-setting-tokens-bold
let g:mkdx#settings = { 'tokens': { 'bold': '**' } }
~~~

## `g:mkdx#settings.tokens.list`

This token defines what list markers should be inserted when toggling list /
checklist items.

~~~viml
" :h mkdx-setting-tokens-list
let g:mkdx#settings = { 'tokens': { 'list': '-' } }
~~~

## `g:mkdx#settings.table.header_divider`

You can change the separator used for table headings in markdown tables.

```viml
" :h mkdx-setting-table-header-divider
let g:mkdx#settings = { 'table': { 'header_divider': '-' } }
```

## `g:mkdx#settings.table.divider`

You can also change the separator used in markdown tables.

```viml
" :h mkdx-setting-table-divider
let g:mkdx#settings = { 'table': { 'divider': '|' } }
```

## `g:mkdx#settings.enter.enable`

This setting enables auto-appending list items when you are editing a markdown list.
When <kbd>enter</kbd> is pressed, a function is executed to detect wether or not to insert a new list item
or just do a regular enter. unordered lists and numbered lists are both handled correctly.

```viml
" :h mkdx-setting-enter-enable
let g:mkdx#settings = { 'enter': { 'enable': 1 } }
```

## `g:mkdx#settings.enter.o`

This setting overwrites normal mode `o` in markdown files and causes `o` to work like pressing `<enter>` at the end of the line
this means that lists, checklists, checkboxes, quotes etcetera are also inserted when pressing `o` in normal mode in addition to `<enter>` in insert mode.
Note that [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable) must be `1` for this to work.

```viml
" :h mkdx-setting-enter-o
let g:mkdx#settings = { 'enter': { 'o': 1 } }
```

## `g:mkdx#settings.enter.shifto`

This setting enables `O` in normal mode to prepend list items above the current line, your cursor will be placed after the newly added item.
Like [`g:mkdx#settings.enter.o`](#gmkdxsettingsentero), checkboxes are also added if they are present on the cursor line.
Note that [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable) must be `1` for this to work.

```viml
" :h mkdx-setting-enter-shifto
let g:mkdx#settings = { 'enter': { 'shifto': 1 } }
```

## `g:mkdx#settings.enter.malformed`

This setting defines behaviour to use when working with improperly indented
markdown lists. At the moment it works for checklist items that do not have an
`indent()` which is divisible by `shiftwidth`. In which case the indent will
be rounded up to the next indent if it is greater than `&sw / 2` otherwise it
will be rounded down to the previous indent.

~~~viml
" :h mkdx-setting-enter-malformed
let g:mkdx#settings = { 'enter': { 'malformed': 1 } }
~~~

## `g:mkdx#settings.toc.text`

Defines the text to use for the table of contents header itself.

```viml
" :h mkdx-setting-toc-text
let g:mkdx#settings = { 'toc': { 'text': 'TOC' } }
```

## `g:mkdx#settings.toc.list_token`

Defines the list token to use in the generated TOC.

```viml
" :h mkdx-setting-toc-list-token
let g:mkdx#settings = { 'toc': { 'list_token': '-' } }
```

## `g:mkdx#settings.highlight.enable`

This setting enables state-specific highlighting for checkboxes.
It will also override the default markdown syntax highlighting scheme to better accomodate the colors used.
The highlighting is linked to the gitcommit* family of highlight groups (and Comment for list items), full list:

- `Comment` is used for list items, e.g. items starting with `-`, `*`, `1.`
- `gitcommitUnmergedFile` is used for empty checkboxes: `[ ]`
- `gitcommitBranch` is used for pending / in-progress checkboxes: `[-]`
- `gitcommitSelectedFile` is used for completed checkboxes: `[x]`

If you want to change the highlighting groups, simply `link` them to different groups:

~~~viml
" :h mkdx-highlighting

" these are the defaults, defined by mkdx in after/syntax/markdown/mkdx.vim
highlight default link mkdxListItem Comment
highlight default link mkdxCheckboxEmpty gitcommitUnmergedFile
highlight default link mkdxCheckboxPending gitcommitBranch
highlight default link mkdxCheckboxComplete gitcommitSelectedFile

" to change the color of list items to the "jsOperator" group, one would write this in their vimrc:
highlight link mkdxListItem jsOperator
~~~

**Note**: syntax highlighting is opt-in _by default_. This means you must explicitly enable this feature to use it.
The reason behind this is that this plugin is not a syntax plugin and maybe you are already using one that does such a thing in a way that works better for you.
You can see it in action in the [Checking checkboxes / checklists](#checking-checkboxes--checklists) examples.

```viml
" :h mkdx-setting-highlight-enable
" :h mkdx-highlighting
" set to 1 to enable.
let g:mkdx#settings = { 'highlight': { 'enable': 0 } }
```

# Mappings

The below list contains all mappings that mkdx creates by default.<br />
To prevent mapping of a key from happening, see: [unmapping functionality](#unmapping-functionality).

|description|modes|mapping|Execute|
|----|----|-------|-------|
|Prev checkbox state|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>-</kbd>|`<Plug>(mkdx-checkbox-prev)`|
|Next checkbox state|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>=</kbd>|`<Plug>(mkdx-checkbox-next)`|
|Promote header|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\[</kbd>|`<Plug>(mkdx-promote-header)`|
|Demote header|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\]</kbd>|`<Plug>(mkdx-demote-header)`|
|Toggle quote|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>'</kbd>|`<Plug>(mkdx-toggle-quote)`|
|Toggle checkbox item|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>t</kbd>|`<Plug>(mkdx-toggle-checkbox)`|
|Toggle checklist item|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>lt</kbd>|`<Plug>(mkdx-toggle-checklist)`|
|Toggle list item|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>ll</kbd>|`<Plug>(mkdx-toggle-list)`|
|Wrap link|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>ln</kbd>|`<Plug>(mkdx-wrap-link-n)`|
|Italicize text|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>/</kbd>|`<Plug>(mkdx-mkdx-text-italic-n)`|
|Bolden text|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>b</kbd>|`<Plug>(mkdx-mkdx-text-bold-n)`|
|Wrap with inline code|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\`</kbd>|`<Plug>(mkdx-mkdx-text-inline-code-n)`|
|Wrap with strikethrough|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>s</kbd>|`<Plug>(mkdx-mkdx-text-strike-n)`|
|CSV to table|visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>,</kbd>|`<Plug>(mkdx-tableize)`|
|Generate / Update TOC|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>i</kbd>|`<Plug>(mkdx-gen-or-upd-toc)`|
|Quickfix TOC|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>I</kbd>|`<Plug>(mkdx-quickfix-toc)`|
|Insert fenced code block|insert|\`\`\`|`` ```<CR>```<ESC>kA ``|
|Insert fenced code block|insert|\~\~\~|`~~~<CR>~~~<ESC>kA`|
|Insert kbd shortcut|insert|<kbd>\<</kbd>+<kbd>tab</kbd>|`<kbd></kbd><ESC>2hcit`|
|<kbd>enter</kbd> handler|insert|<kbd>enter</kbd>|`<C-R>=mkdx#EnterHandler()<Cr>`|
|<kbd>o</kbd> handler|normal|<kbd>o</kbd>|`A<CR>`|
|<kbd>O</kbd> handler|normal|<kbd>O</kbd>|`:call mkdx#ShiftOHandler()<Cr>`|

# Unmapping functionality

In case some functionality gets in your way, you can unmap a specific function quite easily.
There are two different methods we can use to prevent mkdx from creating (well, 2 for _almost_) any mapping:

**Unmapping by mapping**

If you want to unmap specific functionality, you'll have to define a mapping for it.
This is required because the plugin maps its keys when opening a markdown file, so if you `unmap` something,
it will still get mapped to other markdown buffers. To disable any map, first find it [here](#mappings) or at: `:h mkdx-mappings`.

Say you want to disable toggling next checkbox state (mapped to <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>=</kbd>).
In your _.vimrc_, add the following:

~~~viml
" this will disable toggling checkbox next in normal mode.
nmap <leader>= <Nop>

" this will disable toggling checkbox next in visual mode.
vmap <leader>= <Nop>
~~~

The mappings are checked using the value of [`g:mkdx#settings.map.prefix`](#gmkdxsettingsmapprefix) so you may need to check its value first
by running the following: `:echo g:mkdx#settings.map.prefix`. A better way to prevent mkdx from mapping keys is by remapping \<Plug> mappings.
Also, the <kbd>ENTER</kbd> mapping for insert mode cannot be unmapped using this method. This is because any plugin can provide a more
"global" <kbd>ENTER</kbd> mapping (for completing function / if statements for instance) for this functionality (like endwise.vim).
But, there is of course, still a way to stop mkdx from mapping to <kbd>ENTER</kbd> (and **all** other mappings) in the next section.

**Unmapping by \<Plug>**

If you don't know what a \<Plug> is, it is a builtin tool for plugin authors to provide a more
"clear" and user-friendly plugin interface (and to create repeatable mappings with repeat.vim!).
All of the functions of mkdx are mapped using \<Plug> mappings.
To disable a \<Plug> mapping, first find it [here](#mappings) or at: `:h mkdx-plugs`.

Say you want to disable the behaviour for toggling the next checkbox state.
The corresponding \<Plug> is called `<Plug>(mkdx-checkbox-next)`. To disable it, add the following to your _.vimrc_:

~~~viml
map <Plug> <Plug>(mkdx-checkbox-next)
~~~

# Examples

Mappings can be turned off all together with [`g:mkdx#settings.map.enable`](#gmkdxsettingsmapenable).
The plugin checks if a mapping exists before creating it. If it exists, it will not create the mapping.
In case a mapping that this plugin provides doesn't work, please check if you have it in your _.vimrc_.

## Insert fenced code block

|Backtick|Tilde|
|--------|-----|
|![mkdx fenced codeblock backticks](doc/gifs/vim-mkdx-fenced-backtick.gif)|![mkdx fenced codeblock tilde](doc/gifs/vim-mkdx-fenced-squiggly.gif)|

As seen in the gifs, entering either 3 consecutive `` ` `` or `~` characters in _insert_ mode will complete the block
and put the cursor at the end of the opening fence to allow adding a language. The behaviour is controlled
by [`g:mkdx#settings.map.enable`](#gmkdxsettingsmapenable) and like other mappings, it is only mapped if no mapping exists.

Fence style can be controlled using [`g:mkdx#settings.tokens.fence`](#gmkdxsettingstokensfence). This allows you to use one style
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
The behaviour is controlled by [`g:mkdx#settings.map.enable`](#gmkdxsettingsmapenable) and like other mappings,
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

When [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable) is set (default on), new list tokens will be inserted when
editing a markdown list. This happens on any <kbd>enter</kbd> in _insert_ mode or <kbd>o</kbd> and <kbd>O</kbd> in normal mode by default.
Additionally, if the list item contains a checkbox (`[ ]` - any state possible) that will also be appended to
the newly inserted item.

```viml
" :h mkdx-mapping-list-items
" :h mkdx-setting-enter-enable
" :h mkdx-setting-tokens-list
" :h mkdx-function-enter-handler
```

## Toggling lists, checklists or checkboxes

In both normal and visual mode, lines can be toggled back and forth between either checkbox items,
checklist items, or regular list items. In normal mode, the current line will be toggled.
In visual mode, every line in the visual selection will be toggled.

### Checkboxes

![mkdx toggle checkbox line](doc/gifs/vim-mkdx-toggle-checkbox-line.gif)

Checkboxes can be toggled using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>t</kbd>.
This will cause a checkbox to be prepended before the line if it doesn't exist.
The checkbox will be removed instead, if it exists. The initial state can be defined using [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state).

When toggling a checkbox in a list or checklist, the checkbox will be added / removed accordingly:

~~~
- list item           => - [ ] list item
- [ ] checklist item  => - checklist item
* [ ] checklist item  => * checklist item
1. [ ] checklist item => 1. checklist item
~~~

**Note:** the list / checklist support has been added in version *0.4.1*. Prior to that,
the checkbox would be inserted at the start of the line instead of after the list token.

~~~viml
" :h mkdx-mapping-toggle-checkbox
" :h mkdx-function-toggle-checkbox-task
~~~

### Lists

![mkdx toggle list line](doc/gifs/vim-mkdx-toggle-list-line.gif)

Lists can be toggled using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>ll</kbd>.
This will cause a [list token](#gmkdxsettingstokenslist) to be inserted. When present, it will be removed.

When toggling a checkbox or a checklist item, the list token will be added / removed accordingly:

~~~
[ ] checkbox item     => - [ ] checkbox item
- [ ] checklist item  => - checklist item
* [ ] checklist item  => * checklist item
1. [ ] checklist item => 1. checklist item
~~~

**Note:** the checklist support has been added in version *0.4.1*. Prior to that,
tokens other than [`g:mkdx#settings.tokens.list`](#gmkdxsettingstokenslist) weren't toggled.

~~~viml
" :h mkdx-mapping-toggle-list
" :h mkdx-function-toggle-list
~~~

### Checklists

![mkdx toggle checklist line](doc/gifs/vim-mkdx-toggle-checklist-line.gif)

Checklists can be toggled using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>lt</kbd>.
This will cause a [list token](#gmkdxsettingstokenslist) followed by a checkbox to be prepended before the line if it doesn't exist.
If it is already present, it will be removed. Like [Checkboxes](#checkboxes), the initial state of the checkbox can be defined using: [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state).

If the current line or selection is one or multiple list items, a checkbox with state of [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state) will be added:

~~~
- list item  => - [ ] list item
* list item  => * [ ] list item
1. list item => 1. [ ] list item
~~~

If the current line or selection is one or multiple checkboxes, a [`g:mkdx#settings.tokens.list`](#gmkdxsettingstokenslist) will be added.
Any state the checkbox is in will be preserved:

~~~
[ ] list item  => - [ ] list item
[x] list item  => - [x] list item
~~~

**note:** the list item / checkbox support has been added in version *0.4.1*. Prior to that,
toggling checklists only performed a check to see if a checklist item was present or not.

~~~viml
" :h mkdx-mapping-toggle-checklist
" :h mkdx-function-toggle-checklist
~~~

## Checking Checkboxes / Checklists

**Single checkbox:**
![mkdx toggle checkbox](doc/gifs/vim-mkdx-toggle-checkbox-colors.gif)

**Checkbox in checklist:**
![mkdx update checklist](doc/gifs/vim-mkdx-checklist-updater-colors.gif)

Checkboxes can be checked using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>=</kbd> and <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>-</kbd>.
checking a checkbox means going to the previous or next mark in the list of [`g:mkdx#settings.checkbox.toggles`](#gmkdxsettingscheckboxtoggles).
When checking an item which is nested in a list, the parent and child list items will be updated as well.
Automatic updating of checkboxes can be disabled by setting [`g:mkdx#settings.checkbox.update_tree`](#gmkdxsettingscheckboxupdate_tree).
All manipulations work fine in visual as well as normal mode.

You can also see that the checkboxes are highlighted differently depending on state. This is an _opt-in_ setting which you must enable explicitly in your vimrc.
See [`g:mkdx#settings.highlight.enable`](#gmkdxsettingshighlightenable) for more information.

A file might not always be indented correctly, the solution to this is [`g:mkdx#settings.enter.malformed`](#gmkdxsettingsentermalformed).
This setting is enabled by default, it rounds invalid (indentation not divisible by `:h shiftwidth`) either up or down
to the nearest indentation level. In the examples below, the `shiftwidth` is set to `4`. The second item is indented by `3` spaces and the
third item is indented by `5` spaces. since `3` is closer to `4` than `0`, it will become `4`. In the case of `5`, it's closer to `4` than `8`
and will also become `4`.

| off | on |
|:---:|:--:|
|![mkdx toggle checkbox malformed off](doc/gifs/vim-mkdx-checklist-malformed-off-colors.gif)|![mkdx toggle checkbox malformed on](doc/gifs/vim-mkdx-checklist-malformed-on-colors.gif)|

```viml
" :h mkdx-mapping-toggle-checkbox-forward
" :h mkdx-mapping-toggle-checkbox-backward
" :h mkdx-function-toggle-checkbox
```

## Toggling and promoting / demoting Headers

![mkdx toggle header](doc/gifs/vim-mkdx-toggle-heading.gif)

Increment or decrement a heading with <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>[</kbd> and <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>]</kbd>.
As can be seen in the gif, headings can be toggled as well as promoted / demoted with these mappings.
The header character can be changed using [`g:mkdx#settings.tokens.header`](#gmkdxsettingstokensheader).

```viml
" :h mkdx-mapping-increment-header-level
" :h mkdx-mapping-decrement-header-level
" :h mkdx-function-toggle-header
```

## Toggling Quotes

![mkdx toggle quotes](doc/gifs/vim-mkdx-toggle-quote.gif)

Toggle quotes on the current line or a visual selection with <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>'</kbd>.

```viml
" :h mkdx-mapping-toggle-quote
" :h mkdx-function-toggle-quote
```

## Wrapping text

### As a link

![mkdx wrap text in link](doc/gifs/vim-mkdx-wrap-link.gif)

Wrap the word under the cursor or a visual selection in an empty markdown link
with <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>l</kbd><kbd>n</kbd>. You'll end up in **insert** mode with your
cursor between the parens, e.g. `(|)` where the pipe (`|`) character is the cursor.

If what you're wrapping is an image (only works with visual selections at the moment), an image link will be created
instead. To disable this behaviour, see: [`g:mkdx#settings.image_extension_pattern`](#gmkdxsettingsimage_extension_pattern).

```viml
" :h mkdx-mapping-wrap-text-in-link
" :h mkdx-function-wrap-link
```

### As bold / italic / inline-code / strikethrough

**Normal mode:**
![mkdx wrap text in bold / italic / inline-code / strikethrough normal](doc/gifs/vim-mkdx-wrap-text-normal.gif)
**Visual mode:**
![mkdx wrap text in bold / italic / inline-code / strikethrough visual](doc/gifs/vim-mkdx-wrap-text-visual.gif)

Wrap the word (anywhere) under the cursor or a visual selection using the following mappings:

- <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>/</kbd> => *italic*
- <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>b</kbd> => **bold**
- <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\`</kbd> => `inline code`
- <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>s</kbd> => <strike>strikethrough</strike>

As with all other mappings, all the *normal* mode mappings are repeatable.

## Convert CSV to table

![mkdx convert csv to table](doc/gifs/vim-mkdx-tableize-2.gif)

Convert visually selected CSV rows to a markdown table with <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>,</kbd>.
The first row will be used as a header.A separator will be inserted below the header.
The divider (`|`) as well as the header divider can be changed with [`g:mkdx#settings.table.divider`](#gmkdxsettingstabledivider)
and [`g:mkdx#settings.table.header_divider`](#gmkdxsettingstableheader_divider). Currently, this is only a very simple function.
It cannot handle quoted CSV yet. All it does is split rows by comma's (`,`).

```viml
" :h mkdx-mapping-csv-to-markdown-table
" :h mkdx-function-tableize
```

## Generate or update TOC

![mkdx generate or update table of contents](doc/gifs/vim-mkdx-gen-or-upd-toc.gif)

Press <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd><kbd>i</kbd> to insert a table of contents
at cursor position if one does not exist, otherwise updates the existing TOC.
the text used in the heading can be changed using [`g:mkdx#settings.toc.text`](#gmkdxsettingstoctext) and the
list style can be changed using [`g:mkdx#settings.toc.list_token`](#gmkdxsettingstoclist_token).
Stuff inside fenced code blocks is excluded too.

```viml
" :h mkdx-mapping-generate-or-update-toc
" :h mkdx-function-generate-toc
" :h mkdx-function-update-toc
" :h mkdx-function-generate-or-update-toc
```

## Open TOC in quickfix window

![mkdx open toc in quickfix](doc/gifs/vim-mkdx-toggle-qf.gif)

Press <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd><kbd>I</kbd> to load all the markdown headers in a quickfix window.
You can jump around using regular quickfix commands afterwards, as shown in the gif using `:cn` for example.

~~~viml
" :h mkdx-mapping-quickfix-table-of-contents
" :h mkdx-function-quickfix-headers
~~~

## Open TOC using [fzf](https://github.com/junegunn/fzf.vim) instead of quickfix window

![mkdx open toc using fzf](doc/gifs/vim-mkdx-fzf-goto-header.gif)

This is not built-in to the plugin but I just thought "why not, I'd use that".
So I started working on a little snippet in my [vimrc](https://github.com/SidOfc/dotfiles/blob/76393e2881c5577a316698eafb73c7dae36984bd/.vimrc#L340-L359) (included some comments here):

~~~viml
fun! s:MkdxGoToHeader(header)
    " given a line: '  84: # Header'
    " this will match the number 84 and move the cursor to the start of that line
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
endfun

fun! s:MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')

    " if the text is empty or no lnum is present, return the empty string
    if (empty(text) || empty(lnum)) | return text | endif

    " We can't jump to it if we dont know the line number so that must be present in the outpt line.
    " We also add extra padding up to 4 digits, so I hope your markdown files don't grow beyond 99.9k lines ;)
    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
endfun

fun! s:MkdxFzfQuickfixHeaders()
    " passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
    " this allows you to create a 'source' for fzf.
    " first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
    " then, we strip out any remaining empty headers.
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
            \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
          \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>
~~~

# Roadmap

This roadmap is here to give you an idea of what's next, When features are suggested and are going to be implemented
or new bugs are found they will show up in this list. This list isn't a queue, sometimes the order of tasks will change.
This is because some tasks such as "Write tests" might take a while to complete in comparison to implementing a certain feature or fixing a bug for example.

- [x] Refactor settings into single variable while backwards compatible
- [x] Improve line type toggles to better handle list / checklists
- [x] Document settings instead of variables in README and mkdx.txt
- [x] Refactor some [hairy plugin](https://github.com/SidOfc/mkdx/blob/f8c58e13f81b3501c154d3e61ba9d8dab704f8c9/autoload/mkdx.vim#L359-L388) code.
- [x] Add opt-in syntax highlighting for list items and checkbox states
- [x] Write tests (even I'm surprised here, thanks again [junegunn for yet another awesome plugin!](https://github.com/junegunn/vader.vim))
- [ ] Add a github Wiki

# Contributing

Found a bug or want to report an issue? Take a look at the [CONTRIBUTING](CONTRIBUTING.md) file for more information.

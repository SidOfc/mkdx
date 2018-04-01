# mkdx.vim [![GitHub tag](https://img.shields.io/github/tag/SidOfc/mkdx.svg?label=version)](releases) [![GitHub issues](https://img.shields.io/github/issues/SidOfc/mkdx.svg)](https://github.com/SidOfc/mkdx/issues)

![mkdx update checklist](doc/gifs/vim-mkdx-gen-or-upd-toc.gif)

mkdx.vim is a `markdown` plugin that aims to reduce the time you spend formatting your
markdown documents. It does this by adding some configurable mappings for files with a
markdown **filetype**. Functions are included to handle lists, checkboxes (even lists of checkboxes!), fenced code blocks,
shortcuts, headers and links. In addition to that, this plugin provides a mapping to convert a selection
of CSV data to a markdown table. And there's even more :D  
Visit `:h mkdx` or `:h mkdx-helptags` for more information.

A copy can be found on [vim.sourceforge.io](https://vim.sourceforge.io/scripts/script.php?script_id=5620).
This plugin is also compatible with [repeat.vim](https://github.com/tpope/vim-repeat) by Tim Pope.
Every _normal_ mode mapping can be repeated with the `.` command. Below you will find configurable
settings and examples with default mappings.

# Table of Contents

<details>
<summary>Click to expand Table of Contents</summary>
<ul>
    <li><a href="#mkdxvim--">mkdx.vim</a></li>
    <li><a href="#table-of-contents">Table of Contents</a></li>
    <li><a href="#changelog">Changelog</a><ul>
        <li><a href="#01-04-2018-version-120">01-04-2018 VERSION 1.2.0</a></li>
        <li><a href="#31-03-2018-version-110">31-03-2018 VERSION 1.1.0</a></li>
        <li><a href="#25-03-2018-version-102">25-03-2018 VERSION 1.0.2</a></li>
    </ul></li>
    <li><a href="#install">Install</a></li>
    <li><a href="#examples">Examples</a><ul>
        <li><a href="#insert-fenced-code-block">Insert fenced code block</a></li>
        <li><a href="#insert-kbdkbd-shortcut">Insert <code>&lt;kbd&gt;&lt;/kbd&gt;</code> shortcut</a></li>
        <li><a href="#inserting-list-items">Inserting list items</a></li>
        <li><a href="#converting-from--to-lists-checklists-or-checkboxes">Converting from / to lists, checklists or checkboxes</a><ul>
            <li><a href="#checkboxes">Checkboxes</a></li>
            <li><a href="#lists">Lists</a></li>
            <li><a href="#checklists">Checklists</a></li>
        </ul></li>
        <li><a href="#completing-checkboxes--checklists">Completing Checkboxes / Checklists</a></li>
        <li><a href="#toggling-and-promoting--demoting-headers">Toggling and promoting / demoting Headers</a></li>
        <li><a href="#toggling-kbd--shortcuts">Toggling &lt;kbd /&gt; shortcuts</a></li>
        <li><a href="#toggling-quotes">Toggling Quotes</a></li>
        <li><a href="#wrapping-text">Wrapping text</a><ul>
            <li><a href="#as-a-link">As a link</a></li>
            <li><a href="#as-bold--italic--inline-code--strikethrough">As bold / italic / inline-code / strikethrough</a><ul>
                <li><a href="#normal-mode">Normal mode</a></li>
                <li><a href="#visual-mode">Visual mode</a></li>
            </ul></li>
        </ul></li>
        <li><a href="#convert-csv-to-table">Convert CSV to table</a></li>
        <li><a href="#generate-or-update-toc">Generate or update TOC</a></li>
        <li><a href="#generate-or-update-toc-as-details">Generate or update TOC as <code>&lt;details&gt;</code></a></li>
        <li><a href="#open-toc-in-quickfix-window">Open TOC in quickfix window</a></li>
        <li><a href="#open-toc-using-fzf-instead-of-quickfix-window">Open TOC using fzf instead of quickfix window</a></li>
    </ul></li>
    <li><a href="#gmkdxsettings"><code>g:mkdx#settings</code></a><ul>
        <li><a href="#gmkdxsettingsimage_extension_pattern"><code>g:mkdx#settings.image_extension_pattern</code></a></li>
        <li><a href="#gmkdxsettingsrestore_visual"><code>g:mkdx#settings.restore_visual</code></a></li>
        <li><a href="#gmkdxsettingsmapprefix"><code>g:mkdx#settings.map.prefix</code></a></li>
        <li><a href="#gmkdxsettingsmapenable"><code>g:mkdx#settings.map.enable</code></a></li>
        <li><a href="#gmkdxsettingscheckboxtoggles"><code>g:mkdx#settings.checkbox.toggles</code></a></li>
        <li><a href="#gmkdxsettingscheckboxupdate_tree"><code>g:mkdx#settings.checkbox.update_tree</code></a></li>
        <li><a href="#gmkdxsettingscheckboxinitial_state"><code>g:mkdx#settings.checkbox.initial_state</code></a></li>
        <li><a href="#gmkdxsettingstokensheader"><code>g:mkdx#settings.tokens.header</code></a></li>
        <li><a href="#gmkdxsettingstokensenter"><code>g:mkdx#settings.tokens.enter</code></a></li>
        <li><a href="#gmkdxsettingstokensfence"><code>g:mkdx#settings.tokens.fence</code></a></li>
        <li><a href="#gmkdxsettingstokensitalic"><code>g:mkdx#settings.tokens.italic</code></a></li>
        <li><a href="#gmkdxsettingstokensbold"><code>g:mkdx#settings.tokens.bold</code></a></li>
        <li><a href="#gmkdxsettingstokenslist"><code>g:mkdx#settings.tokens.list</code></a></li>
        <li><a href="#gmkdxsettingstableheader_divider"><code>g:mkdx#settings.table.header_divider</code></a></li>
        <li><a href="#gmkdxsettingstabledivider"><code>g:mkdx#settings.table.divider</code></a></li>
        <li><a href="#gmkdxsettingsenterenable"><code>g:mkdx#settings.enter.enable</code></a></li>
        <li><a href="#gmkdxsettingsentero"><code>g:mkdx#settings.enter.o</code></a></li>
        <li><a href="#gmkdxsettingsentershifto"><code>g:mkdx#settings.enter.shifto</code></a></li>
        <li><a href="#gmkdxsettingsentermalformed"><code>g:mkdx#settings.enter.malformed</code></a></li>
        <li><a href="#gmkdxsettingstoctext"><code>g:mkdx#settings.toc.text</code></a></li>
        <li><a href="#gmkdxsettingstoclist_token"><code>g:mkdx#settings.toc.list_token</code></a></li>
        <li><a href="#gmkdxsettingstocposition"><code>g:mkdx#settings.toc.position</code></a></li>
        <li><a href="#gmkdxsettingstocdetailsenable"><code>g:mkdx#settings.toc.details.enable</code></a></li>
        <li><a href="#gmkdxsettingstocdetailssummary"><code>g:mkdx#settings.toc.details.summary</code></a></li>
        <li><a href="#gmkdxsettingshighlightenable"><code>g:mkdx#settings.highlight.enable</code></a></li>
    </ul></li>
    <li><a href="#mappings">Mappings</a></li>
    <li><a href="#remapping-functionality">Remapping functionality</a></li>
    <li><a href="#unmapping-functionality">Unmapping functionality</a><ul>
        <li><a href="#using-nop">Using <code>&lt;Nop&gt;</code></a></li>
        <li><a href="#using-plug">Using <code>&lt;Plug&gt;</code></a></li>
    </ul></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
</ul>
</details>

# Changelog

The latest changes will be visible in this list.
See [CHANGELOG.md](CHANGELOG.md) for older changes.

## 01-04-2018 VERSION 1.2.0

- Added feature: Support generating [table of contents inside `<details>` tag](#generate-or-update-toc-as-details).

## 31-03-2018 VERSION 1.1.0

- Stricter rules for highlighting (do not highlight bold markers at start of line as list items).
- Fix TOC links using headings containing <kbd /> tags.
- Fix deep merging of `g:mkdx#settings` hash.
- Add setting to place TOC in fixed position.

## 25-03-2018 VERSION 1.0.2

- Fix incorrect <Plug> mapping detection
- Update README, add remapping section

# Install

This plugin is tested using [Vader.vim](https://github.com/junegunn/vader.vim) in _vim_, _nvim_ and _mvim_.

To install, use a plugin manager of choice like
[Vundle](https://github.com/VundleVim/Vundle.vim) or [Pathogen](https://github.com/tpope/vim-pathogen).

[Vundle](https://github.com/VundleVim/Vundle.vim)
```viml
Plugin 'SidOfc/mkdx'

:so $MYVIMRC
:PluginInstall
```

[NeoBundle](https://github.com/Shougo/neobundle.vim)
```viml
NeoBundle 'SidOfc/mkdx'

:so $MYVIMRC
:NeoBundleInstall
```

[vim-plug](https://github.com/junegunn/vim-plug)
```viml
Plug 'SidOfc/mkdx'

:so $MYVIMRC
:PlugInstall
```

[Pathogen](https://github.com/tpope/vim-pathogen)
```sh
cd ~/.vim/bundle
git clone https://github.com/SidOfc/mkdx
```

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

## Inserting list items

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

## Converting from / to lists, checklists or checkboxes

In both normal and visual mode, lines can be toggled back and forth between either checkbox items,
checklist items, or regular list items. In normal mode, the current line will be toggled.
In visual mode, every line in the visual selection will be toggled.

### Checkboxes

![mkdx toggle checkbox line](doc/gifs/vim-mkdx-toggle-checkbox-line.gif)

Checkboxes can be toggled using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>t</kbd>.
This will cause a checkbox to be prepended before the line if it doesn't exist.
The checkbox will be removed instead, if it exists. The initial state can be defined using [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state).

When toggling a checkbox in a list or checklist, the checkbox will be added / removed accordingly:

```
- list item           => - [ ] list item
- [ ] checklist item  => - checklist item
* [ ] checklist item  => * checklist item
1. [ ] checklist item => 1. checklist item
```

**Note:** the list / checklist support has been added in version *0.4.1*. Prior to that,
the checkbox would be inserted at the start of the line instead of after the list token.

```viml
" :h mkdx-mapping-toggle-checkbox
" :h mkdx-function-toggle-checkbox-task
```

### Lists

![mkdx toggle list line](doc/gifs/vim-mkdx-toggle-list-line.gif)

Lists can be toggled using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>ll</kbd>.
This will cause a [list token](#gmkdxsettingstokenslist) to be inserted. When present, it will be removed.

When toggling a checkbox or a checklist item, the list token will be added / removed accordingly:

```
[ ] checkbox item     => - [ ] checkbox item
- [ ] checklist item  => - checklist item
* [ ] checklist item  => * checklist item
1. [ ] checklist item => 1. checklist item
```

**Note:** the checklist support has been added in version *0.4.1*. Prior to that,
tokens other than [`g:mkdx#settings.tokens.list`](#gmkdxsettingstokenslist) weren't toggled.

```viml
" :h mkdx-mapping-toggle-list
" :h mkdx-function-toggle-list
```

### Checklists

![mkdx toggle checklist line](doc/gifs/vim-mkdx-toggle-checklist-line.gif)

Checklists can be toggled using <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>lt</kbd>.
This will cause a [list token](#gmkdxsettingstokenslist) followed by a checkbox to be prepended before the line if it doesn't exist.
If it is already present, it will be removed. Like [Checkboxes](#checkboxes), the initial state of the checkbox can be defined using: [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state).

If the current line or selection is one or multiple list items, a checkbox with state of [`g:mkdx#settings.checkbox.initial_state`](#gmkdxsettingscheckboxinitial_state) will be added:

```
- list item  => - [ ] list item
* list item  => * [ ] list item
1. list item => 1. [ ] list item
```

If the current line or selection is one or multiple checkboxes, a [`g:mkdx#settings.tokens.list`](#gmkdxsettingstokenslist) will be added.
Any state the checkbox is in will be preserved:

```
[ ] list item  => - [ ] list item
[x] list item  => - [x] list item
```

**note:** the list item / checkbox support has been added in version *0.4.1*. Prior to that,
toggling checklists only performed a check to see if a checklist item was present or not.

```viml
" :h mkdx-mapping-toggle-checklist
" :h mkdx-function-toggle-checklist
```

## Completing Checkboxes / Checklists

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

Increment or decrement a heading with <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\[</kbd> and <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\]</kbd>.
As can be seen in the gif, headings can be toggled as well as promoted / demoted with these mappings.
The header character can be changed using [`g:mkdx#settings.tokens.header`](#gmkdxsettingstokensheader).

```viml
" :h mkdx-mapping-increment-header-level
" :h mkdx-mapping-decrement-header-level
" :h mkdx-function-toggle-header
```

## Toggling \<kbd /> shortcuts

![mkdx toggle kbd shortcuts](doc/gifs/vim-mkdx-toggle-kbd.gif)

**Note:** *does not work with multiline selection*

Quickly toggle plain text shortcuts to markdown shortcuts and back with <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>'</kbd>.

```viml
" :h mkdx-mapping-toggle-kbd-shortcut
" :h mkdx-function-toggle-to-kbd
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

#### Normal mode
![mkdx wrap text in bold / italic / inline-code / strikethrough normal](doc/gifs/vim-mkdx-wrap-text-normal.gif)

#### Visual mode
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

If you want to place the TOC always as the _[N]th_ header, see [`g:mkdx#settings.toc.position`](#gmkdxsettingstocposition).

```viml
" :h mkdx-mapping-generate-or-update-toc
" :h mkdx-function-generate-toc
" :h mkdx-function-update-toc
" :h mkdx-function-generate-or-update-toc
```

## Generate or update TOC as `<details>`

![mkdx generate or update table of contents as details](doc/gifs/vim-mkdx-gen-or-upd-toc-details.gif)

Github supports the `<details>` and `<summary>` tags! With these, we can make an expandable table of contents (like this README).
Unfortunately though, markdown isn't supported inside the `<details>` tag, not even with `markdown=1` (not from what I've tried anyway, let me know if you do!).
So instead the TOC itself will be rendered as HTML nested `<ul>` tags with `<li><a></a></li>` tags.

**NOTE:** This requires you to enable [`g:mkdx#settings.toc.details.enable`](#gmkdxsettingstocdetailsenable)!

<details>
<summary>Click to expand example</summary>
<ul>
<li><a href="#mkdxvim--">mkdx.vim</a></li>
<li><a href="#toc">TOC</a></li>
<li><a href="#changelog">Changelog</a></li>
<li><ul>
<li><a href="#31-03-2018-version-110">31-03-2018 VERSION 1.1.0</a></li>
<li><a href="#25-03-2018-version-102">25-03-2018 VERSION 1.0.2</a></li>
<li><a href="#24-03-2018-version-101">24-03-2018 VERSION 1.0.1</a></li>
</ul></li>
<li><a href="#install">Install</a></li>
<li><a href="#examples">Examples</a></li>
</ul>
</details>

## Open TOC in quickfix window

![mkdx open toc in quickfix](doc/gifs/vim-mkdx-toggle-qf.gif)

Press <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd><kbd>I</kbd> to load all the markdown headers in a quickfix window.
You can jump around using regular quickfix commands afterwards, as shown in the gif using `:cn` for example.

```viml
" :h mkdx-mapping-quickfix-table-of-contents
" :h mkdx-function-quickfix-headers
```

## Open TOC using [fzf](https://github.com/junegunn/fzf.vim) instead of quickfix window

![mkdx open toc using fzf](doc/gifs/vim-mkdx-fzf-goto-header.gif)

This is not built-in to the plugin but I just thought "why not, I'd use that".
So I started working on a little snippet in my [vimrc](https://github.com/SidOfc/dotfiles/blob/76393e2881c5577a316698eafb73c7dae36984bd/.vimrc#L340-L359) (included some comments here):

```viml
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
```

# `g:mkdx#settings`

All the settings used in mkdx are defined in a `g:mkdx#settings` hash.
If you still have other `g:mkdx#` variables in your _.vimrc_, they should be replaced with an entry in `g:mkdx#settings` instead.
Going forward, no new `g:mkdx#` variables will be added, **only** `g:mkdx#settings` will be extended.
To see a mapping of new settings from old variables, see [this README](https://github.com/SidOfc/mkdx/blob/1a80ab700e6a02459879a8fd1e9e26ceca4f52c4/README.md#gmkdxsettings).

```viml
" :h mkdx-settings
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
      \ 'toc':                     { 'text': "TOC", 'list_token': '-',
      \                              'position': 0,
      \                              'details': {
      \                                 'enable': 0,
      \                                 'summary': 'Click to expand {{toc.text}}'
      \                              }
      \                            },
      \ 'table':                   { 'divider': '|',
      \                              'header_divider': '-' },
      \ 'highlight':               { 'enable': 0 }
    \ }
```

To overwrite a setting, simply write it as seen above in your _.vimrc_:

```viml
" :h mkdx-settings
let g:mkdx#settings = { 'enter': { 'enable': 0 } }
```

Will disable the [`g:mkdx#settings.enter.enable`](#gmkdxsettingsenterenable) setting.
For backwards compatibility, `g:mkdx#` variables are merged into the defaults.
This happens before any `g:mkdx#settings` hash defined in _.vimrc_ is merged with the defaults.
So while `g:mkdx#` variables still work, they are overwritten when you explicitly define them in
a `g:mkdx#settings` variable.

Settings defined in _.vimrc_ are merged with the defaults during initial loading of the plugin.  
To overwrite a setting while editing:

```viml
" :h mkdx-settings
:let g:mkdx#settings.enter.enable = 0
```

## `g:mkdx#settings.image_extension_pattern`

Defines the extensions to search for when identifying the type of link that
will be generated when [wrapping text in a link](#as-a-link). Setting it to an empty string
disables image wrapping and a regular empty markdown link will be used instead.

```viml
" :h mkdx-setting-image-extension-pattern
let g:mkdx#settings = { 'image_extension_pattern': 'a\?png\|jpe\?g\|gif' }
```

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
Note: that the plugin checks if a keybind exists before creating it. Mappings defined in your _.vimrc_ will not be overwritten.

```viml
" :h mkdx-setting-map-enable
let g:mkdx#settings = { 'map': { 'enable': 1 } }
```

## `g:mkdx#settings.checkbox.toggles`

Defines the list of states to use when toggling a checkbox.
It can be set to a list of your choosing. Special characters must be escaped!
Also, the list of toggles **must** contain at the very least, 2 items!

```viml
" :h mkdx-setting-checkbox-toggles
let g:mkdx#settings = { 'checkbox': { 'toggles': [' ', '-', 'x'] } }

" GFM supported list (e.g. on GitHub)
let g:mkdx#settings = { 'checkbox': { 'toggles': [' ', 'x'] } }
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

```viml
" :h mkdx-setting-checkbox-initial-state
let g:mkdx#settings = { 'checkbox': { 'initial_state': ' ' } }
```

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

```viml
" :h mkdx-setting-tokens-italic
let g:mkdx#settings = { 'tokens': { 'italic': '*' } }
```

## `g:mkdx#settings.tokens.bold`

This token is used for bolding the current word under the cursor or a visual selection of text.
See [Styling text](#styling-text) for more details.

```viml
" :h mkdx-setting-tokens-bold
let g:mkdx#settings = { 'tokens': { 'bold': '**' } }
```

## `g:mkdx#settings.tokens.list`

This token defines what list markers should be inserted when toggling list /
checklist items.

```viml
" :h mkdx-setting-tokens-list
let g:mkdx#settings = { 'tokens': { 'list': '-' } }
```

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

**NOTE:** When this setting is enabled, mkdx will execute a `setlocal formatoptions-=r` to prevent duplicate list markers from being inserted.

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

```viml
" :h mkdx-setting-enter-malformed
let g:mkdx#settings = { 'enter': { 'malformed': 1 } }
```

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

## `g:mkdx#settings.toc.position`

The position at which to place the TOC, `0` is used for cursor.
If a number `> 0` is supplied, the TOC will be generated ABOVE that header.
e.g. setting it to `1` will cause it to be the first heading of your document.

```viml
" :h mkdx-setting-toc-position
let g:mkdx#settings = { 'toc': { 'position': 0 } }
```

## `g:mkdx#settings.toc.details.enable`

This setting controls wether the generated TOC will be output as a regular _markdown_ list or inside a `<details>` tag.
See: [Generate or update TOC as `<details>`](#generate-or-update-toc-as-details) for an example.
By default, this option is disabled. To use it, set it's value to `1` instead.

```viml
" :h mkdx-setting-toc-details-enable
let g:mkdx#settings = { 'toc': { 'details': { 'enable': 0 } } }
```

## `g:mkdx#settings.toc.details.summary`

With [`g:mkdx#settings.toc.details.enable`](#gmkdxsettingstocdetailsenable) set to `1`, a `<summary>` tag will also be
generated inside the resulting `<details>` tag. This tag contains the text that will be displayed next to the "▶".
The default value has a special placeholder `{{toc.text}}`. This will be replaced with the value of [`g:mkdx#settings.toc.text`](#gmkdxsettingstoctext) upon generation.

```viml
" :h mkdx-setting-toc-details-summary
let g:mkdx#settings = { 'toc': { 'details': { 'summary': 'Click to expand {{toc.text}}' } } }
```

## `g:mkdx#settings.highlight.enable`

This setting enables state-specific highlighting for checkboxes.
It will also override the default markdown syntax highlighting scheme to better accomodate the colors used.
The highlighting is linked to the `gitcommit*` family of highlight groups (and Comment for list items), full list:

- `Comment` is used for list items, e.g. items starting with `-`, `*`, `1.`
- `gitcommitUnmergedFile` is used for empty checkboxes: `[ ]`
- `gitcommitBranch` is used for pending / in-progress checkboxes: `[-]`
- `gitcommitSelectedFile` is used for completed checkboxes: `[x]`

If you want to change the highlighting groups, simply `link` them to different groups:

```viml
" :h mkdx-highlighting

" these are the defaults, defined by mkdx in after/syntax/markdown/mkdx.vim
highlight default link mkdxListItem Comment
highlight default link mkdxCheckboxEmpty gitcommitUnmergedFile
highlight default link mkdxCheckboxPending gitcommitBranch
highlight default link mkdxCheckboxComplete gitcommitSelectedFile

" to change the color of list items to the "jsOperator" group, one would write this in their vimrc:
highlight link mkdxListItem jsOperator
```

Note: syntax highlighting is opt-in _by default_. This means you must explicitly enable this feature to use it.
The reason behind this is that this plugin is not a syntax plugin and maybe you are already using one that does such a thing in a way that works better for you.
You can see it in action in the [Completing checkboxes / checklists](#completing-checkboxes--checklists) examples.

```viml
" :h mkdx-setting-highlight-enable
" :h mkdx-highlighting
" set to 1 to enable.
let g:mkdx#settings = { 'highlight': { 'enable': 0 } }
```

# Mappings

The below list contains all mappings that mkdx creates by default. To remap functionality: [remapping functionality](#remapping-functionality).  
To prevent mapping of a key from happening, see: [unmapping functionality](#unmapping-functionality).

**Note:** *replace `-{n|v}` with just `-n` or `-v` when creating your own mappings*

|description|modes|mapping|Execute|
|----|----|-------|-------|
|Prev checkbox state|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>-</kbd>|`<Plug>(mkdx-checkbox-prev)`|
|Next checkbox state|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>=</kbd>|`<Plug>(mkdx-checkbox-next)`|
|Promote header|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\[</kbd>|`<Plug>(mkdx-promote-header)`|
|Demote header|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\]</kbd>|`<Plug>(mkdx-demote-header)`|
|Toggle kbd shortcut|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>k</kbd>|`<Plug>(mkdx-toggle-to-kbd-{n\|v})`|
|Toggle quote|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>'</kbd>|`<Plug>(mkdx-toggle-quote)`|
|Toggle checkbox item|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>t</kbd>|`<Plug>(mkdx-toggle-checkbox)`|
|Toggle checklist item|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>lt</kbd>|`<Plug>(mkdx-toggle-checklist)`|
|Toggle list item|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>ll</kbd>|`<Plug>(mkdx-toggle-list)`|
|Wrap link|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>ln</kbd>|`<Plug>(mkdx-wrap-link-{n\|v})`|
|Italicize text|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>/</kbd>|`<Plug>(mkdx-mkdx-text-italic-{n\|v})`|
|Bolden text|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>b</kbd>|`<Plug>(mkdx-mkdx-text-bold-{n\|v}))`|
|Wrap with inline code|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>\`</kbd>|`<Plug>(mkdx-mkdx-text-inline-code-{n\|v})`|
|Wrap with strikethrough|normal, visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>s</kbd>|`<Plug>(mkdx-mkdx-text-strike-{n\|v})`|
|CSV to table|visual|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>,</kbd>|`<Plug>(mkdx-tableize)`|
|Generate / Update TOC|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>i</kbd>|`<Plug>(mkdx-gen-or-upd-toc)`|
|Quickfix TOC|normal|<kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>I</kbd>|`<Plug>(mkdx-quickfix-toc)`|
|<kbd>o</kbd> handler|normal|<kbd>o</kbd>|`<Plug>(mkdx-o)`|
|<kbd>O</kbd> handler|normal|<kbd>O</kbd>|`<Plug>(mkdx-shift-o)`|
|Insert fenced code block|insert|<kbd>\`</kbd><kbd>\`</kbd><kbd>\`</kbd>|`<Plug>(mkdx-fence-backtick)`|
|Insert fenced code block|insert|<kbd>\~</kbd><kbd>\~</kbd><kbd>\~</kbd>|`<Plug>(mkdx-fence-tilde)`|
|Insert kbd shortcut|insert|<kbd>\<</kbd>+<kbd>tab</kbd>|`<Plug>(mkdx-insert-kbd)`|
|<kbd>enter</kbd> handler|insert|<kbd>enter</kbd>|`<Plug>(mkdx-enter)`|

# Remapping functionality

`<Plug>` mappings can easily be remapped to any other key you prefer.
When a `<Plug>(mkdx-*)` mapping is found, mkdx will not create the default mapping for that `<Plug>`.
If you want to disable functionality, see: [Unmapping functionality](#unmapping-functionality).

```viml
" this will remap <leader>q in every filetype, not very handy in most cases
nnoremap <leader>q <Plug>(mkdx-quickfix-toc)

" to keep it limited to markdown files, one can use an "autocommand".
" First, make sure we don't create the default mapping when entering markdown files.
" All plugs can be disabled like this (except insert mode ones, they need "imap" instead of "nmap").
nmap <Plug> <Plug>(mkdx-quickfix-toc)

" then create a function to remap manually
fun! s:MkdxRemap()
    " regular map family can be used since these are buffer local.
    nmap <buffer><silent> <leader>q <Plug>(mkdx-quickfix-toc)
    " other overrides go here
endfun

" finally, add a "FileType" autocommand that calls "s:MkdxRemap()" upon entering markdown filetype
augroup Mkdx
    au!
    au FileType markdown, mkdx call s:MkdxRemap()
augroup END
```

# Unmapping functionality

In case some functionality gets in your way, you can unmap a specific function quite easily.
There are two different methods we can use to prevent mkdx from creating any mapping:

## Using `<Nop>`

If you want to unmap specific functionality, you'll have to define a mapping for it.
This is required because the plugin maps its keys when opening a markdown file, so if you `unmap` something,
it will still get mapped to other markdown buffers. To disable any map, first find it [here](#mappings) or at: `:h mkdx-mappings`.

Say you want to disable toggling next checkbox state (mapped to <kbd>[\<PREFIX\>](#gmkdxsettingsmapprefix)</kbd>+<kbd>=</kbd>).
In your _.vimrc_, add the following:

```viml
" this will disable toggling checkbox next in normal mode.
nmap <leader>= <Nop>

" this will disable toggling checkbox next in visual mode.
vmap <leader>= <Nop>
```

The mappings are checked using the value of [`g:mkdx#settings.map.prefix`](#gmkdxsettingsmapprefix) so you may need to check its value first
by running the following: `:echo g:mkdx#settings.map.prefix`. A better way to prevent mkdx from mapping keys is by remapping `<Plug>` mappings.

## Using `<Plug>`

If you don't know what a `<Plug>` is, it is a builtin tool for plugin authors to provide a more
"clear" and user-friendly plugin interface (and to create repeatable mappings with repeat.vim!).
All of the functions of mkdx are mapped using `<Plug>` mappings.
To disable a `<Plug>` mapping, first find it [here](#mappings) or at: `:h mkdx-plugs`.

Say you want to disable the behaviour for toggling the next checkbox state.
The corresponding `<Plug>` is called `<Plug>(mkdx-checkbox-next)`. To disable it, add the following to your _.vimrc_:

```viml
map <Plug> <Plug>(mkdx-checkbox-next)
```

# Roadmap

- [x] Add setting to always place the TOC in a fixed position (e.g. below nth header)
- [x] Add setting to generate the TOC inside a `<details />` tag for github
- [x] Allow [`g:mkdx#settings.checkbox.toggles`](#gmkdxsettingscheckboxtoggles) to only have 2 elements.
- [x] Fix merging of `g:mkdx#settings` ([`g:mkdx#settings.checkbox.toggles`](#gmkdxsettingscheckboxtoggles))

# Contributing

Found a bug or want to report an issue? Take a look at the [CONTRIBUTING](CONTRIBUTING.md) file for more information.

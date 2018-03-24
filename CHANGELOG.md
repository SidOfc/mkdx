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

## Version 0.6.1

Fixes a bug where wrapping text on a line with a single word would cause a space to be prepended.
Imagine the cursor is the pipe character (`|`) in this line: `w|ord`, [wrapping as a link](#as-a-link)
would cause the following result:

~~~
# this
word
 [word](|)

# now becomes this
word
[word](|)
~~~

## Version 0.6.0

- This version adds _opt-in_ support for checkbox state highlighting. See [`g:mkdx#settings.highlight.enable`](#gmkdxsettingshighlightenable) for more information.

## Version 0.5.0

- This version introduces a mapping that opens a quickfix window with all your headers loaded.
  See [Open TOC in quickfix window](open-toc-in-quickfix-window) section for an example.

## Version 0.4.3.1

- Fixes a critical issue with the enter handler functionality where often, it would crash due to missing out of bounds
array check.


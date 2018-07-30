## 10-05-2018 VERSION 1.6.0

- Fix: Handle URLS starting with "../../" correctly.
- Fix: Removed hardcoded hashtag as header identifier in function.
- Fix: ([#35](../../pull/35)) Generating a TOC in the details didn't generate the final closing tags.
- Fix: ([#40](../../pull/40)) Shift-o (`O`) prepending a list item to a line starting with a number.
- Fix: ([#39](../../pull/39)) Set `autoindent`, it is enabled by default in Neovim but disabled by default in Vim.
- Add: ([#41](../../pull/41)) Fold support for the table of contents and fenced code blocks (opt-in).
    - Add setting to enable folding: `g:mkdx#settings.fold.enable = 0`.
    - Add setting to modify what is folded: `g:mkdx#settings.fold.components = ['toc', 'fence']`.
- NEOVIM
    - Add: ([#32](../../pull/32)) `dictionarywatcher` that watches settings and immediately updates the document, this includes:
        - TOC text - (`:let g:mkdx#settings.toc.text = 'string'`).
        - TOC position - (`:let g:mkdx#settings.toc.position = 2`).
        - TOC style - (`:let g:mkdx#settings.toc.details.enable = 1`).
        - TOC summary - (`:let g:mkdx#settings.toc.details.summary = 'new string'`).
        - Header style - (`:let g:mkdx#settings.tokens.header = '@'`).
        - Fence style - (`:let g:mkdx#settings.tokens.fence = '~'`).
        - Folds - (`:let g:mkdx#settings.tokens.components = ['toc']`).
    - Add: setting to control auto-updates: `g:mkdx#settings.auto_update.enable = 1`.

## 05-05-2018 VERSION 1.5.1

- [dead link detection](#dead-link-detection) uses a [grep program](#supported-grep-programs) and `job` when available
- [jumping to headers](#jump-to-header) uses a [grep program](#supported-grep-programs) and `job` when available
- [insert autocompletion](#insert-mode-fragment-completion) uses a [grep program](#supported-grep-programs) and `job` when available

## 28-04-2018 VERSION 1.5.0

- Add insert mode completion for [fragment links](#insert-mode-fragment-completion).
- Add [setting](#gmkdxsettingslinksfragmentcomplete) to control completions.
- Add support for anchor fragment links ([#24](../../issues/24)) (`<a id="hello"></a>` / `<a name="hello"></a>`) for [jumping](#jump-to-header), [detection](#dead-link-detection) and [completion](#insert-mode-fragment-completion).
- Fix issue where double slashes in the URL would not be removed in external link checks.
- Fix nested `<a></a>` tags in generated TOC links.

## 27-04-2018 VERSION 1.4.3

- ([#17](../../issues/17)) Add a mapping to go to [fragment link location](#jump-to-header).
- ([#18](../../issues/18)) Add [alignment options](#gmkdxsettingstablealign) for columns in a table generated from CSV.
- ([#18](../../issues/18)) Add [alignment options](#gmkdxsettingstablealign) for specific column names or indexes in a table generated from CSV.
- List items require a space after them to be recognized as a list item.

## 15-04-2018 VERSION 1.4.2

- [Convert CSV to table](#convert-csv-to-table) now also supports quoted CSV and TSV data

## 08-04-2018 VERSION 1.4.1

- [Dead link detection](#dead-link-detection) will now also scan any `href=""` attribute content.

## 08-04-2018 VERSION 1.4.0

- Update [Dead link detection](#dead-link-detection) to include support for external and relative links.
- Add [new settings](#gmkdxsettingslinksexternalenable) to control request timeout and relative link host etc.

## 02-04-2018 VERSION 1.3.0

- Added feature: [Dead fragment link detection](#dead-link-detection)
- Automatically remove `r` from `formatoptions` inside markdown files (buffer local override)
- Fix table of contents "eating" a header when there is no blank line between the table of contents and the next heading
- Cursor stays on the same line after updating table of contents
- `mkdx#QuickfixHeaders()` shows amount of headers and doesn't open quickfix when no headers are present.

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

## 24-03-2018 VERSION 1.0.1

- All mappings now use `<Plug>`.

## 24-03-2018 VERSION 1.0.0

- Fix #11 - `mkdx#ToggleQuote` inserting `0` on empty lines
- Fix #12 - Update (task-)lists inside a quote
- Fix #13 - Add / remove (task-)lists inside a quote
- Add `<Plug>(mkdx-o)` in favor of directly mapping to `A<Cr>` to trigger `mkdx#EnterHandler`
- Add `<Plug>(mkdx-shift-o)` in favor of directly mapping to `:call mkdx#ShiftOHandler()<Cr>`

## 28-01-2018 VERSION 0.9.0

- Fix `mkdx#HeaderToQF` wrong function ref.
- Fix `g:mkdx#settings.enter.enable` and `g:mkdx#settings.enter.shifto` can be disabled during runtime.
- Fix insert mode "\~\~\~" and "\`\`\`" recursion.
- Add support for [toggling \<kbd /> shortcuts](#toggling-kbd--shortcuts) in normal and visual mode.

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


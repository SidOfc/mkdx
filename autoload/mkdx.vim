""""" CHECKBOX FUNCTIONS

fun! mkdx#ToggleCheckboxReplace(line, backwards)
  let listcpy = deepcopy(g:mkdx#checkbox_toggles)
  let line    = a:line
  let len     = len(listcpy) - 1

  if (a:backwards == 1)
    let listcpy = reverse(listcpy)
  endif

  for mrk in listcpy
    if (match(line, '\[' . mrk . '\]') != -1)
      let nidx = index(listcpy, mrk) + 1
      let nidx = nidx > len ? 0 : nidx
      let line = substitute(line, '\[' . mrk . '\]', '\[' . listcpy[nidx] . '\]', '')
      break
    endif
  endfor

  return line
endfun

fun! mkdx#ToggleCheckbox(...)
  call setline('.', mkdx#ToggleCheckboxReplace(getline('.'), get(a:000, 0, 0)))
endfun

fun! mkdx#ToggleCheckboxList(...) range
  for linenum in range(a:firstline, a:lastline)
    call setline(linenum, mkdx#ToggleCheckboxReplace(getline(linenum), get(a:000, 0, 0)))
  endfor
endfun

""""" LINK FUNCTIONS

fun! mkdx#WrapLink()
  let line   = getline('.')
  let vstart = getpos("'<")[2] - 1
  let vend   = getpos("'>")[2]

  let b = vstart - 1 < 0 ? '' : line[:(vstart - 1)]
  let s = line[vstart:(vend - 1)]
  let e = line[vend:]

  call setline('.', b . "[" . s . "]()" . e)
  call cursor(line('.'), vend + 4)

  startinsert
endfun

""""" HEADER FUNCTIONS

fun! mkdx#ToggleHeader(...)
  let increment = get(a:000, 0, 0)
  let line = getline('.')

  if (match(line, '^' . g:mkdx#header_style . '\{1,6\}\s') == -1)
    return
  endif

  let parts     = split(line, ' ')
  let new_level = strlen(parts[0]) + (increment ? -1 : 1)
  let new_level = new_level > 6 ? 1 : (new_level < 1 ? 6 : new_level)

  call setline('.', repeat(g:mkdx#header_style, new_level) . ' ' . parts[1])
endfun

""""" TABLE FUNCTIONS

fun! mkdx#Tableize() range
  let next_nonblank       = nextnonblank(a:firstline)
  let firstline           = getline(next_nonblank)
  let first_delimiter_pos = match(firstline, '[,\t]')

  if (first_delimiter_pos < 0)
    return
  endif

  let delimiter  = firstline[first_delimiter_pos]
  let lines      = getline(a:firstline, a:lastline)
  let col_maxlen = {}
  let linecount  = range(0, len(lines) - 1)
  let line_delim = ' ' . g:mkdx#table_divider . ' '

  for idx in linecount
    let lines[idx] = split(lines[idx], delimiter, 1)
    let linelen    = len(lines[idx]) - 1

    for column in range(0, len(lines[idx]) - 1)
      let curr_word_max = strlen(lines[idx][column])
      let last_col_max  = get(col_maxlen, column, 0)

      if (curr_word_max > last_col_max)
        let col_maxlen[column] = curr_word_max
      endif
    endfor
  endfor

  for linec in linecount
    for colc in range(0, len(lines[linec]) - 1)
      let lines[linec][colc] = mkdx#CenterString(lines[linec][colc], col_maxlen[colc])
    endfor
    let lines[linec] = join(lines[linec], line_delim)

    call setline(a:firstline + linec, substitute(lines[linec], '\s\+$', '', ''))
  endfor

  call mkdx#InsertLine(repeat('=', max(map(lines, 'strlen(v:val)'))), next_nonblank)
  call cursor(a:lastline + 1, 1)
endfun

""""" UTILITY FUNCTIONS

fun! mkdx#InsertLine(line, position)
  let reg_val = @l
  let @l      = a:line

  call cursor(a:position, 1)
  normal! A"lp

  let @l = reg_val
endfun

fun! mkdx#CenterString(str, length)
  let remaining = a:length - strlen(a:str)

  if (remaining < 0)
    return a:str[0:(a:length - 1)]
  endif

  let padleft  = repeat(' ', float2nr(floor(remaining / 2.0)))
  let padright = repeat(' ', float2nr(ceil(remaining / 2.0)))

  return padleft . a:str . padright
endfun

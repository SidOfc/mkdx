""""" CHECKBOX FUNCTIONS

fun! mkdx#ToggleCheckbox(...)
  let reverse = get(a:000, 0, 0) == 1
  let listcpy = deepcopy(g:mkdx#checkbox_toggles)
  let listcpy = reverse ? reverse(listcpy) : listcpy
  let line    = getline('.')
  let len     = len(listcpy) - 1

  for mrk in listcpy
    if (match(line, '\[' . mrk . '\]') != -1)
      let nidx = index(listcpy, mrk) + 1
      let nidx = nidx > len ? 0 : nidx
      let line = substitute(line, '\[' . mrk . '\]', '\[' . listcpy[nidx] . '\]', '')
      break
    endif
  endfor

  call setline('.', line)
  silent! call repeat#set("\<Plug>(mkdx-checkbox-" . (reverse ? 'prev' : 'next') . ")")
endfun

""""" LINK FUNCTIONS

fun! mkdx#WrapLink(...)
  let m  = get(a:000, 0, 'n')
  let r  = @z

  exe     'normal! ' . (m == 'n' ? '"zdiw' : 'gv"zd')
  let     @z = '[' . @z . ']()'
  normal! "zP
  let     @z = r

  startinsert
  silent! call repeat#set("\<Plug>(mkdx-wrap-link-" . m . ")")
endfun

""""" QUOTING FUNCTIONS

fun! mkdx#ToggleQuote()
  let line = getline('.')

  if (match(line, '^> ') != -1)
    call setline('.', substitute(line, '^> ', '', ''))
  elseif (!empty(line))
    call setline('.', '> ' . line)
  endif

  silent! call repeat#set("\<Plug>(mkdx-toggle-quote)")
endfun

""""" HEADER FUNCTIONS

fun! mkdx#ToggleHeader(...)
  let increment = get(a:000, 0, 0)
  let line      = getline('.')

  if (match(line, '^' . g:mkdx#header_style . '\{1,6\} ') == -1) |  return | endif

  let parts     = split(line, '^' . g:mkdx#header_style . '\{1,6\} \zs')
  let new_level = strlen(substitute(parts[0], ' ', '', 'g')) + (increment ? -1 : 1)
  let new_level = new_level > 6 ? 1 : (new_level < 1 ? 6 : new_level)

  call setline('.', repeat(g:mkdx#header_style, new_level) . ' ' . parts[1])
  silent! call repeat#set("\<Plug>(mkdx-" . (increment ? 'promote' : 'demote') . "-header)")
endfun

""""" TABLE FUNCTIONS

fun! mkdx#Tableize() range
  let next_nonblank       = nextnonblank(a:firstline)
  let firstline           = getline(next_nonblank)
  let first_delimiter_pos = match(firstline, '[,\t]')

  if (first_delimiter_pos < 0) | return | endif

  let delimiter    = firstline[first_delimiter_pos]
  let lines        = getline(a:firstline, a:lastline)
  let col_maxlen   = {}
  let linecount    = range(0, len(lines) - 1)
  let line_delim   = ' ' . g:mkdx#table_divider . ' '
  let line_h_delim = g:mkdx#table_header_divider .  g:mkdx#table_divider . g:mkdx#table_header_divider

  for idx in linecount
    let lines[idx] = split(lines[idx], delimiter, 1)
    let linelen    = len(lines[idx]) - 1

    for column in range(0, len(lines[idx]) - 1)
      let curr_word_max = strlen(lines[idx][column])
      let last_col_max  = get(col_maxlen, column, 0)

      if (curr_word_max > last_col_max) | let col_maxlen[column] = curr_word_max | endif
    endfor
  endfor

  for linec in linecount
    if !empty(filter(lines[linec], '!empty(v:val)'))
      for colc in range(0, len(lines[linec]) - 1)
        let lines[linec][colc] = s:CenterString(lines[linec][colc], col_maxlen[colc])
      endfor
      let lines[linec] = join(lines[linec], line_delim)

      call setline(a:firstline + linec, line_delim[1:2] . lines[linec] . line_delim[0:1])
    endif
  endfor

  let hline = join(map(values(col_maxlen), 'repeat(g:mkdx#table_header_divider, v:val)'), line_h_delim)

  call s:InsertLine(line_h_delim[1:2] . hline . line_h_delim[0:1], next_nonblank)
  call cursor(a:lastline + 1, 1)
endfun

""""" ENTER FUNCTIONS

fun! mkdx#EnterHandler()
  let [lnum, cnum]  = getpos('.')[1:2]
  let line  = getline('.')
  let parts = split(substitute(line, ' \+$', '', 'g'), ' ')
  let part1 = get(parts, 0, '')
  let cbx   = (get(parts, 1, '') == '[') && (get(parts, 2, '') == ']')
  if (match(get(parts, 1, ''), '\[.\]') > -1) | let cbx = 1 | endif
  let clvl  = len(split(part1, '\.'))
  let atend = cnum >= strlen(line)
  let len   = len(parts)
  let cmd   = "normal! " . (((len == 1) && s:IsListToken(part1)) ? "0DD" : "a\<cr>")
  let cmd  .= (atend && len > 1) ? s:NextListToken(part1, clvl, cbx) : ""

  if atend && (strlen(get(matchlist(line, '^\( \{-}[0-9.]\)'), 0, '')) > 0) && (len > 1)
    let ident = strlen(get(matchlist(line, '^\( \+\)'), 0, ''))

    while (nextnonblank(lnum) == lnum)
      let lnum   += 1
      let tmp     = getline(lnum)
      let tident  = strlen(get(matchlist(tmp, '^\( \+\)'), 0, ''))

      if tident < ident | break | endif
      call setline(lnum,
        \ substitute(tmp,
        \            '^\( \{' . ident . ',}\)\([0-9.]\+ \)',
        \            '\=submatch(1) . s:NextListToken(submatch(2), ' . clvl . ')', ''))
    endwhile
  endif

  exe cmd
  if atend | startinsert! | else | startinsert | endif
endfun

fun! s:IsListToken(str)
  return (index(g:mkdx#list_tokens, a:str) > -1) || (match(a:str, '^[0-9.]\+$') > -1)
endfun

fun! s:NextListToken(str, ...)
  let suffix = get(a:000, 1, 0) ? ' [ ] ' : ' '
  if (index(g:mkdx#list_tokens, a:str) > -1)  | return a:str . suffix | endif
  if (match(a:str, '[0-9. ]\+') == -1)        | return ''             | endif

  let parts      = split(substitute(a:str, '^ \+\| \+$', '', 'g'), '\.')
  let clvl       = get(a:000, 0, 1)
  let llvl       = len(parts)
  let idx        = (clvl == llvl ? llvl : clvl) - 1

  let parts[idx] = str2nr(parts[idx]) + 1

  return join(parts, '.') . '.' . suffix
endfun

""""" UTILITY FUNCTIONS

fun! s:InsertLine(line, position)
  let reg_val = @l
  let @l      = a:line

  call cursor(a:position, 1)
  normal! A"lp

  let @l = reg_val
endfun

fun! s:CenterString(str, length)
  let remaining = a:length - strlen(a:str)

  if (remaining < 0)
    return a:str[0:(a:length - 1)]
  endif

  let padleft  = repeat(' ', float2nr(floor(remaining / 2.0)))
  let padright = repeat(' ', float2nr(ceil(remaining / 2.0)))

  return padleft . a:str . padright
endfun

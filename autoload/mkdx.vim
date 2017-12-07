""""" SCRIPT VARS


let s:csv_split_re   = '[,\t]'
let s:checkbox_re    = '\[\(.\)\]'
let s:list_number_re = '^\( \{-}[0-9.]\+\)'
let s:header_re      = '^' . g:mkdx#header_style . '\{1,6\} '
let s:toc_re         = '^' . g:mkdx#header_style . '\{1,6}'
let s:toc_heading_re = s:toc_re . ' \+' . g:mkdx#toc_text
let s:toc_codeblk_re = '^\(\`\`\`\|\~\~\~\)'

let s:line_delim   = ' ' . g:mkdx#table_divider . ' '
let s:line_h_delim = g:mkdx#table_header_divider .  g:mkdx#table_divider . g:mkdx#table_header_divider

""""" SCRIPT FUNCTIONS

fun! s:HeaderToListItem(header, ...)
  return '[' . s:CleanHeader(a:header) . '](#' . s:HeaderToHash(a:header) . get(a:000, 0, '') . ')'
endfun

fun! s:CleanHeader(header)
  return substitute(substitute(a:header, '^[ #]\+\| \+$', '', 'g'), '\[\([^\]]\+\)]([^)]\+)', '\1', 'g')
endfun

fun! s:HeaderToHash(header)
  return substitute(substitute(tolower(s:CleanHeader(a:header)), '[^0-9a-z_\- ]\+', '', 'g'), ' ', '-', 'g')
endfun

fun! s:TaskItem(linenum)
  let line   = getline(a:linenum)
  let token  = get(matchlist(line, s:checkbox_re), 1, '')
  let ident  = indent(a:linenum)
  let rem    = ident % &sw
  let ident -= g:mkdx#handle_malformed_indent ? (rem - (rem > &sw / 2 ? &sw : 0)) : 0

  return [token, (ident == 0 ? ident : ident / &sw), line]
endfun

fun! s:TasksToCheck(linenum)
  let [lnum, cnum]      = getpos(a:linenum)[1:2]
  let current           = s:TaskItem(lnum)
  let [ctkn, cind, cln] = current
  let startc            = lnum
  let items             = []

  while (prevnonblank(startc) == startc)
    let indent = s:TaskItem(startc)[1]
    if (indent == 0) | break | endif
    let startc -= 1
  endwhile

  if (cind == -1) | return | endif

  while (nextnonblank(startc) == startc)
    let [token, indent, line] = s:TaskItem(startc)
    if ((startc < lnum) || (indent != 0))
      call add(items, [startc, token, indent, line])
      let startc += 1
    else
      break
    endif
  endwhile

  return [extend([lnum], current), items]
endfun

fun! s:UpdateTaskList(...)
  let linenum               = get(a:000, 0, '.')
  let [target, tasks]       = s:TasksToCheck(linenum)
  let [tlnum, ttk, tdpt, _] = target
  let tasksilen             = len(tasks) - 1
  let [incompl, compl]      = g:mkdx#checkbox_toggles[-2:-1]
  let empty                 = g:mkdx#checkbox_toggles[0]
  let tasks_lnums           = map(deepcopy(tasks), 'get(v:val, 0, -1)')

  if (tdpt > 0)
    let nextupd = tdpt - 1

    for [lnum, token, depth, line] in reverse(deepcopy(tasks))
      if ((lnum < tlnum) && (depth == nextupd))
        let nextupd  -= 1
        let substats  = []
        let parentidx = index(tasks_lnums, lnum)

        for ii in range(parentidx + 1, tasksilen)
          let next_task  = tasks[ii]
          let depth_diff = abs(next_task[2] - depth)

          if (depth_diff == 0) | break                            | endif
          if (depth_diff == 1) | call add(substats, next_task[1]) | endif
        endfor

        let completed = index(map(deepcopy(substats), 'v:val != "' . compl . '"'), 1) == -1
        let unstarted = index(map(deepcopy(substats), 'v:val != "' . empty . '"'), 1) == -1
        let new_token = completed ? compl : (unstarted ? empty : incompl)
        let new_line  = substitute(line, '\[' . token . '\]', '\[' . new_token . '\]', '')

        let tasks[parentidx][1] = new_token
        let tasks[parentidx][3] = new_line

        call setline(lnum, new_line)
        if (nextupd < 0) | break | endif
      endif
    endfor

    if g:mkdx#checklist_update_tree == 2
      for [lnum, token, depth, line] in tasks
        if (lnum > tlnum)
          if (depth == tdpt) | break | endif
          if (depth > tdpt) | call setline(lnum, substitute(line, s:checkbox_re, '\[' . ttk . '\]', '')) | endif
        endif
      endfor
    endif
  endif
endfun

fun! s:IsListToken(str)
  return (index(g:mkdx#list_tokens, a:str) > -1) || (match(a:str, s:list_number_re) > -1)
endfun

fun! s:NextListToken(str, ...)
  let suffix = get(a:000, 1, 0) ? ' [ ] ' : ' '
  if (index(g:mkdx#list_tokens, a:str) > -1)  | return a:str . suffix | endif
  if (match(a:str, s:list_number_re) == -1)        | return ''             | endif

  let parts      = split(substitute(a:str, '^ \+\| \+$', '', 'g'), '\.')
  let clvl       = get(a:000, 0, 1)
  let llvl       = len(parts)
  let idx        = (clvl == llvl ? llvl : clvl) - 1

  let parts[idx] = str2nr(parts[idx]) + 1

  return join(parts, '.') . '.' . suffix
endfun

fun! s:InsertLine(line, position)
  let _z = @z
  let @z = a:line

  call cursor(a:position, 1)
  normal! A"zp

  let @z = _z
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

""""" MAIN FUNCTIONALITY

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
  if (g:mkdx#checklist_update_tree != 0) | call s:UpdateTaskList() | endif
  silent! call repeat#set("\<Plug>(mkdx-checkbox-" . (reverse ? 'prev' : 'next') . ")")
endfun

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

fun! mkdx#ToggleQuote()
  let line = getline('.')

  if (match(line, '^> ') != -1)
    call setline('.', substitute(line, '^> ', '', ''))
  elseif (!empty(line))
    call setline('.', '> ' . line)
  endif

  silent! call repeat#set("\<Plug>(mkdx-toggle-quote)")
endfun

fun! mkdx#ToggleHeader(...)
  let increment = get(a:000, 0, 0)
  let line      = getline('.')

  if (match(line, s:header_re) == -1) |  return | endif

  let parts     = split(line, s:header_re . '\zs')
  let new_level = strlen(substitute(parts[0], ' ', '', 'g')) + (increment ? -1 : 1)
  let new_level = new_level > 6 ? 1 : (new_level < 1 ? 6 : new_level)

  call setline('.', repeat(g:mkdx#header_style, new_level) . ' ' . parts[1])
  silent! call repeat#set("\<Plug>(mkdx-" . (increment ? 'promote' : 'demote') . "-header)")
endfun

fun! mkdx#Tableize() range
  let next_nonblank       = nextnonblank(a:firstline)
  let firstline           = getline(next_nonblank)
  let first_delimiter_pos = match(firstline, s:csv_split_re)

  if (first_delimiter_pos < 0) | return | endif

  let delimiter    = firstline[first_delimiter_pos]
  let lines        = getline(a:firstline, a:lastline)
  let col_maxlen   = {}
  let linecount    = range(0, len(lines) - 1)

  for idx in linecount
    let lines[idx] = split(lines[idx], delimiter, 1)

    for column in range(0, len(lines[idx]) - 1)
      let curr_word_max = strlen(lines[idx][column])
      let last_col_max  = get(col_maxlen, column, 0)

      if (curr_word_max > last_col_max) | let col_maxlen[column] = curr_word_max | endif
    endfor
  endfor

  for linec in linecount
    if !empty(filter(lines[linec], '!empty(v:val)'))
      call setline(a:firstline + linec,
        \ s:line_delim[1:2] . join(map(lines[linec], 's:CenterString(v:val, col_maxlen[v:key])'), s:line_delim) . s:line_delim[0:1])
    endif
  endfor

  let hline = join(map(values(col_maxlen), 'repeat(g:mkdx#table_header_divider, v:val)'), s:line_h_delim)

  call s:InsertLine(s:line_h_delim[1:2] . hline . s:line_h_delim[0:1], next_nonblank)
  call cursor(a:lastline + 1, 1)
endfun

fun! mkdx#EnterHandler()
  let [lnum, cnum] = getpos('.')[1:2]
  let line         = getline(lnum)
  let parts        = split(substitute(line, ' \+$', '', 'g'), ' ')
  let [p0, p1]     = [get(parts, 0, ''), get(parts, 1, '')]
  let nonemptycb   = match(p1, s:checkbox_re) > -1
  let cbx          = nonemptycb || ((p1 == '[') && (get(parts, 2, '') == ']'))
  let clvl         = len(split(p0, '\.'))
  let atend        = cnum >= strlen(line)
  let len          = len(parts)
  let rmv          = ((len == 1) && s:IsListToken(p0)) || (len == (nonemptycb ? 2 : 3)) && (cbx == 1)
  let ident        = indent(lnum)

  if atend && !rmv && (strlen(get(matchlist(line, s:list_number_re), 0, '')) > 0)
    while (nextnonblank(lnum) == lnum)
      let lnum += 1

      if indent(lnum) < ident | break | endif
      call setline(lnum,
        \ substitute(getline(lnum),
        \            '^\( \{' . ident . ',}\)\([0-9.]\+ \)',
        \            '\=submatch(1) . s:NextListToken(submatch(2), ' . clvl . ')', ''))
    endwhile
  endif

  exe "normal! " . (rmv ? "0DD" : "a\<cr>" . (atend ? s:NextListToken(p0, clvl, cbx) : ''))
  if (!rmv && cbx && g:mkdx#checklist_update_tree != 0) | call s:UpdateTaskList() | endif
  if atend | startinsert! | else | startinsert | endif
endfun

fun! mkdx#GenerateOrUpdateTOC()
  for lnum in range((getpos('^')[1] + 1), getpos('$')[1])
    if (match(getline(lnum), s:toc_heading_re) > -1)
      call mkdx#UpdateTOC()
      return
    endif
  endfor

  call mkdx#GenerateTOC()
endfun

fun! mkdx#UpdateTOC()
  let startc = -1
  let nnb   = -1
  let cpos  = getpos('.')[1:2]

  for lnum in range((getpos('^')[1] + 1), getpos('$')[1])
    if (match(getline(lnum), s:toc_heading_re) > -1)
      let startc = lnum
      break
    endif
  endfor

  if (startc)
    let endc = startc + (nextnonblank(startc + 1) - startc)
    while nextnonblank(endc) == endc |  let endc += 1 | endwhile
    let endc -= 1
  endif

  echom startc . ' ' . endc
  exe 'normal! :' . startc . ',' . endc . 'd'
  call mkdx#GenerateTOC()
endfun

fun! mkdx#GenerateTOC()
  let contents = []
  let curspos  = getpos('.')[1]
  let header   = ''
  let prevlvl  = 1
  let skip     = 0
  let headers  = {}
  let headers[s:HeaderToHash(g:mkdx#toc_text)] = 1

  for lnum in range((getpos('^')[1] + 1), getpos('$')[1])
    let line = getline(lnum)
    if (match(line, s:toc_codeblk_re) > -1) | let skip = !skip | endif
    let lvl  = strlen(get(matchlist(line, s:toc_re), 0, ''))

    if (!skip && lvl > 0)
      if (empty(header) && lnum > curspos)
        let header = repeat(g:mkdx#header_style, prevlvl) . ' ' . g:mkdx#toc_text
        call insert(contents, header)
        call add(contents, repeat(repeat(' ', &sw), prevlvl - 1) . g:mkdx#toc_list_token . ' ' . s:HeaderToListItem(header))
      endif

      let hsh = s:HeaderToHash(line)
      let c   = get(headers, hsh, 0)
      if (c == 0) | let headers[hsh] = 1 | else | let headers[hsh] += 1 | endif
      let li  = s:HeaderToListItem(line, c > 0 ? '-' . c : '')

      call add(contents, repeat(repeat(' ', &sw), lvl - 1) . g:mkdx#toc_list_token . ' ' . li)
      let prevlvl = lvl
    endif
  endfor

  let c = curspos - 1
  for item in contents
    call append(c, item)
    let c += 1
  endfor

  call cursor(curspos, 1)
  normal! Ak
endfun

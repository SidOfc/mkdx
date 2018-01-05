""""" SCRIPT FUNCTIONS

fun! s:HeaderToListItem(header, ...)
  return '[' . substitute(s:CleanHeader(a:header), ' \+$', '', 'g') . '](#' . s:HeaderToHash(a:header) . get(a:000, 0, '') . ')'
endfun

fun! s:CleanHeader(header)
  let h = substitute(a:header, '^[ #]\+\| \+$', '', 'g')
  let h = substitute(h, '\[!\[\([^\]]\+\)\](\([^\)]\+\))\](\([^\)]\+\))', '', 'g')
  return substitute(h, '!\?\[\([^\]]\+\)]([^)]\+)', '\1', 'g')
endfun

fun! s:HeaderToHash(header)
  return substitute(substitute(tolower(s:CleanHeader(a:header)), '[^0-9a-z_\- ]\+', '', 'g'), ' ', '-', 'g')
endfun

fun! s:TaskItem(linenum)
  let line   = getline(a:linenum)
  let token  = get(matchlist(line, '\[\(.\)\]'), 1, '')
  let ident  = indent(a:linenum)
  let rem    = ident % &sw
  let ident -= g:mkdx#settings.enter.malformed ? (rem - (rem > &sw / 2 ? &sw : 0)) : 0

  return [token, (ident == 0 ? ident : ident / &sw), line]
endfun

fun! s:TasksToCheck(linenum)
  let lnum              = type(a:linenum) == type(0) ? a:linenum : line(a:linenum)
  let cnum              = col('.')
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
  let force_status          = get(a:000, 1, -1)
  let [target, tasks]       = s:TasksToCheck(linenum)
  let [tlnum, ttk, tdpt, _] = target
  let tasksilen             = len(tasks) - 1
  let [incompl, compl]      = g:mkdx#settings.checkbox.toggles[-2:-1]
  let empty                 = g:mkdx#settings.checkbox.toggles[0]
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
        if (force_status > -1 && !unstarted)
          if (force_status == 0) | let new_token = empty   | endif
          if (force_status == 1) | let new_token = incompl | endif
          if (force_status > 1)  | let new_token = compl   | endif
        endif
        let new_line  = substitute(line, '\[' . token . '\]', '\[' . new_token . '\]', '')

        let tasks[parentidx][1] = new_token
        let tasks[parentidx][3] = new_line

        call setline(lnum, new_line)
        if (nextupd < 0) | break | endif
      endif
    endfor

    if (force_status < 0 && g:mkdx#settings.checkbox.update_tree == 2)
      for [lnum, token, depth, line] in tasks
        if (lnum > tlnum)
          if (depth == tdpt) | break | endif
          if (depth > tdpt) | call setline(lnum, substitute(line,  '\[.\]', '\[' . ttk . '\]', '')) | endif
        endif
      endfor
    endif
  endif
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

fun! mkdx#ToggleCheckboxState(...)
  let reverse = get(a:000, 0, 0) == 1
  let listcpy = deepcopy(g:mkdx#settings.checkbox.toggles)
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
  if (g:mkdx#settings.checkbox.update_tree != 0) | call s:UpdateTaskList() | endif
  silent! call repeat#set("\<Plug>(mkdx-checkbox-" . (reverse ? 'prev' : 'next') . ")")
endfun

fun! mkdx#WrapText(...)
  let m  = get(a:000, 0, 'n')
  let w  = get(a:000, 1, '')
  let x  = get(a:000, 2, w)
  let a  = get(a:000, 3, '')
  let r  = @z
  let ln = getline('.')

  exe 'normal! ' . (m == 'n' ? '"zdiw' : 'gv"zd')
  let oz = @z
  let @z = w . @z . x
  exe 'normal! "z' . (match(ln, (oz . '$')) > -1 ? 'p' : 'P')
  let @z = r

  if (a != '')
    silent! call repeat#set("\<Plug>(" . a . ")")
  endif
endfun

fun! mkdx#WrapLink(...)
  let ln = getline('.')
  let m  = get(a:000, 0, 'n')
  let r  = @z

  exe 'normal! ' . (m == 'n' ? '"zdiw' : 'gv"zd')

  let img = !empty(g:mkdx#settings.image_extension_pattern) && match(get(split(@z, '\.'), -1, ''), g:mkdx#settings.image_extension_pattern) > -1
  let @z  = (match(ln, (@z . '$')) > -1 ? ' ' : '') . (img ? '!' : '') . '[' . @z . '](' . (img ? @z : '') . ')'

  normal! "zPT(

  let @z = r

  startinsert
  silent! call repeat#set("\<Plug>(mkdx-wrap-link-" . m . ")")
endfun

fun! s:ToggleTokenAtStart(line, token, ...)
  let line   = a:line
  let tok_re = '^' . a:token . ' '

  if (match(line, tok_re) > -1)
    return substitute(line, tok_re, '', '')
  elseif (!empty(line))
    return get(a:000, 0, a:token) . ' ' . line
  endif
endfun

fun! s:ToggleLineType(line, type)
  if (empty(a:line)) | return a:line | endif

  let li_re = '\([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\)'

  if (a:type == 'list')
    " if a:line is a list item, remove the list marker and return
    if (match(a:line, '^ *' . li_re) > -1)
      return substitute(a:line, '^\( *\)' . li_re . ' *', '\1', '')
    endif
    " if a:line isn't a list item, turn it into one
    return substitute(a:line, '^\( *\)', '\1' . g:mkdx#settings.tokens.list . ' ', '')
  elseif (a:type == 'checklist')
    " if a:line is a checklist item, remove the checklist marker and return
    if (match(a:line, '^ *' . li_re . ' \[.\]') > -1)
      return substitute(a:line, '^\( *\)' . li_re . ' \[.\] *', '\1', '')
    endif

    " if a:line is a checkbox, replace it with g:mkdx#settings.tokens.list followed
    " by a space and the checkbox with checkbox state intact
    if (match(a:line, '^ *\[.\]') > -1)
      return substitute(a:line, '^\( *\)\[\(.\)\]', '\1' . g:mkdx#settings.tokens.list . ' [\2]', '')
    endif

    " if a:line is a regular list item, replace it with the respective list
    " token and a checkbox with state of g:mkdx#settings.checkbox.initial_state
    if (match(a:line, '^ *' . li_re) > -1)
      return substitute(a:line, '^\( *\)' . li_re, '\1\2 [' . g:mkdx#settings.checkbox.initial_state . ']', '')
    endif

    " if it isn't one of the above, turn it into a checklist item
    return substitute(a:line, '^\( *\)', '\1' . g:mkdx#settings.tokens.list . ' [' . g:mkdx#settings.checkbox.initial_state . '] ', '')
  elseif (a:type == 'checkbox')
    " if a:line is a checkbox, remove the checkbox and return
    if (match(a:line, '^ *\[.\]') > -1) | return substitute(a:line, '^\( *\)\[.\] *', '\1', '') | endif

    " if a:line is a checklist item, remove the checkbox and return
    if (match(a:line, '^ *' . li_re . ' \[.\]') > -1)
      return substitute(a:line, '^\( *\)' . li_re . ' \(\[.\]\)', '\1\2', '')
    endif

    " if a:line is a list item, add a checkbox with a state of g:mkdx#settings.checkbox.initial_state
    if (match(a:line, '^ *' . li_re) > -1)
      return substitute(a:line,  '^\( *\)' . li_re, '\1\2 [' . g:mkdx#settings.checkbox.initial_state . ']', '')
    endif
    " otherwise, if it isn't a checkbox item, turn it into one
    return substitute(a:line, '^\( *\)', '\1' . '[' . g:mkdx#settings.checkbox.initial_state . '] ', '')
  elseif (a:type == 'off')
    " if a:line is either a list, checklist or checkbox item, remove the
    " marking while maintaining whitespace
    return substitute(a:line, '^\( *\)\(' . li_re . ' \?\)\?\(\[.\]\)\? *', '\1', '')
  endif

  return a:line
endfun

fun! mkdx#ToggleList()
  call setline('.', s:ToggleLineType(getline('.'), 'list'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-list)")
endfun

fun! mkdx#ToggleChecklist()
  call setline('.', s:ToggleLineType(getline('.'), 'checklist'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-checklist)")
endfun

fun! mkdx#ToggleCheckboxTask()
  call setline('.', s:ToggleLineType(getline('.'), 'checkbox'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-checkbox)")
endfun

fun! mkdx#ToggleQuote()
  call setline('.', s:ToggleTokenAtStart(getline('.'), '>'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-quote)")
endfun

fun! mkdx#ToggleHeader(...)
  let increment = get(a:000, 0, 0)
  let line      = getline('.')

  if (match(line, '^' . g:mkdx#settings.tokens.header . '\{1,6} ') == -1) |  return | endif

  let parts     = split(line, '^' . g:mkdx#settings.tokens.header . '\{1,6} \zs')
  let new_level = strlen(substitute(parts[0], ' ', '', 'g')) + (increment ? -1 : 1)
  let new_level = new_level > 6 ? 1 : (new_level < 1 ? 6 : new_level)

  call setline('.', repeat(g:mkdx#settings.tokens.header, new_level) . ' ' . parts[1])
  silent! call repeat#set("\<Plug>(mkdx-" . (increment ? 'promote' : 'demote') . "-header)")
endfun

fun! mkdx#Tableize() range
  let next_nonblank       = nextnonblank(a:firstline)
  let firstline           = getline(next_nonblank)
  let first_delimiter_pos = match(firstline, '[,\t]')

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

  let ld  = ' ' . g:mkdx#settings.table.divider . ' '
  let lhd = g:mkdx#settings.table.header_divider .  g:mkdx#settings.table.divider . g:mkdx#settings.table.header_divider

  for linec in linecount
    if !empty(filter(lines[linec], '!empty(v:val)'))
      call setline(a:firstline + linec,
        \ ld[1:2] . join(map(lines[linec], 's:CenterString(v:val, col_maxlen[v:key])'), ld) . ld[0:1])
    endif
  endfor

  let hline = join(map(values(col_maxlen), 'repeat(g:mkdx#settings.table.header_divider, v:val)'), lhd)

  call s:InsertLine(lhd[1:2] . hline . lhd[0:1], next_nonblank)
  call cursor(a:lastline + 1, 1)
endfun

fun! s:NextListNumber(current, depth)
  let curr  = substitute(a:current, '^ \+\| \+$', '', 'g')
  let tdot  = match(curr, '\.$') > -1
  let parts = split(curr, '\.')

  if (len(parts) > a:depth) | let parts[a:depth] = str2nr(parts[a:depth]) + 1 | endif
  return join(parts, '.') . (tdot ? '.' : '')
endfun

fun! mkdx#EnterHandler()
  let lnum    = line('.')
  let cnum    = virtcol('.')
  let line    = getline(lnum)

  if (!empty(line))
    let len     = strlen(line)
    let at_end  = cnum > len
    let sp_pat  = '^ *\(\([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\)\( \[.\]\)\?\|\[.\]\)'
    let results = matchlist(line, sp_pat)
    let t       = get(results, 2, '')
    let tcb     = match(get(results, 1, ''), '^ *\[.\] *') > -1
    let cb      = match(get(results, 3, ''), ' *\[.\] *') > -1
    let special = !empty(t)
    let remove  = empty(substitute(line, sp_pat . ' *', '', ''))
    let incr    = len(split(get(matchlist(line, '^ *\([0-9.]\+\)'), 1, ''), '\.')) - 1
    let upd_tl  = (cb || tcb) && g:mkdx#settings.checkbox.update_tree != 0 && at_end
    let tl_prms = remove ? [line('.') - 1, -1] : ['.', 1]

    if (at_end && !remove && match(line, '^ *[0-9.]\+') > -1)
      let min_indent = indent(lnum)

      while (nextnonblank(lnum) == lnum)
        let lnum += 1

        if (indent(lnum) < min_indent) | break | endif
        call setline(lnum,
          \ substitute(getline(lnum),
          \            '^\( \{' . min_indent . ',}\)\([0-9.]\+\)',
          \            '\=submatch(1) . s:NextListNumber(submatch(2), ' . incr . ')', ''))
      endwhile
    endif

    if (remove)  | call setline('.', '')                                             | endif
    if (upd_tl)  | call call('s:UpdateTaskList', tl_prms)                            | endif
    if (remove)  | return ''                                                         | endif
    if (!at_end) | return "\n"                                                       | endif
    if (tcb)     | return "\n" . '[' . g:mkdx#settings.checkbox.initial_state . '] ' | endif
    return ("\n"
      \ . (match(t, '[0-9.]\+') > -1 ? s:NextListNumber(t, incr > -1 ? incr : 0) : t)
      \ . (cb ? ' [' . g:mkdx#settings.checkbox.initial_state . '] ' : (special ? ' ' : '')))
  endif

  return "\n"
endfun

fun! mkdx#GenerateOrUpdateTOC()
  for lnum in range((getpos('^')[1] + 1), getpos('$')[1])
    if (match(getline(lnum), '^' . g:mkdx#settings.tokens.header . '\{1,6} \+' . g:mkdx#settings.toc.text) > -1)
      call mkdx#UpdateTOC()
      return
    endif
  endfor

  call mkdx#GenerateTOC()
endfun

fun! mkdx#UpdateTOC()
  let startc = -1
  let nnb    = -1

  for lnum in range((getpos('^')[1] + 1), getpos('$')[1])
    if (match(getline(lnum), '^' . g:mkdx#settings.tokens.header . '\{1,6} \+' . g:mkdx#settings.toc.text) > -1)
      let startc = lnum
      break
    endif
  endfor

  if (startc)
    let endc = startc + (nextnonblank(startc + 1) - startc)
    while nextnonblank(endc) == endc |  let endc += 1 | endwhile
    let endc -= 1
  endif

  exe 'normal! :' . startc . ',' . endc . 'd'
  call mkdx#GenerateTOC()
  normal! ``
endfun

fun! s:ListHeaders()
  let headers = []
  let skip    = 0
  let bnum    = bufnr('%')

  for lnum in range((getpos('^')[1] + 1), getpos('$')[1])
    let line = getline(lnum)
    let lvl  = strlen(get(matchlist(line, '^' . g:mkdx#settings.tokens.header . '\{1,6}'), 0, ''))

    if (match(line, '^\(\`\`\`\|\~\~\~\)') > -1) | let skip = !skip                     | endif
    if (!skip && lvl > 0)                        | call add(headers, [lnum, lvl, line]) | endif
  endfor

  return headers
endfun

fun! s:HeaderToQF(key, value)
  return {'bufnr': bufnr('%'), 'lnum': a:value[0], 'level': a:value[1],
        \ 'text': repeat(g:mkdx#settings.tokens.header, a:value[1]) . ' ' . s:CleanHeader(a:value[2])}
endfun

fun! mkdx#QuickfixHeaders()
  call setqflist(map(s:ListHeaders(), function('<SID>HeaderToQF')))
  exe 'copen'
endfun

fun! mkdx#GenerateTOC()
  let contents = []
  let curspos  = getpos('.')[1]
  let header   = ''
  let prevlvl  = 1
  let skip     = 0
  let headers  = {}
  let headers[s:HeaderToHash(g:mkdx#settings.toc.text)] = 1

  for [lnum, lvl, line] in s:ListHeaders()
    if (empty(header) && lnum > curspos)
      let header = repeat(g:mkdx#settings.tokens.header, prevlvl) . ' ' . g:mkdx#settings.toc.text
      call insert(contents, header)
      call add(contents, repeat(repeat(' ', &sw), prevlvl - 1) . g:mkdx#settings.toc.list_token . ' ' . s:HeaderToListItem(header))
    endif

    let hsh = s:HeaderToHash(line)
    let c   = get(headers, hsh, 0)
    let li  = s:HeaderToListItem(line, c > 0 ? '-' . c : '')
    if (c == 0) | let headers[hsh] = 1 | else | let headers[hsh] += 1 | endif

    call add(contents, repeat(repeat(' ', &sw), lvl - 1) . g:mkdx#settings.toc.list_token . ' ' . li)
    let prevlvl = lvl
  endfor

  let c = curspos - 1
  for item in contents
    call append(c, item)
    let c += 1
  endfor

  call cursor(curspos, 1)
  normal! Ak
endfun

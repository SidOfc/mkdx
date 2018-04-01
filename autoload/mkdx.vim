""""" UTILITY FUNCTIONS
let s:util = {}
let s:util.modifier_mappings = {
      \ 'C': 'ctrl',
      \ 'M': 'meta',
      \ 'S': 'shift',
      \ 'ctrl': 'ctrl',
      \ 'meta': 'meta',
      \ 'shift': 'shift'
      \ }

fun! s:util.WrapSelectionOrWord(...)
  let mode  = get(a:000, 0, 'n')
  let start = get(a:000, 1, '')
  let end   = get(a:000, 2, start)
  let _r    = @z

  if (mode != 'n')
    let [slnum, scol] = getpos("'<")[1:2]
    let [elnum, ecol] = getpos("'>")[1:2]

    call cursor(elnum, ecol)
    exe 'normal! a' . end
    call cursor(slnum, scol)
    exe 'normal! i' . start
    call cursor(elnum, ecol)
  else
    normal! "zdiw
    let nl = virtcol('.') == strlen(getline('.'))
    let @z = start . @z . end
    exe 'normal! "z' . (nl ? 'p' : 'P')
  endif

  let zz = @z
  let @z = _r
  return zz
endfun

fun! s:util.IsImage(str)
  if (empty(g:mkdx#settings.image_extension_pattern)) | return 0 | endif
  return match(get(split(a:str, '\.'), -1, ''), g:mkdx#settings.image_extension_pattern) > -1
endfun

fun! s:util.ToggleMappingToKbd(str)
  let input = a:str
  let parts = split(input, '[-\+]')
  let state = { 'regular': 0, 'meta': 0, 'ctrl': 0, 'shift': 0 }
  let ilen  = len(parts) - 1
  let idx   = 0
  let out   = []
  let res   = -1

  for key in parts
    if (match(key, '/kbd') > -1)
      let result = substitute(key, '</\?kbd>', '', 'g')
    else
      let is_mod         = has_key(s:util.modifier_mappings, key)
      let updater        = is_mod ? s:util.modifier_mappings[key] : 'regular'
      let result         = is_mod && state[updater] == 0 ? s:util.modifier_mappings[key] : tolower(key)
      let result         = idx == ilen ? tolower(key) : result
      let updater        = idx == ilen ? 'regular' : updater
      let state[updater] = 1
      let idx           += 1
      let result         = '<kbd>' . result . '</kbd>'
    endif

    call add(out, result)
  endfor

  return join(out, '+')
endfun

fun! s:util.ToggleTokenAtStart(line, token, ...)
  let line   = a:line
  let tok_re = '^' . a:token . ' '

  if (match(line, tok_re) > -1)
    return substitute(line, tok_re, '', '')
  elseif (!empty(line))
    return get(a:000, 0, a:token) . ' ' . line
  else
    return line
  endif
endfun

fun! s:util.ToggleLineType(line, type)
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

fun! s:util.ListHeaders()
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

fun! s:util.HeaderToQF(key, value)
  return {'bufnr': bufnr('%'), 'lnum': a:value[0], 'level': a:value[1],
        \ 'text': repeat(g:mkdx#settings.tokens.header, a:value[1]) . ' ' . s:util.CleanHeader(a:value[2])}
endfun

fun! s:util.FormatTOCHeader(level, content, ...)
  return repeat(repeat(' ', &sw), a:level) . g:mkdx#settings.toc.list_token . ' ' . s:util.HeaderToListItem(a:content, get(a:000, 0, ''))
endfun

fun! s:util.EscapeTags(str)
  return substitute(substitute(a:str, '<', '\&lt;', 'g'), '>', '\&gt;', 'g')
endfun

fun! s:util.HeaderToATag(header, ...)
  let cheader = substitute(s:util.CleanHeader(a:header), ' \+$', '', 'g')
  let cheader = substitute(cheader, '\\\@<!`\(.*\)\\\@<!`', '<code>\1</code>', 'g')
  let cheader = substitute(cheader, '<code>\(.*\)</code>', '\="<code>" . s:util.EscapeTags(submatch(1)) . "</code>"', 'g')
  let cheader = substitute(cheader, '\\<\(.*\)>', '\&lt;\1\&gt;', 'g')
  let cheader = substitute(cheader, '\\`\(.*\)\\`', '`\1`', 'g')
  return '<a href="#' . s:util.HeaderToHash(a:header) . get(a:000, 0, '') . '">' . cheader . '</a>'
endfun

fun! mkdx#test(header, ...)
  return s:util.HeaderToATag(a:header, get(a:000, 0, ''))
endfun

fun! s:util.HeaderToListItem(header, ...)
  return '[' . substitute(s:util.CleanHeader(a:header), ' \+$', '', 'g') . '](#' . s:util.HeaderToHash(a:header) . get(a:000, 0, '') . ')'
endfun

fun! s:util.CleanHeader(header)
  let h = substitute(a:header, '^[ #]\+\| \+$', '', 'g')
  let h = substitute(h, '\[!\[\([^\]]\+\)\](\([^\)]\+\))\](\([^\)]\+\))', '', 'g')
  return substitute(h, '!\?\[\([^\]]\+\)]([^)]\+)', '\1', 'g')
endfun

fun! s:util.HeaderToHash(header)
  let h = tolower(s:util.CleanHeader(a:header))
  let h = substitute(h, '`<kbd>\(.*\)<\/kbd>`', 'kbd\1kbd', 'g')
  let h = substitute(h, '<kbd>\(.*\)<\/kbd>', '\1', 'g')
  let h = substitute(h, '[^0-9a-z_\- ]\+', '', 'g')
  let h = substitute(h, ' ', '-', 'g')
  return h
endfun

fun! s:util.TaskItem(linenum)
  let line   = getline(a:linenum)
  let token  = get(matchlist(line, '\[\(.\)\]'), 1, '')
  let ident  = strlen(get(matchlist(line, '^>\?\( \{0,}\)'), 1, ''))
  let rem    = ident % &sw
  let ident -= g:mkdx#settings.enter.malformed ? (rem - (rem > &sw / 2 ? &sw : 0)) : 0

  return [token, (ident == 0 ? ident : ident / &sw), line]
endfun

fun! s:util.TasksToCheck(linenum)
  let lnum              = type(a:linenum) == type(0) ? a:linenum : line(a:linenum)
  let cnum              = col('.')
  let current           = s:util.TaskItem(lnum)
  let [ctkn, cind, cln] = current
  let startc            = lnum
  let items             = []

  while (prevnonblank(startc) == startc)
    let indent = s:util.TaskItem(startc)[1]
    if (indent == 0) | break | endif
    let startc -= 1
  endwhile

  if (cind == -1) | return | endif

  while (nextnonblank(startc) == startc)
    let [token, indent, line] = s:util.TaskItem(startc)
    if ((startc < lnum) || (indent != 0))
      call add(items, [startc, token, indent, line])
      let startc += 1
    else
      break
    endif
  endwhile

  return [extend([lnum], current), items]
endfun

fun! s:util.UpdateListNumbers(lnum, depth, ...)
  let lnum       = a:lnum
  let min_indent = strlen(get(matchlist(getline(lnum), '^>\?\( \{0,}\)'), 1, ''))
  let incr       = get(a:000, 0, 0)

  while (nextnonblank(lnum) == lnum)
    let lnum  += 1
    let ln     = getline(lnum)
    let ident  = strlen(get(matchlist(ln, '^>\?\( \{0,}\)'), 1, ''))

    if (ident < min_indent) | break | endif
    call setline(lnum,
      \ substitute(ln,
      \    '^\(>\? \{' . min_indent . ',}\)\([0-9.]\+\)',
      \    '\=submatch(1) . s:util.NextListNumber(submatch(2), ' . a:depth . ', ' . incr . ')', ''))
  endwhile
endfun

fun! s:util.NextListNumber(current, depth, ...)
  let curr  = substitute(a:current, '^ \+\| \+$', '', 'g')
  let tdot  = match(curr, '\.$') > -1
  let parts = split(curr, '\.')
  let incr  = get(a:000, 0, 0)
  let incr  = incr < 0 ? incr : 1

  if (len(parts) > a:depth) | let parts[a:depth] = str2nr(parts[a:depth]) + incr | endif
  return join(parts, '.') . (tdot ? '.' : '')
endfun

fun! s:util.UpdateTaskList(...)
  let linenum               = get(a:000, 0, '.')
  let force_status          = get(a:000, 1, -1)
  let [target, tasks]       = s:util.TasksToCheck(linenum)
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

fun! s:util.InsertLine(line, position)
  let _z = @z
  let @z = a:line

  call cursor(a:position, 1)
  normal! A"zp

  let @z = _z
endfun

fun! s:util.CenterString(str, length)
  let remaining = a:length - strlen(a:str)

  if (remaining < 0)
    return a:str[0:(a:length - 1)]
  endif

  let padleft  = repeat(' ', float2nr(floor(remaining / 2.0)))
  let padright = repeat(' ', float2nr(ceil(remaining / 2.0)))

  return padleft . a:str . padright
endfun

""""" MAIN FUNCTIONALITY
let s:HASH = type({})
fun! mkdx#MergeSettings(...)
  let a = get(a:000, 0, {})
  let b = get(a:000, 1, {})
  let c = {}

  for akey in keys(a)
    if has_key(b, akey)
      if (type(b[akey]) == s:HASH && type(a[akey]) == s:HASH)
        let c[akey] = mkdx#MergeSettings(a[akey], b[akey])
      else
        let c[akey] = b[akey]
      endif
    else
      let c[akey] = a[akey]
    endif
  endfor

  return c
endfun

fun! mkdx#InsertFencedCodeBlock(...)
  let style = !empty(g:mkdx#settings.tokens.fence) ? g:mkdx#settings.tokens.fence : get(a:000, 0, '`')
  let delim = repeat(style, 3)
  return delim . '' . delim
endfun

fun! mkdx#ToggleToKbd(...)
  let m  = get(a:000, 0, 'n')
  let r  = @z
  let ln = getline('.')

  exe 'normal! ' . (m == 'n' ? '"zdiW' : 'gv"zd')
  let oz = @z
  let ps = split(oz, ' ')
  let @z = empty(ps) ? @z : join(map(ps, 's:util.ToggleMappingToKbd(v:val)'), ' ')
  exe 'normal! "z' . (match(ln, (oz . '$')) > -1 ? 'p' : 'P')
  let @z = r

  if (m == 'n')
    silent! call repeat#set("\<Plug>(mkdx-toggle-to-kbd-n)")
  endif
endfun

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
  if (g:mkdx#settings.checkbox.update_tree != 0) | call s:util.UpdateTaskList() | endif
  silent! call repeat#set("\<Plug>(mkdx-checkbox-" . (reverse ? 'prev' : 'next') . ")")
endfun

fun! mkdx#WrapText(...)
  let m = get(a:000, 0, 'n')
  let w = get(a:000, 1, '')
  let x = get(a:000, 2, w)
  let a = get(a:000, 3, '')

  call s:util.WrapSelectionOrWord(m, w, x, a)

  if (a != '')
    silent! call repeat#set("\<Plug>(" . a . ")")
  endif
endfun

fun! mkdx#WrapLink(...) range
  let r = @z
  let m = get(a:000, 0, 'n')

  if (m == 'v')
    normal! gv"zy
    let img = s:util.IsImage(@z)
    call s:util.WrapSelectionOrWord(m, (img ? '!' : '') . '[', '](' . (img ? substitute(@z, '\n', '', 'g') : '') . ')')
    normal! f)
  else
    call s:util.WrapSelectionOrWord(m, '[', ']()')
  end

  let @z = r

  silent! call repeat#set("\<Plug>(mkdx-wrap-link-" . m . ")")

  startinsert
endfun

fun! mkdx#ToggleList()
  call setline('.', s:util.ToggleLineType(getline('.'), 'list'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-list)")
endfun

fun! mkdx#ToggleChecklist()
  call setline('.', s:util.ToggleLineType(getline('.'), 'checklist'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-checklist)")
endfun

fun! mkdx#ToggleCheckboxTask()
  call setline('.', s:util.ToggleLineType(getline('.'), 'checkbox'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-checkbox)")
endfun

fun! mkdx#ToggleQuote()
  call setline('.', s:util.ToggleTokenAtStart(getline('.'), '>'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-quote)")
endfun

fun! mkdx#ToggleHeader(...)
  let increment = get(a:000, 0, 0)
  let line      = getline('.')

  if (!increment && (match(line, '^' . g:mkdx#settings.tokens.header . '\{1,6} ') == -1))
    call setline('.', g:mkdx#settings.tokens.header . ' ' . line)
    return
  endif

  let parts     = split(line, '^' . g:mkdx#settings.tokens.header . '\{1,6} \zs')
  let new_level = len(parts) < 2 ? -1 : strlen(substitute(parts[0], ' ', '', 'g')) + (increment ? -1 : 1)
  let new_level = new_level > 6 ? 0 : (new_level < 0 ? 6 : new_level)
  let tail      = get(parts, 1, parts[0])

  call setline('.', repeat(g:mkdx#settings.tokens.header, new_level) . (new_level > 0 ? ' ' : '') . tail)
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
        \ ld[1:2] . join(map(lines[linec], 's:util.CenterString(v:val, col_maxlen[v:key])'), ld) . ld[0:1])
    endif
  endfor

  let hline = join(map(values(col_maxlen), 'repeat(g:mkdx#settings.table.header_divider, v:val)'), lhd)

  call s:util.InsertLine(lhd[1:2] . hline . lhd[0:1], next_nonblank)
  call cursor(a:lastline + 1, 1)
endfun

fun! mkdx#OHandler()
  normal A
  startinsert!
endfun

fun! mkdx#ShiftOHandler()
  let lnum = line('.')
  let line = getline(lnum)
  let len  = strlen(line)
  let quot = len > 0 ? line[0] == '>' : 0
  let qstr = ''
  if (quot)
    let qstr = quot ? ('>' . get(matchlist(line, '^>\?\( *\)'), 1, '')) : ''
    let line = line[strlen(qstr):]
  endif

  let lin  = get(matchlist(line, '^ *\([0-9.]\+\)'), 1, -1)
  let lis  = get(matchlist(line, '^ *\([' . join(g:mkdx#settings.tokens.enter, '') . ']\)'), 1, -1)

  if (lin != -1)
    let suff = !empty(matchlist(line, '^ *' . lin . ' \[.\]'))
    exe 'normal! O' . qstr . lin . (suff ? ' [' . g:mkdx#settings.checkbox.initial_state . '] ' : ' ')
    call s:util.UpdateListNumbers(lnum, indent(lnum) / &sw)
  elseif (lis != -1)
    let suff = !empty(matchlist(line, '^ *' . lis . ' \[.\]'))
    exe 'normal! O' . qstr . lis . (suff ? ' [' . g:mkdx#settings.checkbox.initial_state . '] ' : ' ')
  elseif (quot)
    let suff = !empty(matchlist(line, '^ *\[.\]'))
    exe 'normal! O' . qstr . (strlen(qstr) > 1 ? '' : ' ') . (suff ? '[' . g:mkdx#settings.checkbox.initial_state . '] ' : '')
  else
    normal! O
  endif

  startinsert!
endfun

fun! mkdx#EnterHandler()
  let lnum    = line('.')
  let cnum    = virtcol('.')
  let line    = getline(lnum)

  if (!empty(line) && g:mkdx#settings.enter.enable)
    let len     = strlen(line)
    let at_end  = cnum > len
    let sp_pat  = '^>\? *\(\([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\)\( \[.\]\)\?\|\[.\]\)'
    let results = matchlist(line, sp_pat)
    let t       = get(results, 2, '')
    let tcb     = match(get(results, 1, ''), '^>\? *\[.\] *') > -1
    let cb      = match(get(results, 3, ''), ' *\[.\] *') > -1
    let quote   = len > 0 ? line[0] == '>' : 0
    let special = !empty(t)
    let remove  = empty(substitute(line, sp_pat . ' *', '', ''))
    let incr    = len(split(get(matchlist(line, '^>\? *\([0-9.]\+\)'), 1, ''), '\.')) - 1
    let upd_tl  = (cb || tcb) && g:mkdx#settings.checkbox.update_tree != 0 && at_end
    let tl_prms = remove ? [line('.') - 1, -1] : ['.', 1]
    let qu_str  = quote ? ('>' . get(matchlist(line, '^>\?\( *\)'), 1, '')) : ''

    if (at_end && match(line, '^>\? *[0-9.]\+') > -1)
      call s:util.UpdateListNumbers(lnum, incr, (remove ? -1 : 1))
    endif

    if (remove)  | call setline('.', '')                                                      | endif
    if (upd_tl)  | call call(s:util.UpdateTaskList, tl_prms)                                  | endif
    if (remove)  | return ''                                                                  | endif
    if (!at_end) | return "\n"                                                                | endif
    if (tcb)     | return "\n" . qu_str . '[' . g:mkdx#settings.checkbox.initial_state . '] ' | endif
    return ("\n"
      \ . qu_str
      \ . (match(t, '[0-9.]\+') > -1 ? s:util.NextListNumber(t, incr > -1 ? incr : 0) : t)
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
  let curpos = getpos('.')

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
  call setpos('.', curpos)
endfun

fun! mkdx#QuickfixHeaders(...)
  let qflist = map(s:util.ListHeaders(), s:util.HeaderToQF)
  if (get(a:000, 0, 1) == 0)
    return qflist
  else
    call setqflist(qflist)
    exe 'copen'
  endif
endfun

fun! mkdx#GenerateTOC()
  let contents = []
  let curspos  = getpos('.')[1]
  let header   = ''
  let prevlvl  = 1
  let skip     = 0
  let headers  = {}
  let src      = s:util.ListHeaders()
  let srclen   = len(src)
  let curr     = 0
  let headers[s:util.HeaderToHash(g:mkdx#settings.toc.text)] = 1
  let toc_pos = g:mkdx#settings.toc.position - 1
  let after_info = get(src, toc_pos, -1)
  let after_pos = toc_pos >= 0 && type(after_info) == type([])

  if (g:mkdx#settings.toc.details.enable)
    let summary_text =
          \ empty(g:mkdx#settings.toc.details.summary)
          \ ? g:mkdx#settings.toc.text
          \ : substitute(g:mkdx#settings.toc.details.summary, '{{toc.text}}', g:mkdx#settings.toc.text, 'g')

    call add(contents, '<details>')
    call add(contents, '<summary>' . summary_text . '</summary>')
    call add(contents, '<ul>')
  endif

  for [lnum, lvl, line] in src
    let curr += 1
    let hsh = s:util.HeaderToHash(line)
    let c   = get(headers, hsh, 0)
    let sfx = c > 0 ? '-' . c : ''
    let spc = repeat(repeat(' ', &sw), lvl)
    if (c == 0)
      let headers[hsh] = 1
    else
      let headers[hsh] += 1
    endif

    let nextlvl    = get(src, curr, [0, lvl])[1]
    let ending_tag = (nextlvl > lvl) ? '<ul>' : '</li>'

    if (g:mkdx#settings.toc.details.enable && lvl < prevlvl)
      let clvl = prevlvl
      while (clvl > lvl)
        let clvl -= 1
        call add(contents, repeat(repeat(' ', &sw), clvl) . '</ul></li>')
      endwhile
    endif

    if (empty(header) && (lnum >= curspos || (curr > toc_pos && after_pos)))
      let header = repeat(g:mkdx#settings.tokens.header, prevlvl) . ' ' . g:mkdx#settings.toc.text
      call insert(contents, '')
      call insert(contents, header)
      if (g:mkdx#settings.toc.details.enable)
        call add(contents, spc . '<li>' . s:util.HeaderToATag(header, sfx) . '</li>')
      else
        call add(contents, s:util.FormatTOCHeader(prevlvl - 1, header, sfx))
      endif
    endif

    if (g:mkdx#settings.toc.details.enable)
      call add(contents, spc . '<li>' . s:util.HeaderToATag(line, sfx) . ending_tag)
    else
      call add(contents, s:util.FormatTOCHeader(lvl - 1, line, sfx))
    endif

    if (empty(header) && curr == srclen)
      let header = repeat(g:mkdx#settings.tokens.header, prevlvl) . ' ' . g:mkdx#settings.toc.text
      call insert(contents, '')
      call insert(contents, header)
      if (g:mkdx#settings.toc.details.enable)
        call add(contents, spc . '<li>' . s:util.HeaderToATag(header, sfx) . '</li>')
      else
        call add(contents, s:util.FormatTOCHeader(prevlvl - 1, header, sfx))
      endif
    endif

    let prevlvl = lvl
  endfor

  if (g:mkdx#settings.toc.details.enable)
    call add(contents, '</ul>')
    call add(contents, '</details>')
  endif

  if (after_pos)
    let c = after_info[0] - 1
  else
    let c = curspos - 1
  endif

  if (nextnonblank(c) == c)
    if (c > 0)
      call insert(contents, '')
    else
      call add(contents, '')
    endif
  endif

  for item in contents
    call append(c, item)
    let c += 1
  endfor

  call cursor(curspos, 1)
endfun

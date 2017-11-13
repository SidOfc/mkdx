fu! mkdx#ToggleCheckboxReplace(line, backwards)
  let l:list = deepcopy(g:mkdx#checkbox_toggles)
  let l:line = a:line
  let l:len  = len(l:list) - 1

  if (a:backwards == 1)
    let l:list = reverse(l:list)
  endif

  for mrk in l:list
    if (match(l:line, "\\[" . mrk . "\\]") != -1)
      let l:nidx = index(l:list, mrk)
      let l:nidx = l:nidx >= l:len ? 0 : l:nidx + 1
      let l:line = substitute(l:line, "\\[" . mrk . "\\]", "\\[" . l:list[l:nidx] . "\\]", "")
      break
    endif
  endfor

  return l:line
endfu

fu! mkdx#ToggleCheckbox(reverse)
  call setline('.', mkdx#ToggleCheckboxReplace(getline('.'), a:reverse))
endfu

fu! mkdx#ToggleCheckboxList(reverse)
  let l:range_start = getpos("'<")[1]
  let l:range_end   = getpos("'>")[1]

  for linenum in range(l:range_start, l:range_end)
    call setline(linenum, mkdx#ToggleCheckboxReplace(getline(linenum), a:reverse))
  endfor
endfu

fu! mkdx#WrapLink()
  let l:line   = getline('.')
  let l:vstart = getpos("'<")[2] - 1
  let l:vend   = getpos("'>")[2]

  let l:b = line[:(l:vstart - 1)]
  let l:s = line[l:vstart:(l:vend - 1)]
  let l:e = line[l:vend:]

  call setline('.', l:b . "[" . l:s . "]()" . l:e)
  call cursor(line('.'), l:vend + 4)
endfu

fu! mkdx#ToggleHeader(increment)
  let l:line = getline('.')

  if (match(l:line, '^#\{1,6\}\s') == -1)
    return
  endif

  let l:parts     = split(l:line, ' ')
  let l:new_level = strlen(l:parts[0]) + (a:increment ? -1 : 1)
  let l:new_level = l:new_level > 6 ? 1 : (l:new_level < 1 ? 6 : l:new_level)

  call setline('.', repeat(g:mkdx#header_style, l:new_level) . ' ' . parts[1])
endfu

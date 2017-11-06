fu! mdx#ToggleCheckbox(reverse)
  let l:list    = deepcopy(g:mdx#checkbox_toggles)
  let l:curline = getline('.')
  let l:len     = len(l:list) - 1

  if (a:reverse == 1)
    let l:list = reverse(l:list)
  endif

  for mrk in l:list
    if (match(l:curline, "\\[" . mrk . "\\]") != -1)
      let l:nidx    = index(l:list, mrk)
      let l:nidx    = l:nidx >= l:len ? 0 : l:nidx + 1
      let l:curline = substitute(l:curline, "\\[" . mrk . "\\]", "\\[" . l:list[l:nidx] . "\\]", "")
      break
    endif
  endfor

  call setline('.', l:curline)
endfu

fu! mdx#WrapLink()
  let l:line   = getline('.')
  let l:vstart = getpos("'<")[2] - 1
  let l:vend   = getpos("'>")[2]

  let l:b = line[:(l:vstart - 1)]
  let l:s = line[l:vstart:(l:vend - 1)]
  let l:e = line[l:vend:]

  call setline('.', l:b . "[" . l:s . "]()" . l:e)
  call cursor(line('.'), l:vend + 4)
endfu

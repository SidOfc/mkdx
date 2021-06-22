""""" UTILITY FUNCTIONS
" Extracted from shiftwidth() documentation
if exists('*shiftwidth')
  fun! s:sw()
    return shiftwidth()
  endfunc
else
  fun! s:sw()
    return &sw
  endfunc
endif

let s:_is_nvim               = has('nvim')
let s:_has_curl              = executable('curl')
let s:_can_async             = s:_is_nvim || has('job')
let s:util                   = {}
let s:util.modifier_mappings = {
      \ 'C': 'ctrl',
      \ 'M': 'meta',
      \ 'S': 'shift',
      \ 'ctrl': 'ctrl',
      \ 'meta': 'meta',
      \ 'shift': 'shift'
      \ }

let s:util.grepopts = {
      \ 'rg':    { 'opts': ['--vimgrep', '-o'] },
      \ 'ag':    { 'opts': ['--vimgrep'] },
      \ 'cgrep': { 'opts': ['--regex-pcre', '--format="#f:#n:#0"'] },
      \ 'ack':   { 'opts': ['-H', '--column', '--nogroup'] },
      \ 'pt':    { 'opts': ['--nocolor', '--column', '--numbers', '--nogroup'], 'pat_flag': '-e' },
      \ 'ucg':   { 'opts': ['--column'] },
      \ 'sift':  { 'opts': ['-n', '--column', '--only-matching'] },
      \ 'grep':  { 'opts': ['-o', '--line-number', '--byte-offset'], 'pat_flag': '-E' },
      \ 'ggrep': { 'opts': ['-o', '--line-number', '--byte-offset'], 'pat_flag': '-E' }
      \ }

fun! s:util.set_grep()
  for tool in ['rg', 'ag', 'cgrep', 'ack', 'pt', 'ucg', 'sift', 'ggrep', 'grep']
    if (executable(tool)) | return tool | endif
  endfor
endfun

let s:util.grepcmd     = s:util.set_grep()
let s:_can_vimgrep_fmt = has_key(s:util.grepopts, s:util.grepcmd)
let s:_testing         = 0

fun! mkdx#testing(val)
  let s:_testing = a:val == 1 ? 1 : 0
endfun

fun! s:util._(...)
  return get(a:000, 0, '')
endfun

fun! s:util.getMimeType(path)
  if (!filereadable(a:path)) | return '' | endif

  if executable('file')
    return system('file -b --mime-type ' . shellescape(a:path))
  else
    return 'text/plain'
  endif
endfun

let s:HASH = type({})
let s:LIST = type([])
let s:INT  = type(1)
let s:STR  = type('')
let s:FUNC = type(s:util._)

fun! s:util.TypeString(t)
  return (a:t == s:HASH) ? 'hash'
     \ : (a:t == s:LIST) ? 'list'
     \ : (a:t == s:INT)  ? 'int'
     \ : (a:t == s:STR)  ? 'str'
     \ : (a:t == s:FUNC) ? 'func' : 'unknown'
endfun

fun! s:util.log(str, ...)
  let opts = extend({'hl': 'Comment', 'log': 0}, get(a:000, 0, {}))
  exe 'echohl ' . opts.hl
  exe 'echo' . (opts.log ? 'm' : '') . " '" . a:str . "'"
  echohl None
endfun

fun! s:util.add_dict_watchers(hash, ...)
  let keypath  = get(a:000, 0, [])

  call dictwatcheradd(a:hash, '*', function(s:util.OnSettingModified, [keypath]))
  for key in keys(a:hash)
    if (type(a:hash[key]) == s:HASH)
      call s:util.add_dict_watchers(a:hash[key], extend(deepcopy(keypath), [key]))
    endif
  endfor
endfun

fun! s:util.OnSettingModified(path, hash, key, value)
  if (&ft !=? 'markdown') | return | endif

  let to = type(a:value.old)
  let tn = type(a:value.new)
  let yy = extend(deepcopy(a:path), [a:key])
  if (yy[0] != 'mkdx#settings') | let yy = extend(['mkdx#settings'], yy) | endif
  let yy[0] = 'g:' . yy[0]
  let sk = join(yy, '.')
  let ch = (yy[-1] == 'enable') || ((to == tn) && (a:value.old != a:value.new))
  let er = []
  let et = 0
  let hu = has_key(s:util.updaters, sk)
  let s:util._last_time = get(s:util, '_last_time', localtime())

  if ((localtime() - s:util._last_time) > 1)
    unlet s:util._last_time
    let   s:util._err_count = 0
  else
    let s:util._err_count = get(s:util, '_err_count', 0)
  endif

  if (to != tn)
    let [tos, tns] = [s:util.TypeString(to), s:util.TypeString(tn)]

    if (s:util._err_count > 0)
      echo ' '
    endif

    call s:util.log('mkdx: {' . sk . '} value must be of type {' . tos . '}, got {' . tns . '}', {'hl': 'ErrorMsg'})
    call s:util.DidNotUpdateValueAt(yy, ['mkdx-error-type'])

    let a:hash[a:key]      = a:value.old
    let et                 = 1
    let s:util._err_count += 1
  elseif (to == s:HASH)
    let a:hash[a:key] = mkdx#MergeSettings(a:value.old, a:value.new, {'modify': 1})
  elseif (ch && (has_key(s:util.validations, sk) || has_key(s:util.validations, a:key)))
    let er = s:util.validate(a:value.new, get(s:util.validations, sk, get(s:util.validations, a:key, {})))
    if (!empty(er))
      let s:util._err_count += len(er)
      let validation_tags    = []
      for [error, validation] in er
        if (s:util._err_count > 1)
          echo ' '
        endif
        call s:util.log(sk . ' ' . error, {'hl': 'ErrorMsg'})
        call add(validation_tags, 'mkdx-error-' . validation)
      endfor
      call s:util.DidNotUpdateValueAt(yy, validation_tags)
      let a:hash[a:key] = a:value.old
    endif
  endif

  if (g:mkdx#settings.auto_update.enable && !et && empty(er) && ch && hu)
    let Updater = function(s:util.updaters[sk])
    call Updater(a:value.old, a:value.new)
  elseif ((to != s:HASH) && (s:util._err_count == 0))
    echo ''
  endif
endfun

fun! s:util.ReplaceTOCText(old, new)
  let [current, endc, details] = s:util.GetTOCPositionAndStyle()

  silent! call mkdx#UpdateTOC({'text': a:old, 'details': details})
  silent! update
endfun

fun! s:util.RepositionTOC(old, new)
  let [current, endc, details] = s:util.GetTOCPositionAndStyle()

  if (current > -1)
    silent! exe 'normal! :' . current . ',' . endc . 'd'
  endif

  call mkdx#GenerateTOC(0, details)
endfun

fun! s:util.UpdateTOCStyle(old, new)
  if a:old !=? a:new
    silent! call mkdx#UpdateTOC({'details': a:new, 'force': 1})
  endif
endfun

fun! s:util.UpdateTOCDetails(old, new)
  let details = get(s:util.GetTOCPositionAndStyle(), 2, g:mkdx#settings.toc.details.enable)

  if (details)
    silent! call mkdx#UpdateTOC({'details': details})
  endif
endfun

fun! s:util.UpdateFencedCodeBlocks(old, new)
  for lnum in range(1, line('$'))
    let line = getline(lnum)
    if (match(line, '^' . repeat('\' . a:old, 3)) > -1)
      call setline(lnum, repeat(a:new, 3) . line[3:])
    endif
  endfor
endfun

fun! s:util.UpdateFolds(old, new)
  if (!g:mkdx#settings.fold.enable) | return | endif

  let s:util._fold_fence = index(a:new, 'fence') > -1
  let s:util._fold_toc   = index(a:new, 'toc')   > -1

  normal! zx
endfun

fun! s:util.ToggleFolds(old, new)
  if (!g:mkdx#settings.fold.enable) | return | endif

  if (a:new)
    if (&foldexpr != 'mkdx#fold(v:lnum)')
      setlocal foldmethod=expr
      setlocal foldexpr=mkdx#fold(v:lnum)
    endif
  else
    setlocal foldexpr=
  endif

  normal! zx
endfun

fun! s:util.ToggleCompletions(old, new)
  if (a:new)
    if (&completefunc != 'mkdx#Complete')
      setlocal completefunc=mkdx#Complete
      setlocal pumheight=15
      setlocal iskeyword+=\-
      if (!hasmapto('<Plug>(mkdx-ctrl-n-compl)', 'i'))
        imap <buffer><silent> <C-n> <Plug>(mkdx-ctrl-n-compl)
      endif
      if (!hasmapto('<Plug>(mkdx-ctrl-p-compl)', 'i'))
        imap <buffer><silent> <C-p> <Plug>(mkdx-ctrl-p-compl)
      endif
      if (!hasmapto('<Plug>(mkdx-link-compl)', 'i'))
        imap <buffer><silent> # <Plug>(mkdx-link-compl)
      endif
    endif
  else
    setlocal completefunc=
    setlocal pumheight=0
    setlocal iskeyword-=\-
  endif
endfun

fun! s:util.ToggleEnter(old, new)
  if (a:new)
    setlocal formatoptions-=r
    setlocal autoindent

    if (!hasmapto('<Plug>(mkdx-enter)', 'i'))
      imap <buffer><silent> <Cr> <Plug>(mkdx-enter)
    endif

    if (!hasmapto('<Plug>(mkdx-o)', 'n') && g:mkdx#settings.enter.o)
      nmap <buffer><silent> o <Plug>(mkdx-o)
    endif

    if (!hasmapto('<Plug>(mkdx-shift-o)', 'n') && g:mkdx#settings.enter.shifto)
      nmap <buffer><silent> O <Plug>(mkdx-shift-o)
    end
  endif
endfun

let s:util.mkdx_loadpath = get(filter(split(&rtp, ','), {idx, plugin -> match(plugin, 'mkdx/\?$') > -1}), 0, '')
let s:util.mkdx_loadpath = !empty(s:util.mkdx_loadpath) ? substitute(s:util.mkdx_loadpath, '/\+$', '', 'g') : s:util.mkdx_loadpath
let s:util.syn_loadpath  = join([s:util.mkdx_loadpath, 'after/syntax/markdown.vim'], '/')
let s:util.hl_names      = ['mkdxTable', 'mkdxTableDelimiter', 'mkdxTableAlign', 'mkdxTableHeader',
                          \ 'mkdxTableHeadDelimiter', 'mkdxTableCaption', 'mkdxTableCaptionDelimiter',
                          \ 'mkdxListItem', 'mkdxCheckboxEmpty', 'mkdxCheckboxPending', 'mkdxCheckboxComplete',
                          \ 'mkdxTildeFence', 'mkdxBoldItalic', 'mkdxBoldItalicDelimiter', 'mkdxInlineCode',
                          \ 'mkdxInlineCodeDelimiter', 'mkdxKbdText', 'mkdxKbdOpening', 'mkdxKbdEnding',
                          \ 'mkdxLink', 'mkdxCriticAddition', 'mkdxCriticAddStartMark',
                          \ 'mkdxCriticAddEndMark', 'mkdxCriticDeletion', 'mkdxCriticDelStartMark',
                          \ 'mkdxCriticSubRemove', 'mkdxCriticSubStartMark', 'mkdxCriticSubstitute',
                          \ 'mkdxCriticSubTransMark', 'mkdxCriticSubEndMark', 'mkdxCriticComment',
                          \ 'mkdxCriticHighlight', 'mkdxYAMLHeader']

fun! s:util.ToggleHighlight(old, new)
  if (a:new)
    exe 'so ' . s:util.syn_loadpath
  else
    for group_name in s:util.hl_names
      exe 'highlight clear ' . group_name
    endfor
    setf markdown
  endif
endfun

fun! s:util.UpdateHeaders(old, new)
  let skip = 0

  for lnum in range(1, line('$'))
    let line = getline(lnum)
    let skip = match(line, '^\(\`\`\`\|\~\~\~\)') > -1 ? !skip : skip
    if (!skip && (line =~ ('^' . a:old . '\{1,6} ')))
      call setline(lnum, substitute(line, '^' . a:old . '\{1,6}', '\=repeat("' . a:new . '", strlen(submatch(0)))', ''))
    endif
  endfor
endfun

let s:util.validations = {
      \ 'g:mkdx#settings.checkbox.toggles':     { 'min-length': [2,                'value must be a list with at least 2 states'] },
      \ 'g:mkdx#settings.checkbox.update_tree': { 'between':    [[0, 2],           'value must be >= 0 and <= 2'] },
      \ 'g:mkdx#settings.links.conceal':        { 'only-valid': [[0, 1],           'value must 0 or 1'] },
      \ 'g:mkdx#settings.tokens.fence':         { 'only-valid': [['`', '~'],       "value can only be '`' or '~'"] },
      \ 'g:mkdx#settings.fold.components':      { 'only-list':  [['toc', 'fence'], 'list can only contain string entries "toc" and "fence"'] },
      \ }

let s:util.updaters = {
      \ 'g:mkdx#settings.toc.text': s:util.ReplaceTOCText,
      \ 'g:mkdx#settings.toc.details.enable': s:util.UpdateTOCStyle,
      \ 'g:mkdx#settings.toc.details.summary': s:util.UpdateTOCDetails,
      \ 'g:mkdx#settings.toc.details.nesting_level': s:util.UpdateTOCDetails,
      \ 'g:mkdx#settings.toc.details.child_count': s:util.UpdateTOCDetails,
      \ 'g:mkdx#settings.toc.details.child_summary': s:util.UpdateTOCDetails,
      \ 'g:mkdx#settings.toc.position': s:util.RepositionTOC,
      \ 'g:mkdx#settings.tokens.header': s:util.UpdateHeaders,
      \ 'g:mkdx#settings.tokens.fence': s:util.UpdateFencedCodeBlocks,
      \ 'g:mkdx#settings.fold.components': s:util.UpdateFolds,
      \ 'g:mkdx#settings.fold.enable': s:util.ToggleFolds,
      \ 'g:mkdx#settings.links.fragment.complete': s:util.ToggleCompletions,
      \ 'g:mkdx#settings.enter.enable': s:util.ToggleEnter,
      \ 'g:mkdx#settings.highlight.enable': s:util.ToggleHighlight
      \ }

fun! s:util.validate(value, validations)
  let errors = []
  for validation in keys(a:validations)
    let [boundary, msg] = a:validations[validation]
    if (validation == 'min-length')
      let len = type(a:value) == s:STR ? strlen(a:value) : len(a:value)
      if (len < boundary)
        call add(errors, [msg, validation])
      endif
    elseif (validation == 'between')
      if (type(a:value) == s:INT)
        if (a:value < boundary[0] || a:value > boundary[1])
          call add(errors, [msg, validation])
        endif
      endif
    elseif (validation == 'only-valid')
      if (index(boundary, a:value) == -1)
        call add(errors, [msg, validation])
      endif
    elseif (validation == 'only-list')
      if (len(filter(copy(a:value), {idx, itm -> index(boundary, itm) == -1})) > 0)
        call add(errors, [msg, validation])
      endif
    endif
  endfor
  return errors
endfun

fun! s:util.DidNotUpdateValueAt(path, ...)
  let helptags = extend((len(a:path) == 1) ? [] : ['mkdx-setting-' . substitute(join(a:path[1:], '-'), '_', '-', 'g')], get(a:000, 0, []))

  call s:util.log('info: did not update value of {' . join(a:path, '.') . '}')
  call s:util.log('help: ' . join(helptags, ', '))
endfun

fun! s:util.JumpToHeader(link, hashes, jid, stream, ...)
  if (s:util._header_found) | return | endif
  let stream = type(a:stream) == s:LIST ? a:stream : [a:stream]
  call filter(stream, {idx, line -> !empty(line)})

  for line in stream
    let item = s:util.IdentifyGrepLink(line)
    let hash = item.type == 'anchor' ? item.content : s:util.transform(tolower(getline(item.lnum)), ['clean-header', 'header-to-hash'])
    let a:hashes[hash] = get(a:hashes, hash, -1) + 1
    let suffixed_hash  = hash . (a:hashes[hash] == 0 ? '' : ('-' . a:hashes[hash]))
    if (a:link == suffixed_hash)
      let s:util._header_found = 1
      if (g:mkdx#settings.links.fragment.jumplist)
        normal! m'0
      endif
      call cursor(item.lnum, 0)
      redraw
      break
    endif
  endfor

  if (!s:util._header_found)
    for lnum in range(2, line('$'))
      let line = getline(lnum)
      if (match(line, '^\(===\|---\)') !=# -1)
        let line_hash = s:util.transform(tolower(getline(lnum - 1)), ['clean-header', 'header-to-hash'])
        if (a:link ==# line_hash)
          if (g:mkdx#settings.links.fragment.jumplist)
            normal! m'0
          endif
          call cursor(lnum - 1, 0)
          redraw
          break
        endif
      endif
    endfor
  endif
endfun

fun! s:util.EchoQuickfixCount(subject, ...)
  let total = len(getqflist())
  call s:util.log(total . ' ' . (total == 1 ? a:subject : a:subject . 's'), {'hl': (total > 0) ? 'MoreMsg' : 'ErrorMsg'})
  return total
endfun

fun! s:util.AddHeaderToQuickfix(bufnr, jid, stream, ...)
  let stream     = type(a:stream) == s:LIST ? a:stream : [a:stream]
  let TQF        = {gl -> {'lnum': gl.lnum, 'bufnr': a:bufnr, 'text': s:util.transform(gl.content, ['clean-header'])}}
  let qf_entries = map(filter(stream, {idx, line -> !empty(line)}), {idx, line -> TQF(s:util.IdentifyGrepLink(line))})
  let qf_entries = filter(qf_entries, {idx, entry -> !empty(get(entry, 'text', ''))})

  if (len(qf_entries) > 0) | call setqflist(qf_entries, 'a') | endif
  if (s:util.EchoQuickfixCount('header')) | copen | else | cclose | endif
endfun

fun! s:util.CsvRowToList(...)
  let line = substitute(get(a:000, 0, getline('.')), '^\s\+|\s\+$', '', 'g')
  let len  = strlen(line) - 1

  if (len < 1) | return [] | endif

  let quote    = ""
  let escaped  = 0
  let currcol  = ""
  let result   = []

  for idx in range(0, len)
    let char = line[idx]
    if (escaped)
      let currcol .= char
      let escaped  = 0
    elseif (char == "\\")
      let escaped = 1
    elseif (!empty(quote))
      if (char != quote)
        let currcol .= char
      else
        let quote = ""
      endif
    elseif ((char == "'") || (char == "\""))
      let quote = char
    elseif ((char == ",") || (char == "\t"))
      call add(result, currcol)
      let currcol = ""
    else
      let currcol .= char
    endif
  endfor

  if (!empty(currcol))
    call add(result, currcol)
  endif

  return result
endfun

fun! s:util.ExtractCurlHttpCode(data, ...)
  let status = s:_is_nvim ? get(get(a:000, 1, []), 0, '404') : get(a:000, 1, '404')
  let status = status =~ '\D' ? 500 : str2nr(status)
  let qflen  = len(getqflist())
  let total  = a:data[0]

  if (status < 200 || status > 299)
    let [total, bufnum, lnum, column, url] = a:data
    let suff   = status == 0 ? '---' : repeat('0', 3 - strlen(status)) . status
    let text   = suff . ': ' . url
    let qflen += 1

    call setqflist([{'bufnr': bufnum, 'lnum': lnum, 'col': column + 1, 'text': text, 'status': status}], 'a')
    if (qflen == 1) | copen | endif
  endif

  call s:util.log(qflen . '/' . total . ' dead link' . (qflen == 1 ? '' : 's'), {'hl': (qflen > 0 ? 'ErrorMsg' : 'MoreMsg')})
  if (qflen > 0) | copen | else | cclose | endif
endfun

fun! s:util.GetRemoteUrl()
  if (!empty(g:mkdx#settings.links.external.host))
    return [g:mkdx#settings.links.external.host, '']
  endif

  let remote = system('git ls-remote --get-url 2>/dev/null')

  if (!v:shell_error && strlen(remote) > 4)
    let secure = remote[0:4] == "https"
    let branch = system('git branch 2>/dev/null | grep "\*.*"')
    if (!v:shell_error && strlen(branch) > 0)
      let remote = substitute(substitute(remote[0:-2], '^\(\(https\?:\)\?//\|.*@\)\|\.git$', '', 'g'), ':', '/', 'g')
      let remote = (secure ? 'https' : 'http') . '://' . remote . '/blob/' . branch[2:-2] . '/'
      return [remote, substitute(branch, '^ \+\| \+$', '', 'g')]
    endif
    return ['', '']
  endif
  return ['', '']
endfun

fun! s:util.AsyncDeadExternalToQF(...)
  let prev_tot = get(a:000, 1, 0)
  let external = filter(s:util.ListLinks(), {idx, val -> val[2][0] != '#'})
  let ext_len  = len(external)

  if (get(a:000, 0, 1)) | call setqflist([]) | endif
  if (ext_len == 0) | return [] | endif

  let bufnum           = bufnr('%')
  let total            = ext_len + prev_tot
  let [remote, branch] = ext_len > 0 ? s:util.GetRemoteUrl() : ''
  let skip_rel         = !g:mkdx#settings.links.external.relative ? 1 : (ext_len > 0 && empty(remote))

  for [lnum, column, url] in external
    let has_frag = url[0]   == '#'
    let has_prot = url[0:1] == '//'
    let has_http = url[0:3] == 'http'

    if (!skip_rel && !has_frag && !has_http && !has_prot)
      let tail = substitute(url, '^/\+', '', '')
      let brsl = len(split(branch, '/')) - 1
      if (brsl > 0 && tail[0:2] == '../')
        let tail = repeat('../', brsl) . tail
      endif
      let url = substitute(remote, '/\+$', '', '') . '/' . tail
    endif

    let cmd = 'curl -L -I -s --no-keepalive -o /dev/null -A "' . g:mkdx#settings.links.external.user_agent . '" -m ' . g:mkdx#settings.links.external.timeout . ' -w "%{http_code}" "' . url . '"'

    if (!skip_rel)
      if (s:_is_nvim)
        call jobstart(cmd, {'on_stdout': function(s:util.ExtractCurlHttpCode, [[total, bufnum, lnum, column, url]]), 'stdout_buffered': 1})
      elseif (s:_can_async)
        call job_start(cmd, {'pty': 0, 'out_cb': function(s:util.ExtractCurlHttpCode, [[total, bufnum, lnum, column, url]])})
      endif
    endif
  endfor

  return external
endfun

fun! s:util.ListLinks()
  let limit = line('$') + 1
  let lnum  = 1
  let links = []

  while (lnum < limit)
    let line = getline(lnum)
    let col  = 0
    let len  = strlen(line)

    while (col < len)
        if (tolower(synIDattr(synID(lnum, 1, 0), 'name')) == 'markdowncode') | break | endif
        let tcol = match(line[col:], '\](\([^)]\+\))')
        let href = tcol > -1 ? -1 : match(line[col:], 'href="\([^"]\+\)"')
        let html = href > -1
        if ((html && href < 0) || (!html && tcol < 0)) | break | endif
        let col += html ? href : tcol
        let rgx  = html ? 'href="\([^"]\+\)"' : '\](\([^)]\+\))'

        let matchtext = get(matchlist(line[col:], rgx), 1, -1)
        if (matchtext == -1) | break | endif

        call add(links, [lnum, col + (html ? 6 : 2), matchtext])
        let col += strlen(matchtext)
    endwhile

    let lnum += 1
  endwhile

  return links
endfun

fun! s:util.ListIDAnchorLinks()
  let limit = line('$') + 1
  let lnum  = 1
  let links = []

  while (lnum < limit)
    let line = getline(lnum)
    let col  = 0
    let len  = strlen(line)

    while (col < len)
        if (tolower(synIDattr(synID(lnum, 1, 0), 'name')) == 'markdowncode') | break | endif
        let id = match(line[col:], '\(name\|id\)="\([^"]\+\)"')
        if (id < 0) | break | endif
        let col += id

        let matchtext = get(matchlist(line[col:], '\(name\|id\)="\([^"]\+\)"'), 2, -1)
        if (matchtext == -1) | break | endif

        call add(links, [lnum, col, matchtext])
        let col += strlen(matchtext)
    endwhile

    let lnum += 1
  endwhile

  return links
endfun

fun! s:util.FindDeadFragmentLinks()
  let headers = {}
  let hashes  = []
  let dead    = []
  let frags   = filter(s:util.ListLinks(), {idx, val -> val[2][0] == '#'})
  let bufnum  = bufnr('%')

  for [lnum, lvl, line, hash, sfx] in s:util.ListHeaders() | call add(hashes, '#' . hash . sfx) | endfor
  for [lnum, column, hash] in s:util.ListIDAnchorLinks()
    let _h = '#' . hash
    if (index(hashes, _h) == -1) | call add(hashes, _h) | endif
  endfor

  for [lnum, column, hash] in frags
    let exists = 0

    for existing in hashes
      if (hash == existing) | let exists = 1 | break | endif
    endfor

    if (!exists) | call add(dead, {'bufnr': bufnum, 'lnum': lnum, 'col': column + 1, 'text': hash}) | endif
  endfor

  return [dead, len(frags)]
endfun

fun! s:util.hlAtCursor()
  return map(
      \ synstack(line('.'), col('.')),
      \ 'synIDattr(v:val, "name")'
      \ )
endfun

fun! s:util.hlAtCursorLine()
  return map(
      \ synstack(line('.'), 1),
      \ 'synIDattr(v:val, "name")'
      \ )
endfun

fun! s:util.isHlAtPos(hl, lnum, col)
  let pos_hl        = synIDattr(get(synstack(a:lnum, a:col), 0, ''), 'name')
  let possibilities = type(a:hl) == type([]) ? a:hl : [a:hl]
  " echom 'pos_hl('.string(possibilities).', '.a:lnum.', '.a:col.') "' . pos_hl . '"'
  for possibility in possibilities
    if pos_hl =~? '^' . possibility
      return 1
    endif
  endfor

  return 0
endfun

let s:wrap_hl_map = {
      \ 'mkdx-text-italic-n':      ['markdownItalic', 'markdownItalicDelimiter'],
      \ 'mkdx-text-bold-n':        ['markdownBold',   'markdownBoldDelimiter'],
      \ 'mkdx-text-strike-n':      ['htmlStrike', 'htmlEndTag', 'mkdxStrikeThrough', 'markdownStrikeThroughDelimiter'],
      \ 'mkdx-text-link-n':        ['markdownLinkText', 'markdownLinkTextDelimiter', 'markdownLinkDelimiter', 'markdownLink', 'mkdxLink'],
      \ 'mkdx-text-inline-code-n': ['mkdxInlineCode']
      \ }

fun! s:util.isAlreadyWrapped(id)
  let first_group = get(s:util.hlAtCursor(), 0, '')
  let candidates  = copy(get(s:wrap_hl_map, a:id, []))
  let found_match = get(filter(candidates, {_, candidate -> candidate ==? first_group}), 0, '')

  return !empty(found_match)
endfun

fun! s:util.hlBounds(type, ...)
  let single_line = get(a:, 0)
  let group       = get(s:wrap_hl_map, a:type, s:util.hlAtCursor())
  let slnum       = line('.')
  let scol        = col('.')
  let elnum       = slnum
  let ecol        = scol

  while 1
    if scol > 1
      if s:util.isHlAtPos(group, slnum, scol - 1)
        let scol -= 1
      else
        break
      endif
    else
      let prev_line_len = strlen(getline(slnum - 1))
      if !single_line && s:util.isHlAtPos(group, slnum - 1, prev_line_len)
        let slnum -= 1
        let scol   = prev_line_len
      else
        break
      endif
    endif
  endwhile

  let eline_len = strlen(getline(elnum))
  while s:util.isHlAtPos(group, elnum, ecol + 1)
    let ecol += 1
    if ecol >= eline_len
      let eline_len = strlen(getline(elnum + 1))
      if !single_line && s:util.isHlAtPos(group, elnum + 1, 1)
        let elnum += 1
        let ecol   = 1
      else
        break
      endif
    endif
  endwhile

  " echom 'hlBounds('.string(group).'):' [slnum, scol, elnum, ecol]
  return [slnum, scol, elnum, ecol]
endfun

fun! s:util.linkUrl(md_link)
  let open_paren = match(a:md_link, '](')
  let close_paren = match(a:md_link, ')', open_paren)

  return a:md_link[(open_paren + 2):(close_paren - 1)]
endfun

fun! s:util.unwrap(type, start, end)
  let [slnum, scol, elnum, ecol] = s:util.hlBounds(a:type)
  let sline   = getline(slnum)
  let end     = a:end
  let is_link = 0
  let start   = a:start

  if (end == ']()') " end of markdown link, may contain link
    let is_link = 1
    let end     = '](' . s:util.linkUrl(sline[scol:]) . ')'
    if (scol - 1 > -1 && sline[scol - 1] == '!')
      let start = '!' . start
      let scol -= 1
    endif
  endif

  " echom 'slnum:' slnum 'scol:' scol 'elnum:' elnum 'ecol:' ecol
  " return

  let soff = strlen(start)
  let spos = max([scol - 2, 0])
  let sa   = spos > 0 ? sline[0:spos] : ''
  let sb   = sline[(spos + (spos > 0) + soff):]

  call setline(slnum, sa . sb)

  let eline = getline(elnum)
  let eoff  = strlen(end)
  let epos  = max([ecol - 1, 0]) - (slnum == elnum ? soff : 0) - eoff
  let ea    = eline[0:epos]
  let eb    = eline[(epos + 1 + eoff):]

  call setline(elnum, ea . eb)

  if (is_link || slnum == line('.'))
    call cursor(slnum, max([spos + soff, 1]))
  elseif (elnum == line('.'))
    call cursor(elnum, max([epos, 1]))
  endif
endfun

fun! s:util.char_at_idx(str, idx)
  return matchstr(a:str, '\%'.a:idx.'c.')
endfun

fun! s:util.WrapSelectionOrWord(...)
  let mode    = get(a:000, 0, 'n')
  let start   = get(a:000, 1, '')
  let end     = get(a:000, 2, start)
  let l:count = max([get(a:000, 3, 1), 1])
  let type    = get(a:000, 4, '')
  let vcol    = col('.')
  let line    = getline('.')
  let llen    = strlen(line)
  let _r      = @z

  if (mode != 'n')
    let [slnum, scol] = getpos("'<")[1:2]
    let [elnum, ecol] = getpos("'>")[1:2]

    call cursor(elnum, ecol)
    exe 'normal! a' . end
    call cursor(slnum, scol)
    exe 'normal! i' . start
    call cursor(elnum, ecol)
  else
    if s:util.isAlreadyWrapped(type)
      call s:util.unwrap(type, start, end)
      return 'unwrap'
    else
      let boundary_re = '[ \t\r\n.,;:"?!%*()' . "'" . ']'
      let ch_before   = s:util.char_at_idx(line, vcol - 1)
      let ch_after    = s:util.char_at_idx(line, vcol + 1)
      let single_ch_w = (ch_before =~ boundary_re && ch_after =~ boundary_re)
      let go_bk       = ch_before =~ boundary_re ? '' : 'b'
      let motion      = single_ch_w ? 'l' : 'e'
      let col_before  = col('.')

      if !empty(go_bk)
        exe 'normal! ' . go_bk
        let col_before = col('.')
      endif

      exe 'normal! "z' . l:count . 'd' . motion

      let col_after = col('.')
      let @z = start . @z . end

      exe 'normal! "z' . ((vcol >= llen || col_before != col_after) ? 'p' : 'P')
      call cursor(line('.'), vcol + strlen(start))
    endif
  endif

  let zz = @z
  let @z = _r
  return zz
endfun

fun! s:util.ToggleMappingToKbd(str)
  let input = a:str
  let parts = split(input, '[-\+]')
  let state = { 'regular': 0, 'meta': 0, 'ctrl': 0, 'shift': 0 }
  let ilen  = len(parts) - 1
  let idx   = 0
  let out   = []

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

fun! s:util.ListHeaders()
  let headers = []
  let skip    = 0
  let hashes  = {}

  for lnum in range(1, line('$'))
    let header         = getline(lnum)
    let current_lnum   = lnum
    let skip           = match(header, '^\(\`\`\`\|\~\~\~\)') > -1 ? !skip : skip
    let is_frontmatter = match(
          \ get(map(synstack(lnum, 1), 'synIDattr(v:val, "name")'), 0, ''),
          \ 'mkdx\(YAML\|TOML\|JSON\)Header'
          \ ) > -1

    if (!skip && !is_frontmatter)
      let lvl = strlen(get(matchlist(header, '^' . g:mkdx#settings.tokens.header . '\{1,6}'), 0, ''))

      if (lvl == 0)
        let setext_ul = get(matchlist(header, '^\%(-\|=\)\+$'), 0, '')
        if !empty(setext_ul)
          let current_lnum -= 1
          let header        = getline(lnum - 1)
          if !empty(header)
            let lvl = setext_ul[0] == '=' ? 1 : 2
          endif
        endif
      endif

      if (lvl > 0)
        let hash         = s:util.transform(tolower(header), ['clean-header', 'header-to-hash'])
        let hashes[hash] = get(hashes, hash, -1) + 1

        call add(headers, [current_lnum, lvl, header, hash, (hashes[hash] > 0 ? '-' . hashes[hash] : '')])
      endif
    endif
  endfor

  return headers
endfun

fun! s:util.ToggleLineType(line, type)
  if (empty(a:line)) | return a:line | endif

  let li_re = '\([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\) '
  let li_st = '^ *' . li_re
  let repl  = ['', '', '']

  if (a:type == 'list')
    let repl = (match(a:line, li_st) > -1 ? ['^\( *\)' . li_re, '\1', ''] : ['^\( *\)', '\1' . g:mkdx#settings.tokens.list . ' ', ''])
    return substitute(a:line, repl[0], repl[1], repl[2])
  elseif (a:type == 'checkbox' || a:type == 'checklist')
    let repl = (match(a:line, '^ *\[.\]') > -1
                  \ ? ['^\( *\)\[.\] *', '\1', '']
                  \ : (match(a:line, li_st . '\[.\]') > -1
                        \ ? ['^\( *\)' . li_re . '\(\[.\]\) ', (a:type == 'checklist' ? '\1' : '\1\2 '), '']
                        \ : (match(a:line, li_st) > -1
                              \ ? ['^\( *\)' . li_re, '\1\2 [' . g:mkdx#settings.checkbox.initial_state . '] ', '']
                              \ : ['^\( *\)', '\1' . (a:type == 'checklist' ? g:mkdx#settings.tokens.list . ' ' : '') . '[' . g:mkdx#settings.checkbox.initial_state . '] ', ''])))
  elseif (a:type == 'off')
    let repl = ['^\( *\)\(' . li_re . ' \?\)\?\(\[.\]\)\? *', '\1', '']
  endif

  return substitute(a:line, repl[0], repl[1], repl[2])
endfun

" work around vim limitation of max char range size of 256 for chinese:
" http://vim.1045645.n5.nabble.com/how-to-match-all-Chinese-chars-td5708582.html
" solution by Christian Brabandt, modified by me for use in a single character
" group
function! s:util.split_into_ranges(start, end)
    let start = '0x'. a:start
    let end   = '0x'. a:end
    let patt  = ''
    while (end - start) > 256
        let temp = start + 256
        let patt .= printf('\u%X-\u%X', start, temp)
        let start = temp + 1
    endwhile

    if (end - start) > 0
        let patt .= printf('\u%X-\u%X', start, end)
    endif

    return patt
endfunction

let s:util.transformations = {
      \ 'trailing-space': [[' \+$', '', 'g']],
      \ 'escape-tags':    [['>', '\&gt;', 'g'], ['<', '\&lt;', 'g']],
      \ 'header-to-html': [['\\\@<!`\(.*\)\\\@<!`', '<code>\1</code>', 'g'],
      \                    ['<code>\(.*\)</code>', '\="<code>" . s:util.transform(submatch(1), ["escape-tags"]) . "</code>"', 'g'],
      \                    ['\\<\(.*\)>', '\&lt;\1\&gt;', 'g'], ['\\`\(.*\)\\`', '`\1`', 'g']],
      \ 'clean-header':   [['^[ {{tokens.header}}]\+\| \+$', '', 'g'], ['\[!\[\([^\]]\+\)\](\([^\)]\+\))\](\([^\)]\+\))', '', 'g'],
      \                    ['<a.*>\(.*\)</a>', '\1', 'g'], ['!\?\[\([^\]]\+\)]([^)]\+)', '\1', 'g']],
      \ 'header-to-hash': [['`<kbd>\(.*\)<\/kbd>`', 'kbd\1kbd', 'g'], ['<kbd>\(.*\)<\/kbd>', '\1', 'g'],
      \                    ['\%#=2[^0-9[:lower:]' . s:util.split_into_ranges('4e00', '9fbb') . '_\- ]\+', '', 'g'], ['[.,!@#$%^&*()=+"]', '', 'g'], [' ', '-', 'g']],
      \ 'toggle-quote':   [['^\(> \)\?', '\=(submatch(1) == "> " ? "" : "> ")', '']]
      \ }

fun! s:util.transform(line, to, ...)
  let [curr, transforms, Cb] = [a:line, (type(a:to) == s:STR ? [a:to] : deepcopy(a:to)), get(a:000, 0, s:util._)]

  for name in transforms
    for [rgx, rpl, flg] in get(s:util.transformations, name, [])
      if (name == 'clean-header') | let rgx = substitute(rgx, '{{tokens.header}}', g:mkdx#settings.tokens.header, '') | endif
      let curr = substitute(curr, rgx, rpl, flg)
    endfor
  endfor

  return Cb(curr)
endfun

fun! s:util.FormatTOCHeader(level, content, ...)
  let hsh = s:util.transform(tolower(a:content), ['clean-header', 'header-to-hash']) . get(a:000, 0, '')
  let hdr = s:util.transform(a:content, ['clean-header', 'trailing-space'], {str -> '[' . str . '](#' . hsh . ')'})

  return repeat(repeat(' ', s:sw()), a:level) . g:mkdx#settings.toc.list_token . ' ' . hdr
endfun

fun! s:util.HeaderToATag(header, ...)
  let hsh = s:util.transform(tolower(a:header), ['clean-header', 'header-to-hash']) . get(a:000, 0, '')

  return s:util.transform(a:header, ['clean-header', 'trailing-space', 'header-to-html'],
                        \ {str -> '<a href="#' . hsh . '">' . str . '</a>'})
endfun

fun! s:util.TaskItem(linenum)
  let line   = getline(a:linenum)
  let token  = get(matchlist(line, '\[\(.\)\]'), 1, '')
  let ident  = strlen(get(matchlist(line, '^>\?\( \{0,}\)'), 1, ''))
  let rem    = ident % s:sw()
  let ident -= g:mkdx#settings.enter.malformed ? (rem - (rem > s:sw() / 2 ? s:sw() : 0)) : 0

  return [token, (ident == 0 ? ident : ident / s:sw()), line]
endfun

fun! s:util.TasksToCheck(linenum)
  let lnum    = type(a:linenum) == type(0) ? a:linenum : line(a:linenum)
  let cnum    = col('.')
  let current = s:util.TaskItem(lnum)
  let startc  = lnum
  let items   = []

  while (prevnonblank(startc) == startc)
    let indent = s:util.TaskItem(startc)[1]
    if (indent == 0) | break | endif
    let startc -= 1
  endwhile

  if (current[1] == -1) | return | endif

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
  let parts = split(curr, '\.')
  let incr  = get(a:000, 0, 0)
  let incr  = incr < 0 ? incr : g:mkdx#settings.enter.increment

  if (len(parts) > a:depth) | let parts[a:depth] = str2nr(parts[a:depth]) + incr | endif
  return join(parts, '.') . ((match(curr, '\.$') > -1) ? '.' : '')
endfun

fun! s:util.UpdateTaskList(...)
  let linenum               = get(a:000, 0, '.')
  let force_status          = get(a:000, 1, -1)
  let [target, tasks]       = s:util.TasksToCheck(linenum)
  let [tlnum, ttk, tdpt, _] = target
  let tasksilen             = len(tasks) - 1
  let [incompl, compl]      = g:mkdx#settings.checkbox.toggles[-2:-1]
  let empty                 = g:mkdx#settings.checkbox.toggles[0]
  let tasks_lnums           = map(deepcopy(tasks), {idx, val -> get(val, 0, -1)})

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

        let completed = index(map(deepcopy(substats), {idx, val -> val != compl}), 1) == -1
        let unstarted = index(map(deepcopy(substats), {idx, val -> val != empty}), 1) == -1
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

fun! s:util.AlignString(str, align, length)
  let remaining = a:length - strwidth(a:str)

  if (remaining < 0) | return a:str[0:(a:length - 1)] | endif

  let center = !((a:align == 'right') || (a:align == 'left'))
  let lrem   = center ? float2nr(floor(remaining / 2.0)) : (a:align == 'left' ? 0 : remaining)
  let rrem   = center ? float2nr(ceil(remaining / 2.0))  : (remaining - lrem)

  return repeat(' ', lrem) . a:str . repeat(' ', rrem)
endfun

fun! s:util.TruncateString(str, len, ...)
  let ending = get(a:000, 0, '..')
  return strlen(a:str) >= a:len ? (a:str[0:(a:len - 1 - strlen(ending))] . ending) : a:str
endfun

fun! s:util.IsInsideLink()
  let col   = col('.')
  let start = col
  let line  = getline('.')
  let len   = strlen(line)
  let [mdlink, htmllink] = [0, 0]

  while (start > 0 && line[start - 1] != ']' && line[start - 1] != ' ') | let start -= 1 | endwhile
  let mdlink = line[(start - 1):start] == ']('

  if (!mdlink)
    let start = col
    while (start > 0 && line[start - 1] != '"') | let start -= 1 | endwhile
    let htmllink = line[(start - 7):(start - 3)] == 'href='
  endif

  return mdlink || htmllink
endfun

fun! s:util.Grep(...)
  let options  = extend({'pattern': '', 'done': s:util._, 'each': s:util._, 'file': expand('%'),
                       \ 'opts': [], 'pat_flag': '', 'sync': 0}, get(a:000, 0, {}))
  let base     = extend(filter([s:util.grepcmd, options.pat_flag, options.pattern, options.file],
                             \ {idx, arg -> !empty(arg)}),
                      \ options.opts)

  if (s:_is_nvim)
    let jid = jobstart(base, {'on_stdout': options.each, 'on_exit': options.done})
    if (options.sync) | call jobwait([jid]) | endif
    return jid
  elseif (s:_can_async)
    let job = job_start(base, {'pty': 0, 'out_cb': options.each})
    if (options.sync) | sleep 60m | endif
    return job
  endif
endfun

fun! s:util.HeadersAndAnchorsToHashCompletions(hashes, jid, stream, ...)
  let stream = type(a:stream) == s:LIST ? a:stream : [a:stream]
  for line in stream
    let item = s:util.IdentifyGrepLink(line)
    if (item.type == 'header')
      let hash           = s:util.transform(tolower(item.content), ['clean-header', 'header-to-hash'])
      let a:hashes[hash] = get(a:hashes, hash, -1) + 1
      let suffix         = a:hashes[hash] == 0 ? '' : ('-' . a:hashes[hash])
      let lvl            = '<h' . strlen(matchlist(item.content, '^#\{1,6}')[0]) . '>'
      call complete_add({'word': ('#' . hash . suffix), 'menu': ("\t| header | " . lvl . ' ' . s:util.TruncateString(s:util.transform(item.content, ['clean-header']), 35))})
    elseif (item.type == 'anchor')
      let line_part = substitute(getline(item.lnum), '`.*`', '', 'g')[(item._col - 1):]
      if (!empty(matchlist(line_part, '\%(name\|id\)="[^"]\+"')))
        call complete_add({'word': ('#' . item.content), 'menu': ("\t| anchor | <a>  " . s:util.TruncateString(s:util.transform(item.content, ['clean-header']), 40))})
      endif
    endif
  endfor
endfun

fun! s:util.IdentifyGrepLink(input)
  let input   = s:util.grepcmd == 'cgrep' ? a:input[1:-2] : a:input
  let parts   = matchlist(input, '^\(.*:\)\?\(\d\+\):\(\d\+\):\(.*\)$')[2:5]
  let lnum    = str2nr(get(parts, 0, 1))
  let cnum    = str2nr(get(parts, 1, 1))
  let cnum    = match(s:util.grepcmd, 'grep$') > -1 ? (cnum - (line2byte(lnum) - 2)) : cnum

  let matched = get(parts, 2, '')

  if (index(['pt', 'ag', 'ucg', 'ack'], s:util.grepcmd) > -1)
    let mtc     = matchlist(matched[(cnum - 1):], '\(id\|name\)="[^"]\+"\|\]([^)]\+)\|^#\{1,6}.*$')
    let tmp     = get(mtc, 0, '')
    let matched = empty(tmp) ? matched : ((index(['id', 'name'], get(mtc, 1, '')) > -1) ? tmp[:-1] : tmp)
  endif

  if match(matched, '^\%(-\|=\)\+$') > -1
    let slnum = lnum - 1
    let compl = []
    let prefx = matched[0] == '-' ? '##' : '#'
    while prevnonblank(slnum) == slnum
      let ln = getline(slnum)
      if empty(ln) | break | endif
      call add(compl, ln)
      if (slnum == 1) | break | endif
      let slnum = slnum - 1
    endwhile

    return { 'type': 'header', 'lnum': lnum - 1, '_col': cnum, 'col':  cnum, 'content': prefx . ' ' . join(reverse(compl), ' ') }
  endif

  if (matched[0]   == '#')    | return { 'type': 'header', 'lnum': lnum, '_col': cnum, 'col': cnum,     'content': matched }       | endif
  if (matched[0:1] == '](')   | return { 'type': 'link',   'lnum': lnum, '_col': cnum, 'col': cnum + 2, 'content': matched[2:-2] } | endif
  if (matched[0:1] == 'id')   | return { 'type': 'anchor', 'lnum': lnum, '_col': cnum, 'col': cnum + 4, 'content': matched[4:-2] } | endif
  if (matched[0:3] == 'href') | return { 'type': 'link',   'lnum': lnum, '_col': cnum, 'col': cnum + 6, 'content': matched[6:-2] } | endif
  if (matched[0:3] == 'name') | return { 'type': 'anchor', 'lnum': lnum, '_col': cnum, 'col': cnum + 6, 'content': matched[6:-2] } | endif

  return { 'type': 'unknown', 'lnum': lnum, '_col': cnum, 'col': cnum, 'content': matched }
endfun

fun! s:util.guardian(hash, key, value)
  let a:hash[a:key] = a:value.old
  if (type(a:value.new) == s:HASH)
    for [setting, val] in items(a:value.new)
      if (has_key(a:hash[a:key], setting))
        if (type(val) == s:HASH && type(a:hash[a:key][setting]) == s:HASH)
          let a:hash[a:key][setting] = mkdx#MergeSettings(a:hash[a:key][setting], val, {'modify': 1})
        else
          let a:hash[a:key][setting] = val
        endif
      endif
    endfor
  endif
endfun

fun! s:util.get_lines_starting_with(pat)
  return filter(map(range(1, line('$')),
                  \ {_, lnum -> (match(getline(lnum), a:pat) > -1) ? lnum : -1}),
              \ {_, lnum -> lnum > -1})
endfun

fun! s:util.ContextualComplete()
  let col   = col('.') - 2
  let start = col
  let line  = getline('.')

  while (start > 0 && line[start] != '#')
    let start -= 1
  endwhile

  if (line[start] != '#') | return [start, []] | endif

  if (!s:_testing && s:_can_vimgrep_fmt)
    let hashes = {}
    let opts = extend(get(s:util.grepopts, s:util.grepcmd, {}), {'pattern': '^(#{1,6} .*|(\-|=)+)$|(name|id)="[^"]+"', 'sync': 1})
    let opts['each'] = function(s:util.HeadersAndAnchorsToHashCompletions, [hashes])
    call s:util.Grep(opts)

    return [start, []]
  else
    return [start, extend(
          \ map(s:util.ListHeaders(), {idx, val -> {'word': ('#' . val[3] . val[4]), 'menu': ("\t| header | " . s:util.TruncateString(repeat(g:mkdx#settings.tokens.header, val[1]) . ' ' . s:util.transform(val[2], ['clean-header']), 40))}}),
          \ map(s:util.ListIDAnchorLinks(), {idx, val -> {'word': ('#' . val[2]), 'menu': ("\t| anchor | " . val[2])}}))]
  endif
endfun

fun! s:util.GetTOCPositionAndStyle(...)
  let opts   = extend({'text': g:mkdx#settings.toc.text,
                    \  'details': g:mkdx#settings.toc.details.enable,
                    \  'force': 0},
                    \ get(a:000, 0, {}))
  let startc = -1
  let found  = 0

  for lnum in range(1, line('$'))
    if (match(getline(lnum), '^' . g:mkdx#settings.tokens.header . '\{1,6} \+' . opts.text) > -1)
      let startc = lnum
      let found  = 1
      break
    endif
  endfor

  if (!found) | return [-1, -1, -1] | endif

  let endc = nextnonblank(startc + 1)
  while (nextnonblank(endc) == endc)
    let endc += 1
    let endl  = getline(endc)
    if (match(endl, '^[ \t]*#\{1,6}') > -1)
      break
    elseif (substitute(endl, '[ \t]\+', '', 'g') == '</details>')
      let endc += 1
      break
    endif
  endwhile

  if (nextnonblank(endc) == endc) | let endc -= 1 | endif
  return [startc, endc, ((!opts.force && opts.details > -1) ? (getline(nextnonblank(startc + 1)) =~ '^<details>')
                                                          \ : opts.details)]
endfun

""""" MAIN FUNCTIONALITY
fun! mkdx#guard_settings()
  if (exists('*dictwatcheradd'))
    call dictwatcheradd(g:, 'mkdx#settings', function(s:util.guardian))
    call s:util.add_dict_watchers(g:mkdx#settings)
  endif
endfun

fun! mkdx#MergeSettings(...)
  let a = get(a:000, 0, {})
  let b = get(a:000, 1, {})
  let o = get(a:000, 2, {'modify': 0})
  let c = o.modify ? a : {}

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

fun! mkdx#fold(lnum)
  if (!g:mkdx#settings.fold.enable) | return | endif
  if (a:lnum == 1 || s:util._update_folds)
    let s:util._folds        = []
    let s:util._update_folds = 0
    let s:util._fold_fence   = get(s:util, '_fold_fence', index(g:mkdx#settings.fold.components, 'fence') > -1)
    let s:util._fold_toc     = get(s:util, '_fold_toc',   index(g:mkdx#settings.fold.components, 'toc')   > -1)

    if (s:util._fold_fence)
      let code_blocks = s:util.get_lines_starting_with('^\~\~\~\|^\`\`\`')
      let len_cblocks = len(code_blocks) - 1
      let s:util._folds = map(range(0, (len_cblocks - (len_cblocks % 2)), 2),
                            \ {idx, val -> [code_blocks[val], code_blocks[val + 1]]})
    endif

    if (s:util._fold_toc)
      let toc_pos = s:util.GetTOCPositionAndStyle()[0:1]
      call insert(s:util._folds, [toc_pos[0] + 2, toc_pos[1] - (empty(getline(toc_pos[1])) ? 1 : 0)])
    endif
  endif

  for [sln, eln] in s:util._folds | if (a:lnum >= sln && a:lnum <= eln) | return '1' | endif | endfor
endfun

fun! mkdx#InsertCtrlPHandler()
  if (!g:mkdx#settings.links.fragment.complete) | return "\<C-P>" | endif
  return getline('.')[col('.') - 2] == '#' ? "\<C-X>\<C-U>" : "\<C-P>"
endfun

fun! mkdx#InsertCtrlNHandler()
  if (!g:mkdx#settings.links.fragment.complete) | return "\<C-N>" | endif
  return getline('.')[col('.') - 2] == '#' ? "\<C-X>\<C-U>" : "\<C-N>"
endfun

fun! mkdx#CompleteLink()
  if (g:mkdx#settings.links.fragment.complete && s:util.IsInsideLink())
    return "#\<C-X>\<C-U>"
  endif
  return '#'
endfun

fun! mkdx#Complete(findstart, base)
  if (a:findstart)
    let s:util._user_compl = s:util.ContextualComplete()
    return s:util._user_compl[0]
  else
    return s:util._user_compl[1]
endfun

fun! mkdx#JumpToHeader()
  let [lnum, cnum] = getpos('.')[1:2]
  let line = getline(lnum)
  let col  = 0
  let len  = strlen(line)
  let lnks = []
  let link = ''

  while (col < len)
    let rgx        = '\[[^\]]\+\](\([^)]\+\))\|<a .*\(name\|id\|href\)="\([^"]\+\)".*>.*</a>'
    let tcol       = match(line[col:], rgx)
    let matches    = matchlist(line[col:], rgx)
    let matchtext  = get(matches, 0, '')
    let is_anchor  = matchtext[0:1] == '<a'
    let addr       = get(matches, is_anchor ? 3 : 1, '')
    let matchlen   = strlen(matchtext)
    let col       += tcol + 1 + matchlen

    if (matchlen < 1) | break | endif
    if (is_anchor && index(['name', 'id'], get(matches, 2, '')) > -1) | return | endif
    if ((col - matchlen) <= cnum && (col - 1) >= cnum)
      let link = addr[(addr[0] == '#' ? 1 : 0):]
      break
    else
      call add(lnks, addr[(addr[0] == '#' ? 1 : 0):])
    endif
  endwhile

  if (empty(link) && !empty(lnks)) | let link = lnks[0] | endif
  if (empty(link)) | return | endif

  if (!s:_testing && s:_can_vimgrep_fmt)
    let hashes               = {}
    let s:util._header_found = 0
    let opts = extend(get(s:util.grepopts, s:util.grepcmd, {}),
                    \ {'pattern': '^#{1,6}.*$|(name|id)="[^"]+"',
                     \ 'each': function(s:util.JumpToHeader, [link, hashes])})

    call s:util.Grep(opts)
  else
    let headers = s:util.ListHeaders()

    for [lnum, column, hash] in s:util.ListIDAnchorLinks()
      if (index(headers, '#' . hash) == -1)
        call add(headers, [lnum, column, hash, ''])
      endif
    endfor

    for [lnum, colnum, header, hash, sfx] in headers
      if (link == (hash . sfx))
        if (g:mkdx#settings.links.fragment.jumplist)
          normal! m'0
        endif

        call cursor(lnum, 0)
        break
      endif
    endfor
  endif
endfun

fun! mkdx#QuickfixDeadLinks(...)
  let [dead, total] = s:util.FindDeadFragmentLinks()
  if (get(a:000, 0, 1))
    let dl = len(dead)

    call setqflist(dead)
    if (!s:_testing && g:mkdx#settings.links.external.enable && s:_can_async && s:_has_curl)
      call s:util.AsyncDeadExternalToQF(0, total)
    endif
    call s:util.log(dl . '/' . total . ' dead fragment link' . (dl == 1 ? '' : 's'), {'hl': (dl > 0 ? 'ErrorMsg' : 'MoreMsg')})
    if (dl > 0) | copen | else | cclose | endif
  else
    return dead
  endif
endfun

fun! mkdx#InsertFencedCodeBlock(...)
  let delim = repeat(!empty(g:mkdx#settings.tokens.fence) ? g:mkdx#settings.tokens.fence : get(a:000, 0, '`'), 3)
  return delim . '' . delim
endfun

fun! mkdx#ToggleToKbd(...)
  let m  = get(a:000, 0, 'n')
  let r  = @z
  let ln = getline('.')

  silent! exe 'normal! ' . (m == 'n' ? '"zdiW' : 'gv"zd')
  let oz = @z
  let ps = split(oz, ' ')
  let @z = empty(ps) ? @z : join(map(ps, {idx, val -> s:util.ToggleMappingToKbd(val)}), ' ')
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

fun! mkdx#MaybeRestoreVisual()
  if (g:mkdx#settings.restore_visual)
    normal! gv
  endif
endfun

fun! mkdx#WrapText(...)
  let m = get(a:000, 0, 'n')
  let w = get(a:000, 1, '')
  let x = get(a:000, 2, w)
  let a = get(a:000, 3, '')

  call s:util.WrapSelectionOrWord(m, w, x, v:count1, a)

  if (a != '')
    silent! call repeat#set("\<Plug>(" . a . ")")
  endif
endfun

fun! mkdx#WrapCutTextInCodeBlock() range
  let first_line = getpos("'<")[1]
  let last_line  = getpos("'>")[1]

  let lines = getline(first_line, last_line)
  let line_len = len(lines)
  let start_idx = 0
  let end_idx = line_len - 1
  let fence_style = strlen(g:mkdx#settings.tokens.fence) > 0 ? g:mkdx#settings.tokens.fence : '`'

  while (start_idx < line_len) && empty(lines[start_idx]) | let start_idx = start_idx + 1 | endwhile
  while (end_idx > 0) && empty(lines[end_idx]) | let end_idx = end_idx - 1 | endwhile

  call insert(lines, repeat(fence_style, 3), start_idx)
  call insert(lines, repeat(fence_style, 3), end_idx + 2)

  let old_fold = g:mkdx#settings.fold.enable
  let g:mkdx#settings.fold.enable = 0

  call deletebufline(bufname('%'), first_line, last_line)
  call append(first_line - 1, lines)

  " NOTE: why is this also set to 0 and not old_fold?
  let g:mkdx#settings.fold.enable = 0
endfun

fun! mkdx#WrapSelectionInCode() range
  if (mode() ==# 'V')
    return ":\<C-U>call mkdx#WrapCutTextInCodeBlock()\<Cr>"
  else
    return ":\<C-U>call mkdx#WrapText('v', '`', '`')\<Cr>"
  end
endfun

fun! mkdx#WrapStrike(...)
  let m = get(a:000, 0, 'n')
  let a = get(a:000, 1, '')
  let e = !empty(g:mkdx#settings.tokens.strike)
  let s = e ? g:mkdx#settings.tokens.strike : '<strike>'
  let z = e ? g:mkdx#settings.tokens.strike : '</strike>'

  call s:util.WrapSelectionOrWord(m, s, z, v:count1, a)

  if (a != '')
    silent! call repeat#set("\<Plug>(" . a . ")")
  endif
endfun

fun! mkdx#WrapLink(...) range
  let r = @z
  let m = get(a:000, 0, 'n')

  if (m == 'v')
    normal! gv"zy
    let img = empty(g:mkdx#settings.image_extension_pattern) ? 0 : (match(get(split(@z, '\.'), -1, ''), g:mkdx#settings.image_extension_pattern) > -1)
    call s:util.WrapSelectionOrWord(m, (img ? '!' : '') . '[', '](' . (img ? substitute(@z, '\n', '', 'g') : '') . ')')
    normal! f)
  else
    let result = s:util.WrapSelectionOrWord(m, '[', ']()', v:count1, 'mkdx-text-link-n')
    if (result ==? 'unwrap') | return | endif
    normal! f)
  end

  let @z = r

  silent! call repeat#set("\<Plug>(mkdx-wrap-link-" . m . ")")

  startinsert
endfun

fun! mkdx#ToggleList()
  call setline('.', s:util.ToggleLineType(getline('.'), 'list'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-list-n)")
endfun

fun! mkdx#ToggleChecklist()
  call setline('.', s:util.ToggleLineType(getline('.'), 'checklist'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-checklist-n)")
endfun

fun! mkdx#ToggleCheckboxTask()
  call setline('.', s:util.ToggleLineType(getline('.'), 'checkbox'))
  silent! call repeat#set("\<Plug>(mkdx-toggle-checkbox-n)")
endfun

fun! mkdx#ToggleQuoteSelection() range
  let mapped_lines = map(range(a:firstline, a:lastline), {_, lnum -> {'lnum': lnum, 'line': getline(lnum)}})
  let first_nonempty = -1
  let last_nonempty = -1

  for current in mapped_lines
    if !empty(current.line)
      let last_nonempty = current.lnum

      if first_nonempty == -1 | let first_nonempty = current.lnum | endif
    endif
  endfor

  for current in mapped_lines
    if current.lnum >= first_nonempty && current.lnum <= last_nonempty
      call setline(current.lnum, s:util.transform(current.line, ['toggle-quote']))
    endif
  endfor
endfun

fun! mkdx#ToggleQuote()
  let line = getline('.')
  if (!empty(line)) | call setline('.', s:util.transform(getline('.'), ['toggle-quote'])) | endif
  silent! call repeat#set("\<Plug>(mkdx-toggle-quote-n)")
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
  let next_nonblank = nextnonblank(a:firstline)
  let firstline     = getline(next_nonblank)
  let lines                                   = getline(a:firstline, a:lastline)
  let [col_maxlen, col_align, col_idx, parts] = [{}, {}, [], []]
  let [linecount, ld]                         = [range(0, len(lines) - 1), ' ' . g:mkdx#settings.table.divider . ' ']

  if (match(firstline, '[,\t]') > -1) " CSV data found, convert it to a table
    for column in s:util.CsvRowToList(firstline)
      call add(col_idx, column)
      if (index(map(deepcopy(g:mkdx#settings.table.align.left), {idx, val -> tolower(val)}), tolower(column)) > -1)
        let col_align[column] = 'left'
      elseif (index(map(deepcopy(g:mkdx#settings.table.align.right), {idx, val -> tolower(val)}), tolower(column)) > -1)
        let col_align[column] = 'right'
      elseif (index(map(deepcopy(g:mkdx#settings.table.align.center), {idx, val -> tolower(val)}), tolower(column)) > -1)
        let col_align[column] = 'center'
      else
        let col_align[column] = g:mkdx#settings.table.align.default
      endif
    endfor

    for idx in linecount
      let lines[idx] = s:util.CsvRowToList(lines[idx])

      for column in range(0, len(lines[idx]) - 1)
        let curr_word_max = strwidth(lines[idx][column])
        let last_col_max  = get(col_maxlen, column, 0)

        if (curr_word_max > last_col_max) | let col_maxlen[column] = curr_word_max | endif
      endfor
    endfor

    for linec in linecount
      if !empty(filter(copy(lines[linec]), {idx, val -> !empty(val)}))
        let tmp = map(range(0, len(col_idx) - 1), {idx, val -> get(lines[linec], idx, '')})
        call setline(a:firstline + linec,
          \ ld[1:2] . join(map(tmp, {key, val -> s:util.AlignString(val, get(col_align, get(col_idx, key, ''), 'center'), col_maxlen[key])}), ld) . ld[0:1])
      endif
    endfor

    for column in keys(col_maxlen)
      let align = tolower(get(col_align, get(col_idx, column, ''), g:mkdx#settings.table.align.default))
      let lhs   = index(['right', 'center'], align) ? ':' : g:mkdx#settings.table.header_divider
      let rhs   = index(['left',  'center'], align) ? ':' : g:mkdx#settings.table.header_divider

      call add(parts, lhs . repeat(g:mkdx#settings.table.header_divider, col_maxlen[column]) . rhs)
    endfor

    call s:util.InsertLine(g:mkdx#settings.table.divider . join(parts, g:mkdx#settings.table.divider) . g:mkdx#settings.table.divider, next_nonblank)
  elseif (match(firstline, '\%(|.*\)\{-2,}') > -1) " markdown table found, convert to CSV
    for idx in linecount
      let npos = a:firstline + idx

      if ((npos != next_nonblank + 1) && !empty(getline(npos)))
        let tmp = join(map(s:util.TableRowToList(lines[idx]),
                    \ {idx, col -> substitute(col, '^\s\+\|\s\+$', '', 'g')}), '","')

        call setline(npos, '"' . tmp . '"')
      endif
    endfor

    exe ((next_nonblank + 1) . "d_")
    call cursor(a:lastline - 1, 1)
  endif
endfun

fun! s:util.TableRowToList(line)
  return map(split(substitute(a:line, '^\s\+\|\s\+$', '', 'g'),
                 \ g:mkdx#settings.table.divider),
           \ {idx, ln -> substitute(ln, '"', '\\"', 'g')})
endfun

fun! mkdx#OHandler()
  if (!g:mkdx#settings.enter.o || !g:mkdx#settings.enter.enable)
    normal! o
  else
    let s:util._update_folds = g:mkdx#settings.fold.enable
    normal A
  endif
  startinsert!
endfun

fun! mkdx#ShiftOHandler()
  if (!g:mkdx#settings.enter.shifto || !g:mkdx#settings.enter.enable)
    normal! O
  else
    let s:util._update_folds = g:mkdx#settings.fold.enable
    let lnum = line('.')
    let line = getline(lnum)
    let len  = strlen(line)
    let qstr = ''
    let bld  = match(line, '^ *\*\*') > -1
    let quot = len > 0 ? line[0] == '>' : 0

    if (!bld && quot)
      let qstr = quot ? ('>' . get(matchlist(line, '^>\?\( *\)'), 1, '')) : ''
      let line = line[strlen(qstr):]
    endif

    let lin = bld ? -1 : get(matchlist(line, '^ *\([0-9.]\+\) '), 1, -1)
    let lis = bld ? -1 : get(matchlist(line, '^ *\([' . join(g:mkdx#settings.tokens.enter, '') . ']\) '), 1, -1)

    if (lin != -1)
      let esc  = lin == '*' ? '\*' : lin
      let suff = !empty(matchlist(line, '^ *' . esc . ' \[.\]'))
      exe 'normal! O' . qstr . lin . (suff ? ' [' . g:mkdx#settings.checkbox.initial_state . '] ' : ' ')
      call s:util.UpdateListNumbers(lnum, indent(lnum) / s:sw())
    elseif (lis != -1)
      let esc  = lis == '*' ? '\*' : lis
      let suff = !empty(matchlist(line, '^ *' . esc . ' \[.\]'))
      exe 'normal! O' . qstr . lis . (suff ? ' [' . g:mkdx#settings.checkbox.initial_state . '] ' : ' ')
    elseif (quot)
      let suff = !empty(matchlist(line, '^ *\[.\]'))
      exe 'normal! O' . qstr . (strlen(qstr) > 1 ? '' : ' ') . (suff ? '[' . g:mkdx#settings.checkbox.initial_state . '] ' : '')
    else
      normal! O
    endif
  endif

  startinsert!
endfun

fun! s:util.UpdateNumberedList()
  let lnum    = line('.')
  let num_pat = '^>\? *[0-9.]\+'
  let result  = []

  while (indent(lnum) > 0)
    let lnum -= 1
  endwhile

  if (match(getline(lnum), num_pat) > -1)
    let start_lnum  = lnum
    let end_lnum    = lnum
    let indent_size = s:sw()

    while (nextnonblank(start_lnum - 1) == start_lnum - 1)
      let start_lnum -= 1
    endwhile

    while (nextnonblank(end_lnum + 1) == end_lnum + 1)
      let end_lnum += 1
    endwhile

    for lnum in range(start_lnum, end_lnum)
      let raw_line = getline(lnum)
      let line     = substitute(raw_line, '^ *>', '', '')
      let depth    = len(get(matchlist(line, '^ *'), 0, '')) / indent_size
      let line     = substitute(line, '^ *', '', '')
      let prev     = get(result, -1)
      let has_prev = type(prev) == type({})
      let nums     = []

      if (match(line, num_pat) > -1)
        if (has_prev)
          let depth = min([depth, prev.depth + 1])
          let nums  = copy(prev.nums)

          if depth > prev.depth
            call add(nums, 1)
          elseif depth < prev.depth
            let nums = nums[0:depth]
            let nums[depth] += 1
          elseif depth == prev.depth
            let nums[depth] += 1
          endif
        else
          call add(nums, 1)
        endif

        call add(result, {
              \ 'quoted': match(raw_line, '^ *>') > -1,
              \ 'lnum': lnum,
              \ 'depth': depth,
              \ 'lines': [line],
              \ 'nums': nums
              \ })
      elseif (has_prev)
        call add(prev.lines, line)
      endif
    endfor
  endif

  for item in result
    let indent = repeat(' ', s:sw() * item.depth)
    let quote  = item.quoted ? '> ' : ''
    let lnum   = item.lnum
    let line   = substitute(item.lines[0], num_pat, join(item.nums, '.') . '.', '')

    call setline(lnum, quote . indent . line)

    if (len(item.lines) > 1)
      let sp_pat        = '^>\? *\(\([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\)\( \[.\]\)\? \|\[.\]\)'
      let item_syms     = get(matchlist(line, sp_pat), 1, '')
      let inline_indent = repeat(' ', len(item_syms))

      for inline_line in item.lines[1:]
        let lnum += 1
        call setline(lnum, quote . indent . inline_indent . inline_line)
      endfor
    endif
  endfor

  return result
endfun

fun! mkdx#IndentHandler(nested)
  let line  = getline('.')
  let quote = get(matchlist(line, '^ *>'), 0, '')

  if (!empty(quote))
    let line = substitute(line, quote, '', '')
    call setline('.', line)
  endif

  if a:nested
    normal! >>
  else
    normal! <<
  endif

  if (!empty(quote))
    let line = quote . getline('.')
    call setline('.', line)
  endif

  call s:util.UpdateNumberedList()
endfun

fun! mkdx#ShiftEnterHandler()
  if (!g:mkdx#settings.enter.shift) | return "\n" | endif
  let rem = matchlist(getline('.'), '^\(> *\)\? *\(\%([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\)\%( \+\[.\]\)\? *\|\[.\] *\)')
  return "\n" . get(rem, 1, '') . repeat(' ', strlen(get(rem, 2, '')))
endfun

fun! mkdx#EnterHandler()
  let line = getline('.')

  if (g:mkdx#settings.enter.enable && !empty(line))
    let lnum      = line('.')
    let cnum      = virtcol('.')
    let indent    = indent(lnum)
    let sp_pat    = '^>\? *\(\([0-9.]\+\|[' . join(g:mkdx#settings.tokens.enter, '') . ']\)\( \[.\]\)\? \|\[.\]\)'
    let after_inl = 0
    let inl_ind   = 0
    let tmp_lnum  = lnum - 1

    if (!(match(line, sp_pat) > -1) && ((strlen(line) > 0 ? line[0] : '') == '>' || indent > 0))
      while (indent(tmp_lnum) >= indent)
        if (tmp_lnum < 0) | break | else | let tmp_lnum -= 1 | endif
      endwhile

      if (tmp_lnum >= 0)
        let line      = getline(tmp_lnum)
        let inl_ind   = indent(tmp_lnum)
        let after_inl = 1
      endif
    endif

    let len     = strwidth(line)
    let results = matchlist(line, sp_pat)
    let t       = get(results, 2, '')
    let t       = t == '>' ? '' : t
    let tcb     = match(get(results, 1, ''), '^>\? *\[.\] *') > -1
    let cb      = match(get(results, 3, ''), ' *\[.\] *') > -1
    let remove  = empty(substitute(line, sp_pat . ' *', '', '')) || (strlen(substitute(getline(lnum), '\s', '', 'g')) == 0)
    let incr    = len(split(get(matchlist(line, '^>\? *\([0-9.]\+\) '), 1, ''), '\.')) - 1
    let upd_tl  = (cb || tcb) && g:mkdx#settings.checkbox.update_tree != 0
    let tl_prms = remove ? [line('.') - 1, -1] : ['.', 1]
    let inl_ind = repeat(' ', (after_inl > 0 ? inl_ind : 0))
    let qu_str  = (len > 0 ? line[0] == '>' : 0) ? ('>' . get(matchlist(line, '^>\?\( *\)'), 1, inl_ind)) : inl_ind
    let cursor_line_hl = s:util.hlAtCursorLine()

    if (index(cursor_line_hl, 'markdownCodeBlock' ) > -1 || index(cursor_line_hl, 'markdownCode') > -1)
      let remove = 0
      setlocal noautoindent
      return "\n" . repeat(' ', (indent / s:sw()) * s:sw())
    endif

    if (match(line, '^>\? *[0-9.]\+ ') > -1)
      call s:util.UpdateListNumbers((after_inl ? tmp_lnum : lnum), incr, (remove ? -1 : 1))
    endif

    if (remove && qu_str[0] == '>' && strlen(get(matchlist(getline(lnum), '\s\+$'), 0, '')) > 1)
      let remove = 0
      let qu_str = substitute(qu_str, '\s\+$', '', 'g') . ' '
    endif

    " autoindent gets reenabled outside of this function
    if (after_inl)                     | setlocal noautoindent                                                      | endif
    if (remove)                        | call setline('.', '')                                                      | endif
    if (upd_tl)                        | call call(s:util.UpdateTaskList, tl_prms)                                  | endif
    if (remove)                        | return ''                                                                  | endif
    if ((match(line, '^ *\*\*') > -1)) | return "\n" . qu_str                                                       | endif
    if (tcb)                           | return "\n" . qu_str . '[' . g:mkdx#settings.checkbox.initial_state . '] ' | endif

    let result = ["\n",
      \ qu_str,
      \ (match(t, '[0-9.]\+') > -1 ? s:util.NextListNumber(t, incr > -1 ? incr : 0) : t),
      \ (cb ? ' [' . g:mkdx#settings.checkbox.initial_state . '] ' : (!empty(t) ? ' ' : ''))]

    return join(result, '')
  endif

  return "\n"
endfun

fun! mkdx#BeforeWrite()
  if (g:mkdx#settings.toc.update_on_write != 0)
    if ((localtime() - get(s:util, '__before_write_time', 2)) >= 2)
      let s:util.__before_write_time = localtime()
      if (s:util.GetTOCPositionAndStyle()[0] > -1)
        call mkdx#UpdateTOC()
      elseif (g:mkdx#settings.toc.position > 0)
        call mkdx#GenerateTOC()
      endif
    endif
  end
endfun

fun! mkdx#GenerateOrUpdateTOC()
  silent! call repeat#set("\<Plug>(mkdx-gen-or-upd-toc)")

  for lnum in range(1, line('$'))
    if (match(getline(lnum), '^' . g:mkdx#settings.tokens.header . '\{1,6} \+' . g:mkdx#settings.toc.text) > -1)
      call mkdx#UpdateTOC()
      return
    endif
  endfor

  call mkdx#GenerateTOC()
endfun

fun! mkdx#UpdateTOC(...)
  let opts                    = extend({'text': g:mkdx#settings.toc.text, 'details': g:mkdx#settings.toc.details.enable, 'force': 0}, get(a:000, 0, {}))
  let curpos                  = getpos('.')
  let [startc, endc, details] = s:util.GetTOCPositionAndStyle(opts)

  silent! exe 'normal! :' . startc . ',' . endc . 'd _'

  let inslen = mkdx#GenerateTOC(1, details)

  call cursor(curpos[1] - (curpos[1] >= endc ? endc - startc - inslen + 1 : 0), curpos[2])
endfun

fun! mkdx#QuickfixHeaders(...)
  let open_qf  = get(a:000, 0, 1)
  let curr_buf = bufnr('%')
  if (open_qf && !s:_testing && s:_can_vimgrep_fmt)
    call setqflist([])
    call s:util.Grep(extend(get(s:util.grepopts, s:util.grepcmd, {}),
                         \ {'pattern': '^(#{1,6} .*|(\-|=)+)$',
                           \ 'each': function(s:util.AddHeaderToQuickfix, [curr_buf]),
                           \ 'done': function(s:util.EchoQuickfixCount, ['header'])}))
  else
    let qflist = map(s:util.ListHeaders(),
          \ {k, v -> {'bufnr': curr_buf, 'lnum': v[0], 'level': v[1],
                    \ 'text': repeat(g:mkdx#settings.tokens.header, v[1]) . ' ' . s:util.transform(v[2], ['clean-header']) }})

    if (open_qf)
      call setqflist(qflist)
      if (s:util.EchoQuickfixCount('header')) | copen | else | cclose | endif
    else
      return qflist
    endif
  end
endfun

fun! mkdx#GenerateTOC(...)
  let s:util._update_folds = 1
  let contents   = []
  let cpos       = getpos('.')
  let header     = ''
  let prevlvl    = 1
  let headers    = {}
  let src        = s:util.ListHeaders()
  let srclen     = len(src)
  let curr       = 0
  let toc_pos    = g:mkdx#settings.toc.position - 1
  let after_info = get(src, toc_pos, -1)
  let after_info = toc_pos > 0 && type(after_info) != type([]) ? get(src, -1, -1) : after_info
  let after_pos  = toc_pos >= 0 && type(after_info) == type([])
  let detail_opt = get(a:000, 1, -1)
  let do_details = detail_opt > -1 ? detail_opt : g:mkdx#settings.toc.details.enable
  let LI = {prevlvl, spc, hdr, prfx, ending -> add(contents, (do_details ? (spc . '<li>' . s:util.HeaderToATag(hdr, prfx) . ending)
                                                                       \ : s:util.FormatTOCHeader(prevlvl - 1, hdr, prfx)))}

  if (do_details)
    let summary_text = (empty(g:mkdx#settings.toc.details.summary)
                         \ ? g:mkdx#settings.toc.text
                         \ : substitute(g:mkdx#settings.toc.details.summary, '{{toc.text}}', g:mkdx#settings.toc.text, 'g'))

    call extend(contents, ['<details>', '<summary>' . summary_text . '</summary>', '<ul>'])
  endif

  let children_at_level = []
  let child_lvl         = g:mkdx#settings.toc.details.nesting_level + 1

  if (child_lvl == 0) | let child_lvl = 10 | endif

  for [lnum, lvl, line, hsh, sfx] in src
    let curr         += 1
    let nextlvl       = get(src, curr, [0, -1])[1]
    let headers[hsh]  = get(headers, hsh, -1) + 1
    let spc           = repeat(repeat(' ', s:sw()), lvl)
    let children      = 0

    if (lvl >= child_lvl && nextlvl - lvl == 1)
      let next_c_lvl = nextlvl
      let next_c_idx = curr
      while (next_c_lvl != -1 && next_c_lvl >= nextlvl)
        let next_c_lvl  = get(src, next_c_idx, [0, -1])[1]
        let next_c_idx += 1
        if (next_c_lvl == nextlvl)
          let children += 1
        endif
      endwhile
    endif

    let inner_details_open = do_details && children >= g:mkdx#settings.toc.details.child_count && (nextlvl >= child_lvl) && (lvl == nextlvl - 1)
          \ ? '<details><summary>' . substitute(g:mkdx#settings.toc.details.child_summary, '{{count}}', children, 'g') . '</summary>'
          \ : ''
    let ending_tag = (nextlvl > lvl) ? inner_details_open . '<ul>' : '</li>'

    if !empty(inner_details_open)
      call insert(children_at_level, lvl)
    endif

    if (do_details && lvl < prevlvl)
      let prevl = prevlvl
      let close = ''

      while (lvl < prevl && prevl > 0)
        let prevl -= 1
        if (get(children_at_level, 0, -1) == prevl)
          call remove(children_at_level, 0)
          let close .= '</ul></details></li>'
        else
          let close .= '</ul></li>'
        endif
      endwhile

      call add(contents, repeat(' ', s:sw() * lvl) . close)
    endif

    if (empty(header) && (lnum >= cpos[1] || (curr > toc_pos && after_pos)))
      let header       = repeat(g:mkdx#settings.tokens.header, prevlvl) . ' ' . g:mkdx#settings.toc.text
      let csh          = s:util.transform(tolower(header), ['clean-header', 'header-to-hash'])
      let headers[csh] = get(headers, csh, -1) + 1
      let contents     = extend([header, ''], contents)
      call LI(prevlvl, spc, header, ((headers[csh] > 0) ? '-' . headers[csh] : ''), '</li>')
    endif

    call LI(lvl, spc, line, sfx, ending_tag)

    if (empty(header) && curr == srclen)
      let header       = repeat(g:mkdx#settings.tokens.header, prevlvl) . ' ' . g:mkdx#settings.toc.text
      let csh          = s:util.transform(tolower(header), ['clean-header', 'header-to-hash'])
      let headers[csh] = get(headers, csh, -1) + 1
      let contents     = extend([header, ''], contents)
      call LI(prevlvl, spc, header, ((headers[csh] > 0) ? '-' . headers[csh] : ''), '</li>')
    endif

    let prevlvl = lvl
  endfor

  if (do_details && (prevlvl - 1) > 0)
    let prevl = prevlvl - 1
    let close = ''

    while (prevl > 0)
      if (get(children_at_level, 0, -1) == prevl)
        call remove(children_at_level, 0)
        let close .= '</ul></details></li>'
      else
        let close .= '</ul></li>'
      endif
      let prevl -= 1
    endwhile

    call add(contents, repeat(' ', s:sw() * (lvl - 1)) . close)
  endif

  if (do_details) | call extend(contents, ['</ul>', '</details>']) | endif

  let c = ((!get(a:000, 0, 0) && after_pos) ? after_info[0] : cpos[1]) -
        \ ((after_info[0] == 1 && toc_pos > 0) ? -1 : 1) +
        \ (toc_pos == srclen ? 1 : 0)

  if (c > 0 && nextnonblank(c) == c)     | call insert(contents, '') | endif
  if (after_pos || !empty(getline('.'))) | call add(contents, '')    | endif

  call append(c, contents)
  call setpos('.', cpos)
  return len(contents)
endfun

fun! mkdx#in_rtp(relative_path)
  for rtp in split(&rtp, ',')
    if filereadable(join([substitute(rtp, '/\+$', '', 'g'), a:relative_path], '/'))
      return 1
    endif
  endfor

  return 0
endfun

" credits: https://stackoverflow.com/a/6271254/2224331 answer by xolox.
function! s:util.get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

fun! mkdx#gf_visual(...)
  let mode = get(a:000, 0, 'f')
  let do_ext = !g:mkdx#settings.gf_on_steroids && mode ==? 'x'
  let do_int = !g:mkdx#settings.gf_on_steroids && mode ==? 'f'

  let destination = substitute(s:util.get_visual_selection(), "\n", '', 'g')
  let is_img      = match(get(split(destination, '\.'), -1, ''), g:mkdx#settings.image_extension_pattern) > -1
  let mime        = s:util.getMimeType(destination)
  let is_plain    = mime =~? '^text' || mime =~? '^inode/x-empty'

  if !do_int && (do_ext || destination =~? '^http' || is_img || !is_plain)
    let cmd = executable('open') ? 'open' : (executable('xdg-open') ? 'xdg-open' : '')
    if (!empty(cmd))
      silent! exec '!' . cmd . ' ' . shellescape(substitute(destination, '#', '\\#', 'g')) . '>/dev/null'
      redraw!
    endif
  elseif (filereadable(destination))
    exe 'edit' destination
  endif
endfun

fun! mkdx#gf(...)
  let mode = get(a:000, 0, 'f')
  let cpos = getpos('.')
  let do_ext = !g:mkdx#settings.gf_on_steroids && mode ==? 'x'
  let do_int = !g:mkdx#settings.gf_on_steroids && mode ==? 'f'

  try
    if s:util.isAlreadyWrapped('mkdx-text-link-n')
      let [slnum, scol, elnum, ecol] = s:util.hlBounds('mkdx-text-link-n', 1)
      let line        = getline(slnum)
      let subpart     = line[(scol - 1):(ecol - 1)]
      let destination = match(subpart, '](') > -1 ? s:util.linkUrl(line[scol:]) : subpart
      let is_img      = match(get(split(destination, '\.'), -1, ''), g:mkdx#settings.image_extension_pattern) > -1
      let mime        = s:util.getMimeType(destination)
      let is_plain    = mime =~? '^text' || mime =~? '^inode/x-empty'

      if !do_int && (do_ext || destination =~? '^http' || is_img || !is_plain)
        let cmd = executable('open') ? 'open' : (executable('xdg-open') ? 'xdg-open' : '')
        if (!empty(cmd))
          silent! exec '!' . cmd . ' ' . shellescape(substitute(destination, '#', '\\#', 'g')) . '>/dev/null'
          redraw!
        endif
      else
        if get(s:util.hlAtCursor(), 0, '') ==? 'mkdxLink'
          normal! gf
        elseif line[col('.') - 1] == ')'
          normal! hgf
        else
          normal! t)gf
        end
      endif
    else
      normal! gf
    endif
  catch
    call setpos('.', cpos)
    echohl Error
    echom join(split(v:exception, ':')[1:], ':')
    echohl None
  endtry
endfun

fun! mkdx#JumpToSection(to) abort
  let cursor_lnum = line('.')
  let headers = s:util.ListHeaders()
  let jumps = v:count1

  if a:to ==# 'next'
    for header in headers
      let header_lnum = header[0]
      let jumps -= header_lnum > cursor_lnum ? 1 : 0

      if jumps <= 0
        call cursor(header_lnum, 1)
        break
      endif
    endfor
  else
    for header in reverse(headers)
      let header_lnum = header[0]
      let jumps -= header_lnum < cursor_lnum ? 1 : 0

      if jumps <= 0
        call cursor(header_lnum, 1)
        break
      endif
    endfor
  endif
endfun

let g:mkdx#util = s:util

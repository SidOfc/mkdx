if exists('b:did_ftplugin_mkdx') | finish | else | let b:did_ftplugin_mkdx = 1 | endif

" backwards compat <= 1.8.0
noremap         <silent> <Plug>(mkdx-checkbox-next)      :call      mkdx#ToggleCheckboxState()<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-prev)      :call      mkdx#ToggleCheckboxState(1)<Cr>
noremap         <silent> <Plug>(mkdx-toggle-quote)       :call      mkdx#ToggleQuote()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checkbox)    :call      mkdx#ToggleCheckboxTask()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checklist)   :call      mkdx#ToggleChecklist()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-list)        :call      mkdx#ToggleList()<Cr>

noremap         <silent> <Plug>(mkdx-checkbox-next-n)    :call      mkdx#ToggleCheckboxState()<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-prev-n)    :call      mkdx#ToggleCheckboxState(1)<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-next-v)    :call      mkdx#ToggleCheckboxState()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-checkbox-prev-v)    :call      mkdx#ToggleCheckboxState(1)<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-quote-n)     :call      mkdx#ToggleQuote()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-quote-v)     :call      mkdx#ToggleQuoteSelection()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checkbox-n)  :call      mkdx#ToggleCheckboxTask()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checkbox-v)  :call      mkdx#ToggleCheckboxTask()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checklist-n) :call      mkdx#ToggleChecklist()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-checklist-v) :call      mkdx#ToggleChecklist()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-list-n)      :call      mkdx#ToggleList()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-list-v)      :call      mkdx#ToggleList()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-demote-header)      :<C-U>call mkdx#ToggleHeader()<Cr>
noremap         <silent> <Plug>(mkdx-promote-header)     :<C-U>call mkdx#ToggleHeader(1)<Cr>
noremap         <silent> <Plug>(mkdx-wrap-link-n)        :<C-U>call mkdx#WrapLink()<Cr>
noremap         <silent> <Plug>(mkdx-wrap-link-v)        :call      mkdx#WrapLink('v')<Cr>
noremap         <silent> <Plug>(mkdx-jump-to-header)     :call      mkdx#JumpToHeader()<Cr>
noremap         <silent> <Plug>(mkdx-tableize)           :call      mkdx#Tableize()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
noremap         <silent> <Plug>(mkdx-quickfix-links)     :call      mkdx#QuickfixDeadLinks()<Cr>
noremap         <silent> <Plug>(mkdx-quickfix-toc)       :call      mkdx#QuickfixHeaders()<Cr>
noremap         <silent> <Plug>(mkdx-generate-toc)       :call      mkdx#GenerateTOC()<Cr>
noremap         <silent> <Plug>(mkdx-update-toc)         :call      mkdx#UpdateTOC()<Cr>
noremap         <silent> <Plug>(mkdx-gen-or-upd-toc)     :call      mkdx#GenerateOrUpdateTOC()<Cr>
noremap         <silent> <Plug>(mkdx-text-italic-n)      :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic, 'mkdx-text-italic-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-bold-n)        :<C-U>call mkdx#WrapText('n', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold, 'mkdx-text-bold-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-inline-code-n) :<C-U>call mkdx#WrapText('n', '`', '`', 'mkdx-text-inline-code-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-strike-n)      :<C-U>call mkdx#WrapStrike('n', 'mkdx-text-strike-n')<Cr>
noremap         <silent> <Plug>(mkdx-text-italic-v)      :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic)<Cr>
noremap         <silent> <Plug>(mkdx-text-bold-v)        :<C-U>call mkdx#WrapText('v', g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold)<Cr>
noremap  <expr> <silent> <Plug>(mkdx-text-inline-code-v) mkdx#WrapSelectionInCode()
noremap         <silent> <Plug>(mkdx-text-strike-v)      :<C-U>call mkdx#WrapStrike('v')<Cr>
noremap         <silent> <Plug>(mkdx-toggle-to-kbd-n)    :call      mkdx#ToggleToKbd()<Cr>
noremap         <silent> <Plug>(mkdx-toggle-to-kbd-v)    :<C-U>call mkdx#ToggleToKbd('v')<Cr>
noremap         <silent> <Plug>(mkdx-shift-o)            :<C-U>call mkdx#ShiftOHandler()<Cr>
noremap         <silent> <Plug>(mkdx-o)                  :<C-U>call mkdx#OHandler()<Cr>
noremap         <silent> <Plug>(mkdx-gf)                 :<C-U>call mkdx#gf('f')<Cr>
noremap         <silent> <Plug>(mkdx-gx)                 :<C-U>call mkdx#gf('x')<Cr>
noremap         <silent> <Plug>(mkdx-gf-visual)          :<C-U>call mkdx#gf_visual('f')<Cr>
noremap         <silent> <Plug>(mkdx-gx-visual)          :<C-U>call mkdx#gf_visual('x')<Cr>
inoremap        <silent> <Plug>(mkdx-enter)              <C-R>=mkdx#EnterHandler()<Cr>:setlocal autoindent<Cr>
inoremap        <silent> <Plug>(mkdx-shift-enter)        <C-R>=mkdx#ShiftEnterHandler()<Cr>
inoremap        <silent> <Plug>(mkdx-insert-kbd)         <kbd></kbd>F<
inoremap        <silent> <Plug>(mkdx-fence-tilde)        <C-R>=mkdx#InsertFencedCodeBlock('~')<Cr>kA
inoremap        <silent> <Plug>(mkdx-fence-backtick)     <C-R>=mkdx#InsertFencedCodeBlock('`')<Cr>kA
inoremap        <silent> <Plug>(mkdx-ctrl-n-compl)       <C-R>=mkdx#InsertCtrlNHandler()<Cr>
inoremap        <silent> <Plug>(mkdx-ctrl-p-compl)       <C-R>=mkdx#InsertCtrlPHandler()<Cr>
inoremap <expr> <silent> <Plug>(mkdx-link-compl)         mkdx#CompleteLink()
noremap         <silent> <Plug>(mkdx-indent)             :call mkdx#IndentHandler(1)<Cr>
noremap         <silent> <Plug>(mkdx-unindent)           :call mkdx#IndentHandler(0)<Cr>
noremap         <Plug>(mkdx-next-section)                :call mkdx#JumpToSection('next')<Cr>
noremap         <Plug>(mkdx-prev-section)                :call mkdx#JumpToSection('prev')<Cr>

if (g:mkdx#settings.links.fragment.complete)
  setlocal completefunc=mkdx#Complete
  setlocal pumheight=15
  setlocal iskeyword+=\-
  setlocal completeopt+=noinsert,menuone
endif

if (get(g:, 'markdown_folding', 0))
  let g:mkdx#settings.fold.enable = 0
endif

if (g:mkdx#settings.fold.enable)
  setlocal foldmethod=expr
  setlocal foldexpr=mkdx#fold(v:lnum)
endif

if (has('autocmd'))
  augroup MkdxAutocommands
    au!
    au BufWritePre *.md silent! call mkdx#BeforeWrite()
  augroup END
endif

if g:mkdx#settings.map.enable == 1
  let s:gv       = g:mkdx#settings.restore_visual == 1 ? 'gv' : ''
  let s:bindings = [
        \ ['Toggle\ checkbox\ backward',      1, 'n', '-',      '<Plug>(mkdx-checkbox-prev-n)',         ':call mkdx#ToggleCheckboxState(1)<cr>'],
        \ ['Toggle\ checkbox\ forward',       1, 'n', '=',      '<Plug>(mkdx-checkbox-next-n)',         ':call mkdx#ToggleCheckboxState()<cr>'],
        \ ['Toggle\ checkbox\ forward',       1, 'v', '-',      '<Plug>(mkdx-checkbox-prev-v)',         ':call mkdx#ToggleCheckboxState()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ checkbox\ backward',      1, 'v', '=',      '<Plug>(mkdx-checkbox-next-v)',         ':call mkdx#ToggleCheckboxState(1)<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Promote\ header',                 1, 'n', '[',      '<Plug>(mkdx-promote-header)',          ':<C-U>call mkdx#ToggleHeader(1)<cr>'],
        \ ['Demote\ header',                  1, 'n', ']',      '<Plug>(mkdx-demote-header)',           ':<C-U>call mkdx#ToggleHeader()<cr>'],
        \ ['Toggle\ quote',                   1, 'n', "'",      '<Plug>(mkdx-toggle-quote-n)',          ':call mkdx#ToggleQuote()<cr>'],
        \ ['Toggle\ quote',                   1, 'v', "'",      '<Plug>(mkdx-toggle-quote-v)',          ':call mkdx#ToggleQuote()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ checkbox',                1, 'n', "t",      '<Plug>(mkdx-toggle-checkbox-n)',       ':call mkdx#ToggleCheckboxTask()<cr>'],
        \ ['Toggle\ checkbox',                1, 'v', "t",      '<Plug>(mkdx-toggle-checkbox-v)',       ':call mkdx#ToggleCheckboxTask()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ checklist',               1, 'n', "lt",     '<Plug>(mkdx-toggle-checklist-n)',      ':call mkdx#ToggleChecklist()<cr>'],
        \ ['Toggle\ checklist',               1, 'v', "lt",     '<Plug>(mkdx-toggle-checklist-v)',      ':call mkdx#ToggleChecklist()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Toggle\ list',                    1, 'n', "ll",     '<Plug>(mkdx-toggle-list-n)',           ':call mkdx#ToggleList()<cr>'],
        \ ['Toggle\ list',                    1, 'v', "ll",     '<Plug>(mkdx-toggle-list-v)',           ':call mkdx#ToggleList()<cr>:call mkdx#MaybeRestoreVisual()<cr>'],
        \ ['Wrap\ link',                      1, 'n', 'ln',     '<Plug>(mkdx-wrap-link-n)',             ':<C-U>call mkdx#WrapLink()<cr>'],
        \ ['Wrap\ link',                      1, 'v', 'ln',     '<Plug>(mkdx-wrap-link-v)',             ':<C-U>call mkdx#WrapLink("v")<cr>'],
        \ ['Italic',                          1, 'n', '/',      '<Plug>(mkdx-text-italic-n)',           ':<C-U>call mkdx#WrapText("n", g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic, "mkdx-text-italic-n")<Cr>'],
        \ ['Italic',                          1, 'v', '/',      '<Plug>(mkdx-text-italic-v)',           ':<C-U>call mkdx#WrapText("v", g:mkdx#settings.tokens.italic, g:mkdx#settings.tokens.italic)<Cr>'],
        \ ['Bold',                            1, 'n', 'b',      '<Plug>(mkdx-text-bold-n)',             ':<C-U>call mkdx#WrapText("n", g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold, "mkdx-text-bold-n")<Cr>'],
        \ ['Bold',                            1, 'v', 'b',      '<Plug>(mkdx-text-bold-v)',             ':<C-U>call mkdx#WrapText("v", g:mkdx#settings.tokens.bold, g:mkdx#settings.tokens.bold)<Cr>'],
        \ ['Inline\ code',                    1, 'n', '`',      '<Plug>(mkdx-text-inline-code-n)',      ':<C-U>call mkdx#WrapText("n", "`", "`", "mkdx-text-inline-code-n")<cr>'],
        \ ['Inline\ code',                    1, 'v', '`',      '<Plug>(mkdx-text-inline-code-v)',      ':call      mkdx#WrapSelectionInCode()<cr>:call mkdx#MaybeRestoreVisual()<Cr>'],
        \ ['Strike\ through',                 1, 'n', 's',      '<Plug>(mkdx-text-strike-n)',           ':<C-U>call mkdx#WrapText("n", "<strike>", "</strike>", "mkdx-text-strike-n")<cr>'],
        \ ['Strike\ through',                 1, 'v', 's',      '<Plug>(mkdx-text-strike-v)',           ':<C-U>call mkdx#WrapText("v", "<strike>", "</strike>")<cr>'],
        \ ['Convert\ to\ table',              1, 'v', ',',      '<Plug>(mkdx-tableize)',                ':call mkdx#Tableize()<cr>:call mkdx#MaybeRestoreVisual()<Cr>'],
        \ ['Generate\ /\ Update\ TOC',        1, 'n', 'i',      '<Plug>(mkdx-gen-or-upd-toc)',          ':call mkdx#GenerateOrUpdateTOC()<cr>'],
        \ ['Open\ TOC\ in\ quickfix',         1, 'n', 'I',      '<Plug>(mkdx-quickfix-toc)',            ':call mkdx#QuickfixHeaders()<cr>'],
        \ ['Open\ dead\ links\ in\ quickfix', 1, 'n', 'L',      '<Plug>(mkdx-quickfix-links)',          ':call mkdx#QuickfixDeadLinks()<cr>'],
        \ ['Jump\ to\ header',                1, 'n', 'j',      '<Plug>(mkdx-jump-to-header)',          ':call mkdx#JumpToHeader()<cr>'],
        \ ['Toggle\ to\ kbd\ tag',            1, 'n', 'k',      '<Plug>(mkdx-toggle-to-kbd-n)',         ':call mkdx#ToggleToKbd()<cr>'],
        \ ['Toggle\ to\ kbd\ tag',            1, 'v', 'k',      '<Plug>(mkdx-toggle-to-kbd-v)',         ':call mkdx#ToggleToKbd("v")<cr>'],
        \ ['Insert\ kbd\ tag',                0, 'i', '<<tab>', '<Plug>(mkdx-insert-kbd)',              '<kbd></kbd>2hcit'],
        \ ['Backtick\ fenced\ code\ block',   0, 'i', '```',    '<Plug>(mkdx-fence-backtick)',          '<C-R>=mkdx#FencedCodeBlock("`")<Cr>kA'],
        \ ['tilde\ fenced\ code\ block',      0, 'i', '~~~',    '<Plug>(mkdx-fence-tilde)',             '<C-R>=mkdx#FencedCodeBlock("~")<Cr>kA'],
        \ ['Jump to file / open URL',         0, 'n', 'gf',     '<Plug>(mkdx-gf)',                      ':<C-U>call mkdx#gf("f")<Cr>'],
        \ ['Jump to file / open URL',         0, 'n', 'gx',     '<Plug>(mkdx-gx)',                      ':<C-U>call mkdx#gf("x")<Cr>'],
        \ ['Jump to file / open URL',         0, 'v', 'gf',     '<Plug>(mkdx-gf-visual)',               ':<C-U>call mkdx#gf_visual("f")<Cr>'],
        \ ['Jump to file / open URL',         0, 'v', 'gx',     '<Plug>(mkdx-gx-visual)',               ':<C-U>call mkdx#gf_visual("x")<Cr>'],
        \ ['Jump to next section',            0, 'n', ']]',     '<Plug>(mkdx-next-section)',            ':call mkdx#JumpToSection("next")<Cr>'],
        \ ['Jump to prev section',            0, 'n', '[[',     '<Plug>(mkdx-prev-section)',            ':call mkdx#JumpToSection("prev")<Cr>'],
        \ ]

  if (!hasmapto('<Plug>(mkdx-gf)', 'n'))
    nmap <buffer><silent> gf <Plug>(mkdx-gf)
  endif
  if (!hasmapto('<Plug>(mkdx-gx)', 'n'))
    nmap <buffer><silent> gx <Plug>(mkdx-gx)
  endif

  if (g:mkdx#settings.links.fragment.complete)
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

  if (g:mkdx#settings.tab.enable)
    if (!hasmapto('<Plug>(mkdx-indent)', 'n'))
      nmap <buffer><silent> <Tab> <Plug>(mkdx-indent)
    endif
    if (!hasmapto('<Plug>(mkdx-indent', 'v'))
      vmap <buffer><silent> <Tab> <Plug>(mkdx-indent)
    endif
    if (!hasmapto('<Plug>(mkdx-unindent)', 'n'))
      nmap <buffer><silent> <S-Tab> <Plug>(mkdx-unindent)
    endif
    if (!hasmapto('<Plug>(mkdx-unindent', 'v'))
      vmap <buffer><silent> <S-Tab> <Plug>(mkdx-unindent)
    endif
  endif

  if (g:mkdx#settings.enter.enable)
    setlocal formatoptions-=r
    setlocal autoindent

    if (!hasmapto('<Plug>(mkdx-shift-enter)', 'i') && g:mkdx#settings.enter.shift)
      imap <buffer><silent> <S-CR> <Plug>(mkdx-shift-enter)
    endif

    if (!hasmapto('<Plug>(mkdx-enter)', 'i'))
      imap <buffer><silent> <Cr> <Plug>(mkdx-enter)
    endif
  endif

  if (!hasmapto('<Plug>(mkdx-o)', 'n') && g:mkdx#settings.enter.o)
    setlocal formatoptions-=r
    setlocal autoindent
    nmap <buffer><silent> o <Plug>(mkdx-o)
  endif

  if (!hasmapto('<Plug>(mkdx-shift-o)', 'n') && g:mkdx#settings.enter.shifto)
    setlocal formatoptions-=r
    setlocal autoindent
    nmap <buffer><silent> O <Plug>(mkdx-shift-o)
  end

  for [label, prefix, mapmode, binding, plug, cmd] in s:bindings
    let mapping = (prefix ? g:mkdx#settings.map.prefix : '') . binding

    if ((maparg(mapping, mapmode) == "") && !hasmapto(plug, mapmode))
      if (!empty(cmd) && has('menu'))
        exe mapmode . 'noremenu <silent> <script> Plugin.mkdx.' . label . (mapmode == 'v' ? '\ (Visual)' : '') . '<tab>' . mapping . ' ' . cmd
      end

      exe mapmode . 'map <buffer> ' . mapping . ' ' . plug
    endif
  endfor
endif

if exists('g:loaded_modusline')
  finish
endif
let g:loaded_modusline = 1

if empty(&statusline)
  set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P   " standard with ruler
endif

if !exists('g:modusline_colors')
  let g:modusline_colors           = {}              " see :help mode()
  let g:modusline_colors['n']      = ''              " Normal
  let g:modusline_colors['no']     = '%#DiffChange#' " Operator-pending
  let g:modusline_colors['v']      = '%#DiffText#'   " Visual by character
  let g:modusline_colors['V']      = '%#DiffText#'   " Visual by line
  let g:modusline_colors["\<C-V>"] = '%#DiffText#'   " Visual blockwise
  let g:modusline_colors['s']      = '%#WildMenu#'   " Select by character
  let g:modusline_colors['S']      = '%#WildMenu#'   " Select by line
  let g:modusline_colors["\<C-S>"] = '%#WildMenu#'   " Select blockwise
  let g:modusline_colors['i']      = '%#DiffAdd#'    " Insert
  let g:modusline_colors['R']      = '%#DiffDelete#' " Replace |R|
  let g:modusline_colors['Rv']     = '%#DiffDelete#' " Virtual Replace |gR|
  let g:modusline_colors['c']      = '%#Search#'     " Command-line
  let g:modusline_colors['cv']     = '%#MatchParen#' " Vim Ex mode |gQ|
  let g:modusline_colors['ce']     = '%#MatchParen#' " Normal Ex mode |Q|
  let g:modusline_colors['r']      = '%#Todo#'       " Hit-enter prompt
  let g:modusline_colors['rm']     = '%#Todo#'       " The -- more -- prompt
  let g:modusline_colors['r?']     = '%#Todo#'       " A |:confirm| query of some sort
  let g:modusline_colors['!']      = '%#IncSearch#'  " Shell or external command is executing
  let g:modusline_colors['t']      = '%#DiffAdd#'    " Terminal mode: keys go to the job
  let g:modusline_colors['ic']     = '%#DiffChange#' " see :help ins-completion
endif

if !exists('g:modusline_labels')
  let g:modusline_labels = {}
endif

function! ModusLine(statusline) abort
  let modus = mode(1)
  let color = ModusLineColor(modus)
  let label = ModusLineLabel(modus)
  return ModusLineMerge(a:statusline, modus, color, label)
endfunction

function! ModusLineColor(modus) abort
  return get(g:modusline_colors, a:modus, '%#ErrorMsg#')
endfunction

function! ModusLineLabel(modus) abort
  return get(g:modusline_labels, a:modus, a:modus)
endfunction

function! ModusLineMerge(statusline, modus, color, label) abort
  return a:color .'‹'. a:label .'› '. a:statusline
endfunction

augroup ModusLine
  autocmd!

  autocmd VimEnter,WinEnter,BufWinEnter *
        \ setlocal statusline& |
        \ let statusline=&statusline |
        \ setlocal statusline=%!ModusLine(statusline)

  autocmd VimLeave,WinLeave,BufWinLeave *
        \ setlocal statusline&

augroup END

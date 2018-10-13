# modusline: Mode-specific statusline colors

This plugin provides mode-specific coloring for your Vim statusline so that
you can visually (through color) distinguish which mode Vim is currently in.

## Setup

Install this plugin using your favorite Vim plugin manager and restart Vim.
Now change Vim modes and observe the statusline changing colors accordingly.
That's all! For customization, read about *Variables* and *Functions* below.

## Preview

!['n'      Normal mode              ](https://github.com/sunaku/vim-modusline/raw/gh-pages/n.png)
!['no'     Operator-pending mode    ](https://github.com/sunaku/vim-modusline/raw/gh-pages/no.png)
!['v'      Visual mode, by character](https://github.com/sunaku/vim-modusline/raw/gh-pages/v.png)
!['V'      Visual mode, by line     ](https://github.com/sunaku/vim-modusline/raw/gh-pages/V.png)
!["\<C-V>" Visual mode, blockwise   ](https://github.com/sunaku/vim-modusline/raw/gh-pages/C-V.png)
!['s'      Select mode, by character](https://github.com/sunaku/vim-modusline/raw/gh-pages/s.png)
!['S'      Select mode, by line     ](https://github.com/sunaku/vim-modusline/raw/gh-pages/S.png)
!["\<C-S>" Select mode, blockwise   ](https://github.com/sunaku/vim-modusline/raw/gh-pages/C-S.png)
!['i'      Insert mode              ](https://github.com/sunaku/vim-modusline/raw/gh-pages/i.png)
!['ic'     Insert mode completion   ](https://github.com/sunaku/vim-modusline/raw/gh-pages/ic.png)
!['R'      Replace mode             ](https://github.com/sunaku/vim-modusline/raw/gh-pages/R.png)
!['Rc'     Replace mode completion  ](https://github.com/sunaku/vim-modusline/raw/gh-pages/Rc.png)
!['Rv'     Virtual Replace mode     ](https://github.com/sunaku/vim-modusline/raw/gh-pages/Rv.png)
!['c'      Command mode             ](https://github.com/sunaku/vim-modusline/raw/gh-pages/c.png)
!['t'      Terminal mode            ](https://github.com/sunaku/vim-modusline/raw/gh-pages/t.png)

## Variables

You can redefine any of these variables per your customization needs.

### `&statusline`

You can define your own custom statusline (the default one is shown below)
and this plugin will automatically add mode-specific colors/labels to it.

By default, this variable is defined as follows, unless you override it:

```vim
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
```

### `g:modusline_set_ls`

You can assign 0 to this variable to prevent this plugin from changing the
`laststatus` setting to always show the statusline for bottom-most windows:

```vim
let g:modusline_set_ls = 0
```

### `g:modusline_colors`

A dictionary that maps `mode()` values to `%#HLname#` statusline colors.
If there is no entry for a particular `mode()` value in the dictionary,
then this plugin falls back to using jarring `%#ErrorMsg#` as the color.

By default, this variable is defined as follows, unless you override it:

```vim
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
let g:modusline_colors['Rc']     = '%#DiffChange#' " see :help ins-completion
```

### `g:modusline_labels`

A dictionary that maps `mode()` values to user-friendly labels (strings).
If there is no entry for a particular `mode()` value in the dictionary,
then this plugin falls back to using that `mode()` value as the label.

By default, this variable is defined as follows, unless you override it:

```vim
let g:modusline_labels = {}
```

## Functions

You can redefine any of these functions per your customization needs.

### `Modusline(statusline)`

Adds mode-specific colors and labels to the given statusline and returns
a new statusline expression that you can assign via `:set statusline=`.

```vim
function! Modusline(statusline) abort
  let modus = mode(1)
  let color = ModuslineColor(modus)
  let label = ModuslineLabel(modus)
  return ModuslineMerge(a:statusline, modus, color, label)
endfunction
```

### `ModuslineColor(modus)`

Returns a `%#HLname#` statusline color for the given `mode()` value by
referencing the `g:modusline_colors` dictionary, as described earlier:
If there is no entry for a particular `mode()` value in the dictionary,
then this plugin falls back to using jarring `%#ErrorMsg#` as the color.

```vim
function! ModuslineColor(modus) abort
  return get(g:modusline_colors, a:modus, '%#ErrorMsg#')
endfunction
```

### `ModuslineLabel(modus)`

Returns a user-friendly labels (strings) for the given `mode()` value by
referencing the `g:modusline_labels` dictionary, as described earlier:
If there is no entry for a particular `mode()` value in the dictionary,
then this plugin falls back to using that `mode()` value as the label.

```vim
function! ModuslineLabel(modus) abort
  return get(g:modusline_labels, a:modus, a:modus)
endfunction
```

### `ModuslineMerge(statusline, modus, color, label)`

Returns a statusline expression built up from all the pieces passed in.

```vim
function! ModuslineMerge(statusline, modus, color, label) abort
  return a:color .'‹'. a:label .'› '. a:statusline
endfunction
```

## References

* https://hackernoon.com/the-last-statusline-for-vim-a613048959b2
* https://www.reddit.com/r/vim/comments/6b7b08/my_custom_statusline

## License

[Spare A Life]: https://sunaku.github.io/vegan-for-life.html
> Like my work? :+1:  Please [spare a life] today as thanks!
:cow::pig::chicken::fish::speak_no_evil::v::revolving_hearts:

Copyright 2018 Suraj N. Kurapati <https://github.com/sunaku>

Distributed under the same terms as Vim itself.


augroup MyAutoCmd
  autocmd!
augroup END

augroup MyFt
  autocmd!
augroup END

augroup CustomFileType
  autocmd!
augroup END

" -------------------------------------------------------------------
" set once before plugins
if has('vim_starting')

  " Use <Leader> in global plugin.
  let g:mapleader = ' '
  " Use <LocalLeader> in filetype plugin.
  let g:maplocalleader = '\'

  " Release keymappings for plug-in.
  nnoremap <space> <Nop>
  nnoremap \  <Nop>

  " Disable menu.vim
  if has('gui_running')
    set guioptions=Mc
  endif

  " set packpath=
  let g:loaded_2html_plugin      = 1
  let g:loaded_logiPat           = 1
  let g:loaded_getscriptPlugin   = 1
  let g:loaded_gzip              = 1
  " let g:loaded_man               = 1
  let g:loaded_matchit           = 1
  let g:loaded_matchparen        = 1
  let g:loaded_netrwFileHandlers = 1
  let g:loaded_netrwSettings     = 1
  let g:loaded_rrhelper          = 1
  let g:loaded_shada_plugin      = 1
  let g:loaded_tarPlugin         = 1
  let g:loaded_tutor_mode_plugin = 1
  let g:loaded_vimballPlugin     = 1
  let g:loaded_zipPlugin         = 1

  " to download spellfiles uncomment these:
  let g:loaded_netrwPlugin       = 1
  let g:loaded_spellfile_plugin  = 1
endif


" turn on and detect filetype syntax etc
if has('vim_starting')
  silent! filetype plugin indent on
  syntax enable
endif
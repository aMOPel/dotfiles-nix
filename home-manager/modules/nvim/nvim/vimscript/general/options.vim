" -------------------------------------------------------------------
" set
" Enables 24-bit RGB color in the terminal
if has('termguicolors') && $COLORTERM =~# 'truecolor\|24bit'
	set termguicolors
endif

if (!has("nvim"))
	set encoding=utf8
	set autoindent
	set autoread
	set backspace=eol,start,indent
	set smarttab
	set incsearch
	set hlsearch
	set showcmd
	set wildmenu
endif

set fileformats=unix,dos,mac
set list 
set listchars=tab:»\ ,trail:·,nbsp:·
set clipboard^=unnamedplus

set nowrap

" set number
set relativenumber
" set numberwidth=1
set signcolumn=yes:1

sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=

set showtabline=2

set nofoldenable
set foldcolumn=0
set foldlevelstart=99
set foldnestmax=1
" set foldmethod=manual


set tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set scrolloff=10
set sidescrolloff=1
set noruler
set cursorline
set colorcolumn=80

set sessionoptions=folds,curdir,tabpages,winpos
set viewoptions-=options

set autowriteall

set ignorecase
set smartcase

" set inccommand=nosplit
set cmdheight=2
set magic

" set wildmode=longest:full,full
" set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

set undofile

set nobackup
set nowb
set noswapfile

set noerrorbells
set novisualbell

" set splitbelow
set splitright
set helpheight=35

set lazyredraw

" set tildeop

" external vimrc
set exrc
" set secure

" set diffopt^=linematch:60

let g:editorconfig = v:true

"spell checking
" set spell
" set spelllang=en_us

" -------------------------------------------------------------------

" call g:Base16hi('TabLineFill', base16_gui00, base16_gui00, base16_gui00, base16_gui00)
" call g:Base16hi('TabLineSel', base16_gui0C, base16_gui01, base16_gui00, base16_gui00, 'bold')
" call g:Base16hi('TabLine', base16_gui01, base16_gui03, base16_gui00, base16_gui00, 'italic')

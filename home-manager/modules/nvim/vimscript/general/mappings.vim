" -------------------------------------------------------------------
" mappings
" inoremap jk <ESC>

" incremental numbering visual selection
xnoremap <leader>i1 :s/\%V/0<C-V><TAB>/<CR>gvg<C-A>gv:retab<ESC>gvI<C-G>u<ESC>gv/ <CR>:s/\%V /./<CR>

" stop using S X
nmap S <nop>
nmap X <nop>

" cycle changelist
nnoremap ( g,
nnoremap ) g;

"jump to alternative last edited
nnoremap <space><space> :b#<CR>

" search in visual selection
vnoremap / <esc>/\%V

"Z to close
noremap ZZ :qa<CR>
noremap ZA :qa!<CR>
noremap ZB :bdelete<CR>
noremap ZW :close<CR>
noremap ZT :tabclose<CR>
noremap ZJ :helpclose<cr>:cclose<CR>:lclose<cr>

" move vertical selection up/down and keep selection
" vnoremap <silent> <c-k> :m '<-2<CR>gv
" vnoremap <silent> <c-j> :m '>+1<CR>gv

" Re-select blocks after indenting in visual/select mode
" xnoremap < <gv
" xnoremap > >gv|

" Indent and jump to first non-blank character linewise
nnoremap >>  >>_
nnoremap <<  <<_

" Change current word in a repeatable manner
" nnoremap <Leader>cn *``cgn
" nnoremap <Leader>cN *``cgN

" Change selected word in a repeatable manner
" vnoremap <expr> <Leader>cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
" vnoremap <expr> <Leader>cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" Quick substitute within selected area
xnoremap <leader>sg :s//g<Left><Left>
nnoremap <leader>sg mz*:%s///g\|norm g`z<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" undo points in insert
inoremap <space> <c-g>u<space>
inoremap { <c-g>u{
inoremap [ <c-g>u[
inoremap ( <c-g>u(
inoremap , <c-g>u,
inoremap . <c-g>u.

" Open file under the cursor in a vsplit
nnoremap gf :vertical wincmd f<CR>

" Fast saving from normal/visual
nnoremap <C-s> :<C-u>write<CR>
vnoremap <C-s> :<C-u>write<CR>

" Yank buffer's relative/absolute path to clipboard
" nnoremap <Leader>y :let @+=expand("%:~:.")<CR>:echo 'Yanked relative path'<CR>
" nnoremap <Leader>Y :let @+=expand("%:p")<CR>:echo 'Yanked absolute path'<CR>

" make
" nnoremap <cr> :make<CR>

" close all temp windows
nnoremap <silent> <c-w>a :cclose<CR>:pclose<CR>:helpclose<CR>:lclose<CR>
nnoremap <silent> <c-w><c-a> :cclose<CR>:pclose<CR>:helpclose<CR>:lclose<CR>

"tab control
nnoremap <C-t>n :tabnew<cr>
nnoremap <C-t>o :tabonly<cr>
nnoremap <C-t>c :tabclose<cr>
nnoremap <C-t>l :tabnext<cr>
nnoremap <C-t>t :tabnext<cr>
nnoremap <C-t>h :tabprevious<cr>
nnoremap <C-t>L :tabmove +1<cr>
nnoremap <C-t>H :tabmove -1<cr>

nnoremap <C-t><c-n> :tabnew<cr>
nnoremap <C-t><c-o> :tabonly<cr>
nnoremap <C-t><c-c> :tabclose<cr>
nnoremap <C-t><c-l> :tabnext<cr>
nnoremap <C-t><c-t> :tabnext<cr>
nnoremap <C-t><c-h> :tabprevious<cr>

"buffer control
nnoremap <C-b>b :bnext<CR>
nnoremap <C-b>l :bnext<CR>
nnoremap <C-b>h :bprevious<CR>
nnoremap <C-b>c :bdelete<CR>
nnoremap <C-b>d :bdelete<CR>

nnoremap <C-b><C-b> :bnext<CR>
nnoremap <C-b><C-l> :bnext<CR>
nnoremap <C-b><C-h> :bprevious<CR>
nnoremap <C-b><C-c> :bdelete<CR>
nnoremap <C-b><C-d> :bdelete<CR>

" stolen from vim-sensible,
" adds the insertmode c-u and c-w to the undo hist
if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

" delete whitespace, clear highlighting and keep position using marks
" nnoremap <silent> <leader>ws mb:%s/\s*$//<cr>:nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>g'bzz

" quick edit and buffer search
nmap <c-e> :e ./<c-n>
nmap <c-q> :b <c-n>

" insert date
nmap <leader>id O<esc>v:!date +"\%b \%e. \%Y"<cr>
vmap <leader>id :!date +"\%b \%e. \%Y"<cr>
nmap <leader>idr <space>idMddf"Siqj0

" <esc> in terminal mode
tnoremap <F11> <C-\><C-n>

" custom filetypes
autocmd CustomFileType BufEnter *kitty*.conf set ft=kitty
autocmd CustomFileType BufEnter *.tscn,*.tres,*.import,*.godot set filetype=dosini
autocmd CustomFileType BufEnter .env,.envrc set filetype=sh

" quick search and replace in quickfix
autocmd MyAutoCmd FileType qf nnoremap <buffer> s :<c-u>cdo s/// \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" follow tags in helpfiles easier
autocmd MyAutoCmd FileType help nnoremap <buffer> go <c-]>

" chezmoi apply and packer compile on save
autocmd MyAutoCmd BufEnter $XDG_DATA_HOME/chezmoi/home/* nnoremap <buffer> <silent> <c-s> :<c-u>silent! write<cr>:silent! !chezmoi apply --source-path %<cr>:echo "chezmoi applied"<cr>:doautocmd User ChezmoiPost<cr>
autocmd MyAutoCmd User ChezmoiPost sleep | PackerCompile

command! DiagnosticEnable lua vim.diagnostic.enable()
command! DiagnosticDisable lua vim.diagnostic.disable()

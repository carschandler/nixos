--vim.g.mapleader = 's'
vim.cmd([[
noremap <Space> :
" noremap s <NOP>

noremap <M-r> <Esc>:set formatoptions+=t<CR>
inoremap <M-r> <Esc>:set formatoptions+=t<CR>a
noremap <M-R> <Esc>:set formatoptions-=t<CR>
inoremap <M-R> <Esc>:set formatoptions-=t<CR>a

" Window Navigation
noremap <M-H> <C-W>h 
noremap <M-J> <C-W>j 
noremap <M-K> <C-W>k 
noremap <M-L> <C-W>l 
noremap! <M-H> <Esc><C-W>h 
noremap! <M-J> <Esc><C-W>j 
noremap! <M-K> <Esc><C-W>k 
noremap! <M-L> <Esc><C-W>l 
tnoremap <M-H> <C-\><C-n><C-W>h 
tnoremap <M-J> <C-\><C-n><C-W>j 
tnoremap <M-K> <C-\><C-n><C-W>k 
tnoremap <M-L> <C-\><C-n><C-W>l 

" Resizing
noremap <C-h> <C-W><
noremap <C-j> <C-W>+ 
noremap <C-k> <C-W>- 
noremap <C-l> <C-W>> 

" Moving Windows
noremap <M-C-h> <C-W>H 
noremap <M-C-j> <C-W>J 
noremap <M-C-k> <C-W>K 
noremap <M-C-l> <C-W>L 
tnoremap <M-C-h> <C-\><C-n><C-W>H 
tnoremap <M-C-j> <C-\><C-n><C-W>J 
tnoremap <M-C-k> <C-\><C-n><C-W>K 
tnoremap <M-C-l> <C-\><C-n><C-W>L 
]])

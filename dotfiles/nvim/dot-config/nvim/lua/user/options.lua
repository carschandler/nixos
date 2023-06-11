vim.cmd([[
noremap <Space> :
noremap : ;
let mapleader = ";"

noremap <M-w> :set formatoptions+=t<CR>
inoremap <M-w> <Esc>:set formatoptions +=t<CR>a
noremap <M-W> :set formatoptions-=t<CR>
inoremap <M-W> <Esc>:set formatoptions-=t<CR>a

noremap <M-h> <C-W>h 
noremap <M-j> <C-W>j 
noremap <M-k> <C-W>k 
noremap <M-l> <C-W>l 
noremap! <M-h> <Esc><C-W>h 
noremap! <M-j> <Esc><C-W>j 
noremap! <M-k> <Esc><C-W>k 
noremap! <M-l> <Esc><C-W>l 
tnoremap <M-h> <C-W>h 
tnoremap <M-j> <C-W>j 
tnoremap <M-k> <C-W>k 
tnoremap <M-l> <C-W>l 


filetype plugin on
let g:netrw_banner='i'
let g:netrw_preview = 1
let g:netrw_liststyle = 3
let g:netrw_winsize = 30
set tabstop=3
set shiftwidth=3
set autoindent
set smarttab
set expandtab
set incsearch
set inccommand=split
set hlsearch
set ignorecase
set smartcase
set confirm
set history=1000
set relativenumber
set mouse=a
set ttimeoutlen=5
set textwidth=80
set formatoptions=cqjon
set cinkeys-=0#
set number
]])

vim.cmd([[
filetype plugin indent on
let g:netrw_banner='i'
let g:netrw_preview = 1
let g:netrw_winsize = 30
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smarttab
set incsearch
set inccommand=split
set nohlsearch
set ignorecase
set smartcase
set confirm
set history=1000
set relativenumber
set ttimeoutlen=5
set textwidth=80
set formatoptions=cqjnr
" Add bulleted lists
set formatlistpat=^\\s*\\%(\\d\\|[-*+]\\)\\+[\\]:.)}\\t\ ]\\s*
set number
set linebreak
]])

vim.filetype.add({
  extension = {
    typ = "typst",
  },
})

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldlevelstart = 99
vim.o.winborder = "rounded"

-- TODO rounded statuslines? Need an autocmd so that it updates each time a
-- window is split/moved
-- :setlocal statusline=%1*%*%<%f\ %h%m%r%=%-14.(%l,%c%)\ %P%1*

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
set number
]])

vim.filetype.add({
  extension = {
    typ = "typst",
  }
})

local fn = vim.fn

-- Auto install packer.nvim
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.isdirectory(install_path) == 0 then
  print('cloning packer')
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})

  -- packer init and setup
  print('requiring user/plugins')
  require('user/plugins')
  -- require user/post_packer_init after packer finishes installing plugins
  vim.cmd 'autocmd User PackerComplete ++once lua require("user/post_packer_init")'
  -- sync/install plugins
  require('packer').sync()
else
  require('user/post_packer_init')
end

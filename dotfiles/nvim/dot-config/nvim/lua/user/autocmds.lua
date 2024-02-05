local autocmd = vim.api.nvim_create_autocmd

autocmd('TermOpen', {
  callback = function()
    vim.opt.spell = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd.startinsert()
  end,
  desc = 'Turn off line numbers, spellcheck for terminal mode'
})

autocmd('WinEnter', {
  pattern = {"term://*"},
  callback = function()
    vim.cmd.startinsert()
  end,
  desc = 'Enter insert mode whenever entering a term window'
})


autocmd('WinEnter', {
  pattern = {"\\[dap-repl\\]"},
  callback = function()
    vim.cmd.startinsert()
    vim.opt.spell = false
    -- vim.opt.number = false
    -- vim.opt.relativenumber = false
    vim.cmd.startinsert()
  end,
  desc = 'Enter insert mode whenever entering a dap window'
})

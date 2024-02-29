return {
  "shortcuts/no-neck-pain.nvim",
  config = function ()
    vim.keymap.set('n', '<Leader>np', function() vim.cmd("NoNeckPain") end, { desc = "Toggle NoNeckPain" })
    vim.keymap.set('n', '<Leader>nr', function() vim.cmd("NoNeckPainToggleRight") end, { desc = "Toggle NoNeckPain Right Pane" })
    vim.keymap.set('n', '<Leader>nl', function() vim.cmd("NoNeckPainToggleLeft") end, { desc = "Toggle NoNeckPain Left Pane" })
  end
}

return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function ()
    local oil = require("oil")
    oil.setup({
      view_options = {
        show_hidden = true,
      },
      float = {
        border = "solid",
        padding = 5,
        win_options = {
          winblend = 0,
        },
      },
    })
    vim.keymap.set('n', '<Leader>e', function()
      if vim.bo.filetype ~= 'oil' then
        oil.open()
      else
        oil.close()
      end
    end, {desc = 'Toggle file explorer'})
    vim.keymap.set('n', '<Leader>E', oil.open_float, {desc = 'Explore in floating window'})
  end
}

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
   -- your configuration comes here
   -- or leave it empty to use the default settings
   -- refer to the configuration section below
  },
  config = function()
    vim.keymap.set('n', '<Leader>lt', function()
      require('trouble').toggle("workspace_diagnostics")
    end, { desc = "Trouble (workspace)" })
    vim.keymap.set('n', '<Leader>lT', function()
      require('trouble').toggle()
    end, { desc = "Trouble (buffer)" })
  end,
}

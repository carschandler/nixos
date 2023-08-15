return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = "all",
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          -- set to `false` to disable one of the mappings
          init_selection = "<BS>",
          node_incremental = "<BS>",
          scope_incremental = "<C-H>", -- <C-BS> reads as <C-H>
          node_decremental = "<M-BS>",
        },
      },
      sync_install = false,
      ignore_install = {},
      auto_install = false,
      modules = {},
    })

    vim.go.foldlevelstart = 99
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
  end
}

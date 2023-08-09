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
          scope_incremental = "<M-BS>",
          node_decremental = "<S-BS>",
        },
      },
      sync_install = false,
      ignore_install = {},
      auto_install = false,
      modules = {},
    })
  end
}

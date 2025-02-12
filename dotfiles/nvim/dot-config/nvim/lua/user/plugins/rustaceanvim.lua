return {
  "mrcjkb/rustaceanvim",
  cond = not vim.g.vscode,
  version = "^5", -- Recommended
  lazy = false,
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = "rounded",
        },
      },
      server = {
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            files = {
              excludeDirs = { ".direnv" },
            },
          },
        },
      },
    }
  end,
}

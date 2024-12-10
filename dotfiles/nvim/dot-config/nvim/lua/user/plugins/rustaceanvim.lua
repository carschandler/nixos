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
    }
  end,
}

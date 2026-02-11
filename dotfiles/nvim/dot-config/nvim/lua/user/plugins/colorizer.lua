return {
  "uga-rosa/ccc.nvim",
  cond = not vim.g.vscode,
  ft = { "css", "scss", "sass", "html" },
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
    highlight_mode = "virtual",
  },
}

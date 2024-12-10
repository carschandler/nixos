return {
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  "lsp_lines.nvim",
  cond = not vim.g.vscode,
  dev = true,
  opts = {
    box_drawing_characters = {
      up_right = "╰",
    },
  },
  config = function(opts)
    require("lsp_lines").setup(opts)
    vim.diagnostic.config({ virtual_text = false })
  end,
}

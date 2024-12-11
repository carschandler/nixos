return {
  "https://git.sr.ht/~carschandler/lsp_lines.nvim",
  -- "lsp_lines.nvim",
  -- dev = true,
  cond = not vim.g.vscode,
  opts = {
    box_drawing_characters = {
      up_right = "╰",
    },
  },
  config = function(_, opts)
    require("lsp_lines").setup(opts)
    vim.diagnostic.config({ virtual_text = false })
  end,
}

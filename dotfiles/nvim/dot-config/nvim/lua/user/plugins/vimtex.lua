return {
  "lervag/vimtex",
  cond = not vim.g.vscode,
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "quarto",
      command = [[call vimtex#init()]],
    })
  end,
}

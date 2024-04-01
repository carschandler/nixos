-- See treesitter.lua for treesitter text objects
return {
	"chrisgrieser/nvim-various-textobjs",
	lazy = false,
	opts = {
    useDefaultKeymaps = true,
    disabledKeymaps = {"aC", "iC", "ic", "gw", "gc"},
  },
  config = function()
    vim.keymap.set(
      { "o", "x" },
      "ic",
      '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
      { desc = "commented lines" }
    )
  end
}

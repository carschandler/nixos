-- See treesitter.lua for treesitter text objects
return {
	"chrisgrieser/nvim-various-textobjs",
	lazy = false,
	opts = {
    useDefaultKeymaps = true,
    disabledKeymaps = {"aC", "iC", "gw", "gc"},
  },
  config = {
    vim.keymap.set(
      { "o", "x" },
      "mc",
      '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>'
    )
  }
}

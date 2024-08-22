-- See treesitter.lua for treesitter text objects
return {
	"chrisgrieser/nvim-various-textobjs",
	lazy = false,
	opts = {
		useDefaultKeymaps = true,
		disabledKeymaps = { "aC", "iC", "ic", "gw", "gc" },
	},
}

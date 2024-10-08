return {
	"chomosuke/typst-preview.nvim",
	cond = not vim.g.vscode,
	lazy = false, -- or ft = 'typst'
	version = "0.1.*",
	opts = {
		debug = true,
	},

	build = function()
		require("typst-preview").update()
	end,
	opts = {
		debug = true,
		dependencies_bin = {
			["typst-preview"] = "typst-preview",
			["websocat"] = "websocat",
		},
	},
}

return {
	"mrcjkb/rustaceanvim",
	cond = not vim.g.vscode,
	version = "^4", -- Recommended
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

return {
	"kevinhwang91/nvim-bqf",
	cond = not vim.g.vscode,
	ft = "qf",
	opts = {
		preview = {
			winblend = 0,
		},
	},
}

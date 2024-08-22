return {
	"lervag/vimtex",
	not vim.g.vscode,
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
	end,
}

return {
	"R-nvim/R.nvim",
	cond = not vim.g.vscode,
	ft = "rmd",
	opts = {
		rmdchunk = "``",
		hook = {
			on_filetype = function()
				-- This function will be called at the FileType event of files supported
				-- by R.nvim. This is an opportunity to create mappings local to
				-- buffers.
				vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
				vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })
				-- vim.keymap.set("i", "**", )

				-- Increase the width of which-key to handle the longer r-nvim
				-- descriptions
				local wk = require("which-key")
				-- Workaround from
				-- https://github.com/folke/which-key.nvim/issues/514#issuecomment-1987286901
				wk.add({
					{ "<localleader>a", group = "all" },
					{ "<localleader>b", group = "between marks" },
					{ "<localleader>c", group = "chunks" },
					{ "<localleader>f", group = "functions" },
					{ "<localleader>g", group = "goto" },
					{ "<localleader>k", group = "knit" },
					{ "<localleader>p", group = "paragraph" },
					{ "<localleader>q", group = "quarto" },
					{ "<localleader>r", group = "general" },
					{ "<localleader>s", group = "split/send" },
					{ "<localleader>t", group = "terminal" },
					{ "<localleader>v", group = "view" },
				})
			end,
		},
	},
}

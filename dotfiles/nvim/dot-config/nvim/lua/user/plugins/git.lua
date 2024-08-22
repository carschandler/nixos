return {
	{ "tpope/vim-fugitive" },
	{
		"NeogitOrg/neogit",
		cond = not vim.g.vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		keys = {
			{
				"<Leader>g",
				function()
					require("neogit").open()
				end,
				desc = "Git",
			},
		},
		opts = {
			signs = {
				-- item = { "", "" },
				-- section = { "", "" },
				-- item = { "", "" },
				-- section = { "", "" },
				-- item = { "󰍟", "󰍝" },
				-- section = { "󰍟", "󰍝" },
				-- item = { "", "" },
				-- section = { "", "" },
				item = { "", "" },
				section = { "", "" },
			},
			status = {
				mode_padding = 1,
				mode_text = {
					M = "󰷉",
					N = "󰻭",
					A = "󰸩",
					D = "󱀷",
					C = "󰬳",
					U = "󱈗",
					R = "󱀱",
					["?"] = "󱀶",
					DD = "󰩌",
					DU = "󰩌",
					UD = "󰩌",
					AA = "󰩌",
					AU = "󰩌",
					UA = "󰩌",
					UU = "󰩌",
				},
			},
			mappings = {
				status = {
					["="] = "Toggle",
				},
			},
		},
	},
}

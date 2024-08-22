return {
	"stevearc/conform.nvim",
	cond = not vim.g.vscode,
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				python = { "isort", "black" },
				rust = { "rustfmt" },
				lua = { "stylua" },
				nix = { "nixfmt" },
			},

			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				return { timeout_ms = 500, lsp_format = "fallback", async = false }
			end,
		})

		conform.formatters.black = {
			prepend_args = {
				"--preview",
				"--enable-unstable-feature=string_processing",
			},
		}

		conform.formatters.isort = {
			prepend_args = {
				"--profile",
				"black",
			},
		}

		vim.keymap.set("n", "<Leader>lf", conform.format, { desc = "Format buffer" })
		vim.keymap.set("n", "<M-F>", conform.format, { desc = "Format buffer" })

		-- Set commands to disable format-on-save temporarily
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})

		vim.api.nvim_create_user_command("W", function()
			vim.b.disable_autoformat = true
			vim.cmd.write()
		end, {
			desc = "Write without formatting",
		})
	end,
}

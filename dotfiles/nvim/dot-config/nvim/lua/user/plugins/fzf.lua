return {
	"ibhagwan/fzf-lua",
	cond = not vim.g.vscode,
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- calling `setup` is optional for customization
		local fzf = require("fzf-lua")
		local wk = require("which-key")

		fzf.setup({})

		wk.add({
			{ "<Leader>f", group = "fzf" },
			{ "<Leader>fc", group = "changes/commands" },
			{ "<Leader>fd", group = "dap" },
			{ "<Leader>fg", group = "git" },
			{ "<Leader>fl", group = "LSP" },
			{ "<Leader>fs", group = "search/spell" },
			{ "<Leader>ft", group = "this word" },
		})

		vim.keymap.set("n", "<Leader>f;", fzf.resume, { desc = "Resume" })
		vim.keymap.set("n", "<Leader>fm", fzf.builtin, { desc = "Menu" })
		vim.keymap.set("n", "<Leader>ff", fzf.files, { desc = "Files" })
		vim.keymap.set("n", "<Leader><Space>", fzf.files, { desc = "Fuzzy find files" })
		vim.keymap.set("n", "<Leader>fh", fzf.help_tags, { desc = "Help tags" })
		vim.keymap.set("n", "<Leader>fb", fzf.buffers, { desc = "Current buffers" })
		vim.keymap.set("n", "<Leader>fL", fzf.lines, { desc = "Open buf lines" })
		vim.keymap.set("n", "<Leader>fr", fzf.lines, { desc = "Resume search" })
		vim.keymap.set("n", "<Leader>fw", fzf.live_grep, { desc = "Grep project" })
		vim.keymap.set("n", "<Leader>fW", fzf.lgrep_curbuf, { desc = "Grep buffer" })
		-- lgrep_curbuf covers this capability...
		-- vim.keymap.set('n', '<Leader>fn', fzf.blines, { desc = "Current buf lines" })

		-- FzfLua grep_project,curbuf exist too and the main difference just seems
		-- to be that they fuzzy find by default and start by showing all lines...

		vim.keymap.set("n", "<Leader>ftw", fzf.grep_cword, { desc = "Grep word" })
		vim.keymap.set("n", "<Leader>ftW", fzf.grep_cWORD, { desc = "Grep WORD" })
		vim.keymap.set({ "n", "v" }, "<Leader>fv", fzf.grep_visual, { desc = "Grep selection" })

		vim.keymap.set("n", "<Leader>fgf", fzf.git_files, { desc = "Git files" })
		vim.keymap.set("n", "<Leader>fgs", fzf.git_status, { desc = "Git status" })
		vim.keymap.set("n", "<Leader>fgc", fzf.git_commits, { desc = "Git commits" })
		vim.keymap.set("n", "<Leader>fgh", fzf.git_bcommits, { desc = "Git buf hist" })
		vim.keymap.set("n", "<Leader>fgb", fzf.git_branches, { desc = "Git branches" })
		vim.keymap.set("n", "<Leader>fgS", fzf.git_stash, { desc = "Git stash" })

		vim.keymap.set("n", "<Leader>flr", fzf.lsp_references, { desc = "References" })
		vim.keymap.set("n", "<Leader>fld", fzf.lsp_definitions, { desc = "Definitions" })
		vim.keymap.set("n", "<Leader>flD", fzf.lsp_declarations, { desc = "Declarations" })
		vim.keymap.set("n", "<Leader>flt", fzf.lsp_typedefs, { desc = "Typedefs" })
		vim.keymap.set("n", "<Leader>fli", fzf.lsp_implementations, { desc = "Implementations" })
		vim.keymap.set("n", "<Leader>flS", fzf.lsp_document_symbols, { desc = "Buf symbols" })
		vim.keymap.set("n", "<Leader>fls", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
		vim.keymap.set("n", "<Leader>fla", fzf.lsp_code_actions, { desc = "Code actions" })
		vim.keymap.set("n", "<Leader>flf", fzf.lsp_finder, { desc = "Finder" })
		vim.keymap.set("n", "<Leader>fln", fzf.lsp_incoming_calls, { desc = "Incoming calls" })
		vim.keymap.set("n", "<Leader>flo", fzf.lsp_outgoing_calls, { desc = "Outgoing calls" })
		vim.keymap.set("n", "<Leader>flE", fzf.diagnostics_document, { desc = "Buffer diagnostics" })
		vim.keymap.set("n", "<Leader>fle", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })

		vim.keymap.set("n", "<Leader>fch", fzf.command_history, { desc = "Command history" })
		vim.keymap.set("n", "<Leader>fsh", fzf.search_history, { desc = "Search history" })
		vim.keymap.set("n", "<Leader>fr", fzf.registers, { desc = "Registers" })
		vim.keymap.set("n", "<Leader>fH", fzf.highlights, { desc = "Highlights" })
		vim.keymap.set("n", "<Leader>fj", fzf.jumps, { desc = "Jumps" })
		vim.keymap.set("n", "<Leader>fcg", fzf.changes, { desc = "Changes" })
		vim.keymap.set("n", "<Leader>fk", fzf.keymaps, { desc = "Keymaps" })
		vim.keymap.set("n", "<Leader>fsp", fzf.spell_suggest, { desc = "Spell suggest" })

		vim.keymap.set("n", "<Leader>fdc", fzf.dap_commands, { desc = "Dap commands" })
		vim.keymap.set("n", "<Leader>fdC", fzf.dap_configurations, { desc = "Dap configs" })
		vim.keymap.set("n", "<Leader>fdb", fzf.dap_breakpoints, { desc = "Dap breakpoints" })
		vim.keymap.set("n", "<Leader>fdv", fzf.dap_variables, { desc = "Dap variables" })
		vim.keymap.set("n", "<Leader>fdf", fzf.dap_frames, { desc = "Dap frames" })

		fzf.register_ui_select()

		-- TODO: do we need grep_project? How is it different from live_grep?

		-- not working as expected... has issue with newlines
		-- vim.keymap.set('v', '<Leader>fw', fzf.grep_visual, {desc = ""})
	end,
}

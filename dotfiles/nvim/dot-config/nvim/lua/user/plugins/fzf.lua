return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    local fzf = require('fzf-lua')

    fzf.setup({})

    vim.keymap.set('n', '<Leader>f;', fzf.builtin)
    vim.keymap.set('n', '<Leader>ff', fzf.files)
    vim.keymap.set('n', '<Leader>fh', fzf.help_tags)
    vim.keymap.set('n', '<Leader>fb', fzf.buffers)
    vim.keymap.set('n', '<Leader>fl', fzf.blines)
    vim.keymap.set('n', '<Leader>fL', fzf.lines)
    vim.keymap.set('n', '<Leader>fw', fzf.grep_project)
    vim.keymap.set('n', '<Leader>fW', fzf.live_grep)
    vim.keymap.set('n', '<Leader>ftw', fzf.grep_cword)
    vim.keymap.set('n', '<Leader>ftW', fzf.grep_cWORD)

    vim.keymap.set('n', '<Leader>fgf', fzf.git_files)
    vim.keymap.set('n', '<Leader>fgs', fzf.git_status)
    vim.keymap.set('n', '<Leader>fgc', fzf.git_commits)
    vim.keymap.set('n', '<Leader>fgh', fzf.git_bcommits)
    vim.keymap.set('n', '<Leader>fgb', fzf.git_branches)
    vim.keymap.set('n', '<Leader>fgS', fzf.git_stash)

    vim.keymap.set('n', '<Leader>flr', fzf.lsp_references)
    vim.keymap.set('n', '<Leader>fld', fzf.lsp_definitions)
    vim.keymap.set('n', '<Leader>flD', fzf.lsp_declarations)
    vim.keymap.set('n', '<Leader>flt', fzf.lsp_typedefs)
    vim.keymap.set('n', '<Leader>fli', fzf.lsp_implementations)
    vim.keymap.set('n', '<Leader>fls', fzf.lsp_document_symbols)
    vim.keymap.set('n', '<Leader>flS', fzf.lsp_workspace_symbols)
    vim.keymap.set('n', '<Leader>fla', fzf.lsp_code_actions)
    vim.keymap.set('n', '<Leader>flf', fzf.lsp_finder)
    vim.keymap.set('n', '<Leader>fln', fzf.lsp_incoming_calls)
    vim.keymap.set('n', '<Leader>flo', fzf.lsp_outgoing_calls)
    vim.keymap.set('n', '<Leader>fle', fzf.diagnostics_document)
    vim.keymap.set('n', '<Leader>flE', fzf.diagnostics_workspace)

    vim.keymap.set('n', '<Leader>fch', fzf.command_history)
    vim.keymap.set('n', '<Leader>fsh', fzf.search_history)
    vim.keymap.set('n', '<Leader>fr', fzf.registers)
    vim.keymap.set('n', '<Leader>fhl', fzf.highlights)
    vim.keymap.set('n', '<Leader>fj', fzf.jumps)
    vim.keymap.set('n', '<Leader>fcg', fzf.changes)
    vim.keymap.set('n', '<Leader>fk', fzf.keymaps)
    vim.keymap.set('n', '<Leader>fsp', fzf.spell_suggest)

    vim.keymap.set('n', '<Leader>fdc', fzf.dap_commands)
    vim.keymap.set('n', '<Leader>fdC', fzf.dap_configurations)
    vim.keymap.set('n', '<Leader>fdb', fzf.dap_breakpoints)
    vim.keymap.set('n', '<Leader>fdv', fzf.dap_variables)
    vim.keymap.set('n', '<Leader>fdf', fzf.dap_frames)

    fzf.register_ui_select()

    -- TODO: do we need grep_project? How is it different from live_grep?

    -- not working as expected... has issue with newlines
    -- vim.keymap.set('v', '<Leader>fw', fzf.grep_visual)
  end
}

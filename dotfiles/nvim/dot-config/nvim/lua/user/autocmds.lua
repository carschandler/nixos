local autocmd = vim.api.nvim_create_autocmd

autocmd("TermOpen", {
  callback = function()
    vim.opt.spell = false
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd.startinsert()
  end,
  desc = "Turn off line numbers, spellcheck for terminal mode",
})

autocmd("WinEnter", {
  pattern = { "term://*" },
  callback = function()
    vim.cmd.startinsert()
  end,
  desc = "Enter insert mode whenever entering a term window",
})

autocmd("WinEnter", {
  pattern = { "\\[dap-repl\\]" },
  callback = function()
    vim.cmd.startinsert()
    vim.opt.spell = false
    -- vim.opt.number = false
    -- vim.opt.relativenumber = false
  end,
  desc = "Enter insert mode whenever entering a dap window",
})

-- Automatically commit lockfile after running Lazy Update (or Sync)
-- autocmd("User", {
--   pattern = "LazyUpdate",
--   callback = function()
--     local repo_dir = os.getenv("HOME") .. "/nixos"
--     local lockfile = repo_dir .. "/dotfiles/nvim/dot-config/nvim/lazy-lock.json"
--
--     local cmd = {
--       "git",
--       "-C",
--       repo_dir,
--       "commit",
--       lockfile,
--       "-m",
--       "Update lazy-lock.json",
--     }
--
--     local success, process = pcall(function()
--       return vim.system(cmd):wait()
--     end)
--
--     if process and process.code == 0 then
--       vim.notify("Committed lazy-lock.json")
--       vim.notify(process.stdout)
--     else
--       if not success then
--         vim.notify("Failed to run command '" .. table.concat(cmd, " ") .. "':", vim.log.levels.WARN, {})
--         vim.notify(tostring(process), vim.log.levels.WARN, {})
--       else
--         vim.notify("git ran but failed to commit:")
--         vim.notify(process.stdout, vim.log.levels.WARN, {})
--       end
--     end
--   end,
-- })

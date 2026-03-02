local autocmd = vim.api.nvim_create_autocmd

autocmd("TermOpen", {
  callback = function()
    vim.opt.spell = false
    vim.opt.number = false
    vim.opt.relativenumber = false
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
  pattern = { "\\[dap-repl*\\]" },
  callback = function()
    vim.opt.spell = false
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
  desc = "Enter insert mode whenever entering a dap window",
})

-- NOTE: neither of the following trigger notifications... something in the
-- source code prevents them from being sent. There's a related GitHub
-- issue/discussion somewhere.

-- vim.opt.shortmess:append("A")
-- autocmd("SwapExists", {
--   callback = function()
--     vim.notify("Swapfile detected", vim.log.levels.WARN)
--   end,
-- })

-- vim.api.nvim_create_autocmd("SwapExists", {
--   pattern = "*",
--   desc = "Skip the swapfile prompt when the swapfile is owned by a running Nvim process",
--   group = vim.api.nvim_create_augroup("nvim.swapfile", {}),
--   callback = function()
--     local info = vim.fn.swapinfo(vim.v.swapname)
--     vim.notify("swapinfo" .. vim.inspect(info))
--     local user = vim.uv.os_get_passwd().username
--     local iswin = 1 == vim.fn.has("win32")
--
--     vim.notify("user" .. vim.inspect(user))
--     vim.notify("info.user" .. vim.inspect(info.user))
--     vim.notify("info.error" .. vim.inspect(info.error))
--     vim.notify("info.pid" .. vim.inspect(info.pid))
--     vim.notify("iswin" .. vim.inspect(info.pid))
--
--     if info.error or info.pid <= 0 or (not iswin and info.user ~= user) then
--       vim.v.swapchoice = "" -- Show the prompt.
--       return
--     end
--     vim.v.swapchoice = "e" -- Choose "(E)dit".
--     vim.notify(("W325: Ignoring swapfile from Nvim process %d"):format(info.pid), vim.log.levels.WARN)
--   end,
-- })

if vim.g.vscode then
  autocmd({ "VimEnter", "ModeChanged" }, {
    callback = function()
      require("vscode").call("setContext", { args = { "neovim.fullMode", vim.fn.mode(1) } })
    end,
  })
end

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

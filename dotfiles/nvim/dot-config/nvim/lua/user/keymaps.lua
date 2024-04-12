--          Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- Command        +------+-----+-----+-----+-----+-----+------+------+
-- [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

local km = vim.keymap.set

if not vim.g.vscode then
  if pcall(require, 'which-key') then
    require('which-key').register(
      {
        ss = {
          'set invspell',
        },
        q = {
          name = 'QuickFix',
        },
      },
      { prefix = '<Leader>' }
    )
  end
end

km({ 'n', 'v' }, '<Space>', ':')

km({ 'n', 'v' }, ';;', ';')

if vim.g.vscode then
  km('n', '<Leader><Space>', function()
    require("vscode-neovim").call("workbench.action.quickOpen")
  end)
end

-- Make Escape close floating windows
-- This may conflict with plugins though...
-- TODO: May need to check for filetype or something more specific to certain
-- windows OR exclude windows that need to ignore it...
km('n', '<Esc>', function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    vim.cmd.wincmd('c')
  else
    vim.cmd.normal("\\<Esc>")
  end
end)

-- System Clipboard Copy/Paste
km({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Copy to sys clipboard" })
km({ 'n', 'v' }, '<leader>p', '"+p', { desc = "Paste from sys clipboard" })

-- Easy paste in insert mode
km('i', '<M-p>', '<C-R>"', { desc = "Paste last delete/yank" })
km('i', '<C-M-p>', '<C-R>"', { desc = "Paste last yank exclusively" })

-- Don't copy x deletions to register
km({ 'n', 'v' }, 'x', '"_x', { desc = "Delete char to void" })
km({ 'n', 'v' }, 'X', '"_X', { desc = "Del char backward to void" })

-- Deletions that don't copy
km({ 'n', 'v' }, '<leader>d', '"_d', { desc = "Delete without copying" })
km({ 'n', 'v' }, '<leader>D', '"_D', { desc = "Delete without copying" })

-- QuickFix List
km('n', '<Leader>qn', function() pcall(vim.cmd, 'cn') end, { desc = "Next item in qfl" })
km('n', '<Leader>qp', function() pcall(vim.cmd, 'cp') end, { desc = "Prev item in qfl" })

local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win["quickfix"] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

km('n', '<Leader>qt', toggle_quickfix, { desc = "Toggle Quickfix Window" })
-- km('n', '<M-q>', toggle_quickfix, { desc = "Toggle Quickfix Window" })


-- km('n', '<Leader>qt', function()
--   vim.cmd('cn')
-- end)

km({'n', 'v'}, "zn", "1z=", {desc = "Quick spelling fix"})

-- Source current file
km('n', '<leader>so', ':so %<CR>', { desc = "Source current file" })

-- Toggle spellcheck
km('n', '<leader>ss', ':set invspell<CR>', { desc = "Toggle spellcheck" })

-- Maximize current window
km('n', '<leader>z', '<C-w>_<C-w>|', { desc = "Maximize window" })

-- Close current window
km('n', '<leader>c', '<C-w>c', { desc = "Close window" })

-- Show full path of current buffer
km('n', '<leader>fp', '1<C-g>', { desc = "Print buffer filepath" })
km('n', 'q:', '<NOP>')

-- Set text wrapping
km({ 'n', 'i' }, '<C-p>', function() vim.opt.formatoptions:append('t') end, { desc = "Wrap text" })
km({ 'n', 'i' }, '<C-M-p>', function() vim.opt.formatoptions:remove('t') end, { desc = "Don't wrap" })

if not vim.g.vscode then
  local tmux = require('tmux')

  if tmux ~= nil then
    -- Window Navigation on Corne Keyboard
    vim.keymap.set({ 'n', 't', '!' }, '<S-Left>', function()
      tmux.move_left()
    end, { desc = "Go to left window" })
    vim.keymap.set({ 'n', 't', '!' }, '<S-Down>', function()
      tmux.move_bottom()
    end, { desc = "Go to below window" })
    vim.keymap.set({ 'n', 't', '!' }, '<S-Up>', function()
      tmux.move_top()
    end, { desc = "Go to above window" })
    vim.keymap.set({ 'n', 't', '!' }, '<S-Right>', function()
      tmux.move_right()
    end, { desc = "Go to right window" })

    -- Window Navigation on QWERTY Keyboard
    vim.keymap.set({ 'n', 't', '!' }, '<M-H>', function()
      tmux.move_left()
    end, { desc = "Go to left window" })
    vim.keymap.set({ 'n', 't', '!' }, '<M-J>', function()
      tmux.move_bottom()
    end, { desc = "Go to below window" })
    vim.keymap.set({ 'n', 't', '!' }, '<M-K>', function()
      tmux.move_top()
    end, { desc = "Go to above window" })
    vim.keymap.set({ 'n', 't', '!' }, '<M-L>', function()
      tmux.move_right()
    end, { desc = "Go to right window" })
  else
    -- non-tmux window binds
    -- Corne
    km({ 'n', 't', '!' }, '<S-Left>', function()
      vim.cmd(vim.v.count .. "wincmd h")
    end, {desc = "Go to left window"})
    km({ 'n', 't', '!' }, '<S-Down>', function()
      vim.cmd(vim.v.count .. "wincmd j")
    end, {desc = "Go to below window"})
    km({ 'n', 't', '!' }, '<S-Up>', function()
      vim.cmd(vim.v.count .. "wincmd k")
    end, {desc = "Go to above window"})
    km({ 'n', 't', '!' }, '<S-Right>', function()
      vim.cmd(vim.v.count .. "wincmd l")
    end, {desc = "Go to right window"})

    -- QWERTY
    km({ 'n', 't', '!' }, '<M-H>', function()
      vim.cmd(vim.v.count .. "wincmd h")
    end, {desc = "Go to left window"})
    km({ 'n', 't', '!' }, '<M-J>', function()
      vim.cmd(vim.v.count .. "wincmd j")
    end, {desc = "Go to below window"})
    km({ 'n', 't', '!' }, '<M-K>', function()
      vim.cmd(vim.v.count .. "wincmd k")
    end, {desc = "Go to above window"})
    km({ 'n', 't', '!' }, '<M-L>', function()
      vim.cmd(vim.v.count .. "wincmd l")
    end, {desc = "Go to right window"})
  end

  -- Netrw automatically remaps Shift-Up/Down: change that
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    callback = function()
      km({ 'n', 't', '!' }, '<S-Down>', '<C-w>j', { buffer = true })
      km({ 'n', 't', '!' }, '<S-Up>', '<C-w>k', { buffer = true })
    end,
    desc = 'Unmap Shift-Up/Down netrw mappings'
  })

  -- Window Resizing on Corne Keyboard
  km({ 'n', 't', '!' }, '<C-Left>', function()
    vim.cmd(vim.v.count .. "wincmd <")
  end, {desc = "Resize window left"})
  km({ 'n', 't', '!' }, '<C-Down>', function()
    vim.cmd(vim.v.count .. "wincmd +")
  end, {desc = "Resize window down"})
  km({ 'n', 't', '!' }, '<C-Up>', function()
    vim.cmd(vim.v.count .. "wincmd -")
  end, {desc = "Resize window up"})
  km({ 'n', 't', '!' }, '<C-Right>', function()
    vim.cmd(vim.v.count .. "wincmd >")
  end, {desc = "Resize window right"})

  -- Window Resizing on QWERTY Keyboard
  km({ 'n', 't', '!' }, '<C-h>', function()
    vim.cmd(vim.v.count .. "wincmd <")
  end, {desc = "Resize window left"})
  km({ 'n', 't', '!' }, '<C-j>', function()
    vim.cmd(vim.v.count .. "wincmd +")
  end, {desc = "Resize window down"})
  km({ 'n', 't', '!' }, '<C-k>', function()
    vim.cmd(vim.v.count .. "wincmd -")
  end, {desc = "Resize window up"})
  km({ 'n', 't', '!' }, '<C-l>', function()
    vim.cmd(vim.v.count .. "wincmd >")
  end, {desc = "Resize window right"})

  -- Moving Windows on Corne Keyboard
  km({ 'n', 't', '!' }, '<M-Left>', function()
    vim.cmd(vim.v.count .. "wincmd H")
  end, {desc = "Move window left"})
  km({ 'n', 't', '!' }, '<M-Down>', function()
    vim.cmd(vim.v.count .. "wincmd J")
  end, {desc = "Move window down"})
  km({ 'n', 't', '!' }, '<M-Up>', function()
    vim.cmd(vim.v.count .. "wincmd K")
  end, {desc = "Move window up"})
  km({ 'n', 't', '!' }, '<M-Right>', function()
    vim.cmd(vim.v.count .. "wincmd L")
  end, {desc = "Move window right"})

  -- Moving Windows on QWERTY Keyboard
  km({ 'n', 't', '!' }, '<M-C-h>', function()
    vim.cmd(vim.v.count .. "wincmd H")
  end, {desc = "Move window left"})
  km({ 'n', 't', '!' }, '<M-C-j>', function()
    vim.cmd(vim.v.count .. "wincmd J")
  end, {desc = "Move window down"})
  km({ 'n', 't', '!' }, '<M-C-k>', function()
    vim.cmd(vim.v.count .. "wincmd K")
  end, {desc = "Move window up"})
  km({ 'n', 't', '!' }, '<M-C-l>', function()
    vim.cmd(vim.v.count .. "wincmd L")
  end, {desc = "Move window right"})

end

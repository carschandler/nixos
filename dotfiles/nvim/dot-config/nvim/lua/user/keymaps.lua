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

local wk = require('which-key')

wk.register(
  {
    s = {
      'source file',
    },
    q = {
      name = 'QuickFix',
    },
  },
  { prefix = '<Leader>' }
)

km({ 'n', 'v' }, '<Space>', ':')

km({ 'n', 'v' }, ';;', ';')

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

-- Don't copy x deletions to register
km({ 'n', 'v' }, 'x', '"_x', { desc = "Delete char to void" })
km({ 'n', 'v' }, 'X', '"_X', { desc = "Del char backward to void" })

-- Deletions that don't copy
km({ 'n', 'v' }, '<leader>d', '"_d', { desc = "Delete without copying" })
km({ 'n', 'v' }, '<leader>D', '"_D', { desc = "Delete without copying" })

-- QuickFix List
km('n', '<Leader>qn', function() vim.cmd('cn') end, { desc = "Next item in qfl" })
km('n', '<Leader>qp', function() vim.cmd('cn') end, { desc = "Prev item in qfl" })
-- km('n', '<Leader>qt', function()
--   vim.cmd('cn')
-- end)

-- Source current file
km('n', '<leader>so', ':so %<CR>', { desc = "Source current file" })

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

-- Window Navigation on Corne Keyboard
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

-- Netrw automatically remaps Shift-Up/Down: change that
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    km({ 'n', 't', '!' }, '<S-Down>', '<C-w>j', { buffer = true })
    km({ 'n', 't', '!' }, '<S-Up>', '<C-w>k', { buffer = true })
  end,
  desc = 'Unmap Shift-Up/Down netrw mappings'
})

-- Window Navigation on QWERTY Keyboard
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


-- Messed with this a bit... was trying to get t to behave like / on a single
-- character... worked decently well but then worrying about disabling
-- highlighting meant we needed to remap / as well and then that broke
-- everything... just going to stick with normal t

-- local search_char = function()
--   local keycode = vim.fn.getchar()
--   if keycode == 27 then
--     return
--   end
--   local key = vim.fn.nr2char(keycode)
--   local count = vim.v.count
--   if count == 0 then
--     count = 1
--   end
--   vim.cmd('exe "normal ' .. count .. '/' .. key .. [[\<CR>"]])
--   vim.cmd('noh')
-- end
--
-- vim.keymap.set('n', 't', search_char)
--
-- vim.keymap.set('n', '/', function ()
--   vim.opt.hlsearch = true
--   vim.api.nvim_feedkeys('/', 'n', true)
-- end)

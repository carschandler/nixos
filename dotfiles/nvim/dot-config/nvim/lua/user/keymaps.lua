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

vim.g.mapleader = ';'

local km = vim.keymap.set

km({ 'n', 'v' }, '<Space>', ':')

km({ 'n', 'v' }, ';;', ';')

-- System Clipboard Copy/Paste
km({ 'n', 'v' }, '<leader>y', '"+y', {desc = "Copy to sys clipboard"})
km({ 'n', 'v' }, '<leader>p', '"+p', {desc = "Paste from sys clipboard"})

-- Don't copy x deletions to register
km({ 'n', 'v' }, 'x', '"_x', {desc = "Delete char to void"})
km({ 'n', 'v' }, 'X', '"_X', {desc = "Del char backward to void"})

-- Deletions that don't copy
km({ 'n', 'v' }, '<leader>d', '"_d', {desc = "Delete without copying"})
km({ 'n', 'v' }, '<leader>D', '"_D', {desc = "Delete without copying"})

-- QuickFix List
km('n', '<Leader>qn', function() vim.cmd('cn') end, {desc = "Next item in qfl"})
km('n', '<Leader>qp', function() vim.cmd('cn') end, {desc = "Prev item in qfl"})
-- km('n', '<Leader>qt', function()
--   vim.cmd('cn')
-- end)

-- Source current file
km('n', '<leader>so', ':so %<CR>', {desc = "Source current file"})

-- Maximize current window
km('n', '<leader>z', '<C-w>_<C-w>|', {desc = "Maximize window"})

-- Close current window
km('n', '<leader>c', '<C-w>c', {desc = "Close window"})

-- Show full path of current buffer
km('n', '<leader>fp', '1<C-g>', {desc = "Print buffer filepath"})
km('n', 'q:', '<NOP>')

-- Set text wrapping
km({ 'n', 'i' }, '<C-p>', function() vim.opt.formatoptions:append('t') end, {desc = "Wrap text"})
km({ 'n', 'i' }, '<C-M-p>', function() vim.opt.formatoptions:remove('t') end, {desc = "Don't wrap"})

-- Window Navigation on Corne Keyboard
km({ 'n', 't', '!' }, '<S-Left>', '<C-w>h')
km({ 'n', 't', '!' }, '<S-Down>', '<C-w>j')
km({ 'n', 't', '!' }, '<S-Up>', '<C-w>k')
km({ 'n', 't', '!' }, '<S-Right>', '<C-w>l')

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
km({ 'n', 't', '!' }, '<M-H>', '<C-w>h')
km({ 'n', 't', '!' }, '<M-J>', '<C-w>j')
km({ 'n', 't', '!' }, '<M-K>', '<C-w>k')
km({ 'n', 't', '!' }, '<M-L>', '<C-w>l')
-- Window Resizing on Corne Keyboard
km({ 'n', 't', '!' }, '<C-Left>', '<C-w><')
km({ 'n', 't', '!' }, '<C-Down>', '<C-w>+')
km({ 'n', 't', '!' }, '<C-Up>', '<C-w>-')
km({ 'n', 't', '!' }, '<C-Right>', '<C-w>>')
-- Window Resizing on QWERTY Keyboard
km({ 'n', 't', '!' }, '<C-h>', '<C-w><')
km({ 'n', 't', '!' }, '<C-j>', '<C-w>+')
km({ 'n', 't', '!' }, '<C-k>', '<C-w>-')
km({ 'n', 't', '!' }, '<C-l>', '<C-w>>')
-- Moving Windows on Corne Keyboard
km({ 'n', 't', '!' }, '<M-Left>', '<C-w>H')
km({ 'n', 't', '!' }, '<M-Down>', '<C-w>J')
km({ 'n', 't', '!' }, '<M-Up>', '<C-w>K')
km({ 'n', 't', '!' }, '<M-Right>', '<C-w>L')
-- Moving Windows on QWERTY Keyboard
km({ 'n', 't', '!' }, '<M-C-h>', '<C-w>H')
km({ 'n', 't', '!' }, '<M-C-j>', '<C-w>J')
km({ 'n', 't', '!' }, '<M-C-k>', '<C-w>K')
km({ 'n', 't', '!' }, '<M-C-l>', '<C-w>L')


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

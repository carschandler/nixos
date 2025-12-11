return {
  "stevearc/oil.nvim",
  cond = not vim.g.vscode,
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    oil.setup({
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          return (name == "..")
        end,
      },
      float = {
        border = "rounded",
        padding = 5,
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["gp"] = {
          callback = function()
            vim.cmd.edit("$PLUGDIR")
          end,
          desc = "Open plugin directory",
        },
        ["'"] = {
          callback = function()
            vim.cmd.lcd(require("oil").get_current_dir())
          end,
          desc = "Open plugin directory",
        },
      },
    })
    vim.keymap.set("n", "<Leader>e", function()
      if vim.bo.filetype ~= "oil" then
        oil.open()
      else
        oil.close()
      end
    end, { desc = "Toggle file explorer" })
    vim.keymap.set("n", "<Leader>E", oil.open_float, { desc = "Explore in floating window" })
  end,
}

return {
  "j-hui/fidget.nvim",
  opts = function()
    vim.keymap.set("n", "<Leader>nh", function()
      require("fidget").notification.show_history()
    end, { desc = "Show notification history" })

    return {
      notification = {
        override_vim_notify = true,
        view = {},
        window = {
          winblend = 0,
        },
      },
    }
  end,
}

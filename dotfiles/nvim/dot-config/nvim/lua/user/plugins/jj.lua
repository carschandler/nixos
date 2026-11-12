return {
  "krisajenkins/neojj",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for async operations
  },
  config = function()
    local neojj = require("neojj")
    neojj.setup()

    vim.keymap.set("n", "<leader>js", neojj.jj_status, { desc = "JJ Status" })
    vim.keymap.set("n", "<leader>jl", neojj.jj_log, { desc = "JJ Log" })
  end,
}

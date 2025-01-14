return {
  "folke/which-key.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  -- init = function()
  --   vim.o.timeout = true
  --   vim.o.timeoutlen = 1000
  -- end,

  ---@class wk.Opts
  opts = {
    ---@type false | "classic" | "modern" | "helix"
    preset = "classic",

    -- show a warning when issues were detected with your mappings
    notify = true,

    delay = function(ctx)
      return ctx.plugin and 0 or 1000
    end,

    ---@type number|fun(node: wk.Node):boolean?
    expand = 1, -- expand groups when <= n mappings

    icons = {
      group = "", -- symbol prepended to a group
      --- See `lua/which-key/icons.lua` for more details
      --- Set to `false` to disable keymap icons from rules
      ---@type wk.IconRule[]|false
      rules = false,
    },
  },
}

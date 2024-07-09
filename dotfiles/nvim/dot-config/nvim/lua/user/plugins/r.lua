return {
  "R-nvim/R.nvim",
  ft = "rmd",
  opts = {
    rmdchunk = "``",
    hook = {
      on_filetype = function()
        -- This function will be called at the FileType event of files supported
        -- by R.nvim. This is an opportunity to create mappings local to
        -- buffers.
        vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
        vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true })
        -- vim.keymap.set("i", "**", )

        -- Increase the width of which-key to handle the longer r-nvim
        -- descriptions
        local wk = require("which-key")
        -- Workaround from
        -- https://github.com/folke/which-key.nvim/issues/514#issuecomment-1987286901
        wk.register({
          ["<localleader>"] = {
            a = { name = "+(a)ll", ["🚫"] = "which_key_ignore" },
            b = { name = "+(b)etween marks", ["🚫"] = "which_key_ignore" },
            c = { name = "+(c)hunks", ["🚫"] = "which_key_ignore" },
            f = { name = "+(f)unctions", ["🚫"] = "which_key_ignore" },
            g = { name = "+(g)oto", ["🚫"] = "which_key_ignore" },
            k = { name = "+(k)nit", ["🚫"] = "which_key_ignore" },
            p = { name = "+(p)aragraph", ["🚫"] = "which_key_ignore" },
            q = { name = "+(q)uarto", ["🚫"] = "which_key_ignore" },
            r = { name = "+(r) general", ["🚫"] = "which_key_ignore" },
            s = { name = "+(s)plit or (s)end", ["🚫"] = "which_key_ignore" },
            t = { name = "+(t)erminal", ["🚫"] = "which_key_ignore" },
            v = { name = "+(v)iew", ["🚫"] = "which_key_ignore" },
          },
        })
      end,
    },
  },
}

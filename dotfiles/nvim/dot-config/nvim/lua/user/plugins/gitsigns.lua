return {
  {
    "lewis6991/gitsigns.nvim",
    cond = not vim.g.vscode,
    opts = {
      on_attach = function(_bufnumber)
        if pcall(require, "which-key") then
          require("which-key").add({
            { "<Leader>g", group = "git" },
          })
        end
        vim.keymap.set("n", "]g", function()
          require("gitsigns").nav_hunk("next")
        end, { desc = "next hunk" })
        vim.keymap.set("n", "[g", function()
          require("gitsigns").nav_hunk("prev")
        end, { desc = "previous hunk" })
        vim.keymap.set("n", ";gp", function()
          require("gitsigns").preview_hunk_inline()
        end, { desc = "preview hunk" })
        vim.keymap.set("n", ";gP", function()
          require("gitsigns").preview_hunk()
        end, { desc = "preview hunk (windowed)" })
        vim.keymap.set("n", ";gr", function()
          require("gitsigns").reset_hunk()
        end, { desc = "reset hunk" })
        vim.keymap.set("n", ";gs", function()
          require("gitsigns").stage_hunk()
        end, { desc = "stage hunk" })
        vim.keymap.set("n", ";gb", function()
          require("gitsigns").blame()
        end, { desc = "blame" })
      end,
    },
  },
  -- {
  --   "evanphx/jjsigns.nvim",
  --   cond = not vim.g.vscode,
  --   opts = {
  --     enabled = true,
  --
  --     attach = {
  --       auto = true, -- Auto-attach to JJ repository files
  --     },
  --
  --     signs = {
  --       add = { text = "┃", numhl = "JjSignsAddNr", linehl = "JjSignsAddLn" },
  --       change = { text = "┃", numhl = "JjSignsChangeNr", linehl = "JjSignsChangeLn" },
  --       delete = { text = "▁", numhl = "JjSignsDeleteNr", linehl = "JjSignsDeleteLn" },
  --       topdelete = { text = "▔", numhl = "JjSignsDeleteNr", linehl = "JjSignsDeleteLn" },
  --       changedelete = { text = "~", numhl = "JjSignsChangeNr", linehl = "JjSignsChangeLn" },
  --     },
  --
  --     sign_priority = 6,
  --     signcolumn = true, -- Toggle with `:JjSigns toggle_signs`
  --     numhl = false, -- Toggle with `:JjSigns toggle_numhl`
  --     linehl = false, -- Toggle with `:JjSigns toggle_linehl`
  --
  --     -- JJ specific options
  --     base = "@-", -- Base revision to compare against (default: parent revision)
  --
  --     -- Performance options
  --     update_debounce = 100, -- Debounce time for updates in milliseconds
  --   },
  -- },
}

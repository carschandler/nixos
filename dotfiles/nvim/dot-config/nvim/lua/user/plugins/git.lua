return {
  { "tpope/vim-fugitive" },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      signs = {
        -- item = { "", "" },
        -- section = { "", "" },
        -- item = { "", "" },
        -- section = { "", "" },
        -- item = { "󰍟", "󰍝" },
        -- section = { "󰍟", "󰍝" },
        -- item = { "", "" },
        -- section = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      status = {
        mode_padding = 1,
        mode_text = {
          M = "󰷉",
          N = "󰻭",
          A = "󰸩",
          D = "󱀷",
          C = "󰬳",
          U = "󱈗",
          R = "󱀱",
          ["?"] = "󱀶",
          DD = "󰩌",
          DU = "󰩌",
          UD = "󰩌",
          AA = "󰩌",
          AU = "󰩌",
          UA = "󰩌",
          UU = "󰩌",
        },
      },
      mappings = {
        status = {
          ["="] = "Toggle",
        },
      },
    },
  },
}

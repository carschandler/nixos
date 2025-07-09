-- As of 7/2024, treesitter is doing a better job than semantic highlights, so
-- drop its priority down to 75 below treesitter's 100
-- Just going to directly address the individual highlights that aren't working
-- well...
-- vim.highlight.priorities.semantic_tokens = 75

return {
  "ellisonleao/gruvbox.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.o.background = "dark"
    vim.cmd("colorscheme gruvbox")
    vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "String" })
    vim.api.nvim_set_hl(0, "CmpItemKindConstant", { link = "Constant" })
    vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "debugPC", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "OilDir", { link = "GruvboxBlueBold" })
    vim.api.nvim_set_hl(0, "FlashMatch", { link = "GruvboxPurpleBold" })

    -- See my comment at
    -- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316?permalink_comment_id=5110169#gistcomment-5110169
    local hlgroups = {
      "@lsp.type.variable.python",
      "@lsp.type.variable.nix",
      "@lsp.type.variable.lua",
    }
    for _, hlgroup in ipairs(hlgroups) do
      vim.api.nvim_set_hl(0, hlgroup, {})
    end
  end,
  opts = {
    terminal_colors = false,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = false,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {
      -- String = {
      --   italic = false
      -- },
      Cursor = {
        reverse = true,
      },
      -- With blink.cmp, this was necessary when using transparent mode
      Pmenu = {
        bg = "none",
      },
      -- Transparent Mode makes borderless floating windows hard to view
      -- Enable this when using borderless, otherwise leave it out
      -- NormalFloat = {
      --   bg = "#3c3836",
      -- },
    },
    dim_inactive = false,
    transparent_mode = true,
  },
}

return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      require('gruvbox').setup(opts)
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
    opts = {
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
      palette_overrides = {
      },
      overrides = {
	      -- String = {
        --   italic = false
        -- },
        Cursor = {
           reverse = true,
        },
      },
      dim_inactive = false,
      transparent_mode = true,
    },
  },     
}

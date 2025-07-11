return {
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = "all",
      ignore_install = {
        "csv",
        "ipkg",
      },
      highlight = {
        enable = true,
        disable = { "latex" },
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          -- set to `false` to disable one of the mappings
          node_incremental = "v",
          node_decremental = "<M-v>",
          scope_incremental = "<C-M-v>", -- <C-BS> reads as <C-H>
        },
      },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "outer function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },

            ["aC"] = { query = "@class.outer", desc = "outer class" },
            ["iC"] = { query = "@class.inner", desc = "inner class" },

            ["aa"] = { query = "@parameter.outer", desc = "outer argument/parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "inner argument/parameter" },

            ["ab"] = { query = "@block.outer", desc = "outer block" },
            ["ib"] = { query = "@block.inner", desc = "inner block" },

            ["aS"] = { query = "@statement.outer", desc = "outer statement" },

            -- ["in"] = { query = "@scopename.inner", desc = "inner scopename" },

            -- You can also use captures from other query groups like `locals.scm`
            -- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          -- selection_modes = {
          --   ["@parameter.outer"] = "v",
          --   ["@function.outer"] = "V",
          --   ["@class.outer"] = "V",
          -- },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true of false
          include_surrounding_whitespace = true,
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
          -- Below will go to either the start or the end, whichever is closer.
          -- Use if you want more granular movements
          -- Make it even more gradual by adding multiple queries and regex.
        },
      },

      sync_install = true,
      auto_install = false,
      modules = {},
    })
  end,
}

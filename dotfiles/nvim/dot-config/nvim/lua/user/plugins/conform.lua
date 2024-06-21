return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        python = function()
          if vim.api.nvim_get_commands({})["PyrightOrganizeImports"] ~= nil then
            vim.cmd("PyrightOrganizeImports")
          end
          return { "black" }
        end,
        rust = { "rustfmt" },
        lua = { "stylua" },
      },

      formatters = {
        pyright_organize_imports = {},
      },

      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })

    conform.formatters.black = {
      prepend_args = {
        "--preview",
        "--enable-unstable-feature=string_processing",
      },
    }

    vim.keymap.set("n", "<Leader>lf", function()
      conform.format()
      if vim.o.filetype == "python" then
        vim.cmd("PyrightOrganizeImports")
        print(" ")
      end
    end, { desc = "Format buffer" })

    vim.keymap.set("n", "<M-F>", function()
      conform.format()
    end, { desc = "Format buffer" })
  end,
}

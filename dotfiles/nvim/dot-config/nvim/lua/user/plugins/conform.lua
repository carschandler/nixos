return {
  'stevearc/conform.nvim',
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "black" },
        rust = { "rustfmt" },
      },

      formatters = {
        black = {
          meta = {
            url = "https://github.com/psf/black",
            description = "The uncompromising Python code formatter.",
          },
          command = "black",
          args = {
            "--stdin-filename",
            "$FILENAME",
            "--quiet",
            "--preview",
            "--enable-unstable-feature=string_processing",
            "-",
          },
          cwd = require("conform.util").root_file({
            -- https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file
            "pyproject.toml",
          }),
        }
      },

      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })

    vim.keymap.set('n', '<Leader>lf', function()
      vim.lsp.buf.format { async = true }
      if vim.o.filetype == "python" then
        vim.cmd("PyrightOrganizeImports")
        print(" ")
      end
    end, { desc = 'Format buffer' })

    vim.keymap.set('n', '<M-F>', function()
      vim.lsp.buf.format { async = true }
    end, { desc = 'Format buffer' })
  end
}

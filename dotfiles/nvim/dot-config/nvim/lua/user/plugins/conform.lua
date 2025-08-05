return {
  "stevearc/conform.nvim",
  cond = not vim.g.vscode,
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        python = { "isort", "black" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        quarto = { "injected" },
        javascript = { "prettier" },
        json = { "prettier" },
        terraform = { "terraform_fmt" },
        typescript = { "prettier" },
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return { timeout_ms = 500, lsp_format = "fallback", async = false }
      end,
    })

    conform.formatters.black = {
      prepend_args = {
        "--preview",
        "--enable-unstable-feature=string_processing",
      },
    }

    conform.formatters.isort = {
      prepend_args = {
        "--profile",
        "black",
      },
    }

    conform.formatters.injected = {
      -- Set the options field
      options = {
        -- Set to true to ignore errors
        ignore_errors = false,
        -- Map of treesitter language to file extension
        -- A temporary file name with this extension will be generated during formatting
        -- because some formatters care about the filename.
        lang_to_ext = {
          bash = "sh",
          c_sharp = "cs",
          elixir = "exs",
          javascript = "js",
          julia = "jl",
          latex = "tex",
          markdown = "md",
          python = "py",
          ruby = "rb",
          rust = "rs",
          teal = "tl",
          r = "r",
          typescript = "ts",
        },
        -- Map of treesitter language to formatters to use
        -- (defaults to the value from formatters_by_ft)
        lang_to_formatters = {},
      },
    }

    vim.keymap.set("n", "<Leader>lf", function()
      conform.format({ async = true })
    end, { desc = "Format buffer" })
    vim.keymap.set("n", "<M-F>", function()
      conform.format({ async = true })
    end, { desc = "Format buffer" })

    -- Set commands to disable format-on-save temporarily
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    vim.api.nvim_create_user_command("W", function()
      vim.b.disable_autoformat = true
      vim.cmd.write()
    end, {
      desc = "Write without formatting",
    })
  end,
}

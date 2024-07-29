-- vim.api.nvim_create_autocmd("BufWritePre", {
--   callback = function(args)
--     if vim.bo[args.buf].filetype == "python" then
--       vim.cmd.bufdo("PyrightOrganizeImports")
--     end
--   end,
-- })

return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    -- local function pyright_organize_imports(bufnr)
    --   local params = {
    --     command = "pyright.organizeimports",
    --     arguments = { vim.uri_from_bufnr(bufnr) },
    --   }
    --
    --   local clients = require("lspconfig.util").get_lsp_clients({
    --     bufnr = bufnr,
    --     name = "pyright",
    --   })
    --   for _, client in ipairs(clients) do
    --     client.request("workspace/executeCommand", params, nil, 0)
    --   end
    -- end
    --
    conform.setup({
      formatters_by_ft = {
        -- python = function()
        --   pcall(pyright_organize_imports)
        --   -- pcall(nf)
        --   return { "black" }
        -- end,
        python = { "isort", "black" },
        rust = { "rustfmt" },
        lua = { "stylua" },
      },

      -- -- This doesn't work properly
      -- formatters = {
      --   pyright_organize_imports = {
      --     command = function()
      --       if vim.api.nvim_get_commands({})["PyrightOrganizeImports"] ~= nil then
      --         vim.cmd("PyrightOrganizeImports")
      --       end
      --       return "true"
      --     end,
      --   },
      -- },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if vim.bo[bufnr].filetype == "python" then
          pyright_organize_imports(bufnr)
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

    vim.keymap.set("n", "<Leader>lf", conform.format, { desc = "Format buffer" })
    vim.keymap.set("n", "<M-F>", conform.format, { desc = "Format buffer" })

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

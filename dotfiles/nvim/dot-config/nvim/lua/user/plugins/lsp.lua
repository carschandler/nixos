return {
  {
    'folke/neodev.nvim',
  },
  {
    'neovim/nvim-lspconfig',
    cond = not vim.g.vscode,

    config = function()
      -- Must set up neodev before LSP.
      require('neodev').setup({})

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local wk = require('which-key')

      -- Register which-key group for LSP keymaps
      wk.register(
        {
          l = {
            name = 'LSP',
            w = { 'workspace' },
          }
        },
        { prefix = '<Leader>' }
      )

      -- Set keymaps
      vim.keymap.set('n', '<Leader>ld', function()
        if vim.diagnostic.is_disabled() then
          vim.diagnostic.enable(0)
        else
          vim.diagnostic.disable(0)
        end
      end, { desc = "Toggle buffer diagnostics" })
      vim.keymap.set('n', '<Leader>li', require('lspconfig.ui.lspinfo'), { desc = "LSP info" })
      vim.keymap.set('n', '<Leader>le', vim.diagnostic.open_float, { desc = "Show diagnostics" })
      vim.keymap.set('n', '<M-k>', vim.diagnostic.open_float, { desc = "Show diagnostics" })
      vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set('n', '<Leader>lE', vim.diagnostic.setloclist, { desc = "Send diagnostics to location list" })


      -- Set lsp windows to be bordered
      local lsp_border = "rounded"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = lsp_border
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = lsp_border
        }
      )

      vim.diagnostic.config({
        float = {
          border = lsp_border
        }
      })

      -- Set up lspconfig.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev) -- passes the event object
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts_desc = function(d)
            return { buffer = ev.buf, desc = d }
          end

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts_desc('Go to declaration'))
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts_desc('Go to definition'))
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts_desc('Show hover pane'))
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts_desc('Go to implementation'))
          vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts_desc('LSP signature help'))
          vim.keymap.set('n', '<Leader>lwa', vim.lsp.buf.add_workspace_folder, opts_desc('Add workspace dir'))
          vim.keymap.set('n', '<Leader>lwr', vim.lsp.buf.remove_workspace_folder, opts_desc('Remove workspace dir'))
          vim.keymap.set('n', '<Leader>lwl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts_desc('List workspace dirs'))
          vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts_desc('Go to definiton of this type'))
          vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.rename, opts_desc('Rename symbol'))
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts_desc('Rename symbol'))
          vim.keymap.set({ 'n', 'v' }, '<Leader>la', vim.lsp.buf.code_action, opts_desc('Code actions'))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts_desc('Go to references'))
          vim.keymap.set('n', '<Leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, opts_desc('Format buffer'))
          vim.keymap.set('n', '<M-f>', function()
            vim.lsp.buf.format { async = true }
          end, opts_desc('Format buffer'))
          vim.keymap.set('n', '<M-F>', function()
            vim.lsp.buf.format { async = true }
          end, opts_desc('LSP format'))
        end,
      })

      -- Set up individual languages
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              -- Prevent the LS from prompting about workspace every time on
              -- startup
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
            -- Per neodev.nvim's instructions (?)
            completion = {
              callSnippet = "Replace"
            },
          }
        }
      }

      lspconfig.nil_ls.setup {}

      lspconfig.pyright.setup {
        capabilities = capabilities
      }

      lspconfig.tsserver.setup {}

      -- -- Set up format-on-save behavior via lsp-format.nvim
      -- vim.g.rustaceanvim = { server = { on_attach = require('lsp-format').on_attach } }


      -- efm-langserver is a general purpose LSP that is useful for linters &
      -- formatters
      lspconfig.efm.setup {
        filetypes = { 'python' },
        init_options = { documentFormatting = true },
        settings = {
          rootMarkers = { ".git/" },
          languages = {
            python = {
              { formatCommand = "black -q --preview --enable-unstable-feature=string_processing -", formatStdin = true }
            }
          }
        }
      }

      lspconfig.yamlls.setup {}

      lspconfig.bashls.setup {}


      -- lspconfig.rust_analyzer.setup {
      --   capabilities = capabilities
      -- }
    end
  },

  -- jdtls is its own beast, so it requires separate setup from lspconfig
}

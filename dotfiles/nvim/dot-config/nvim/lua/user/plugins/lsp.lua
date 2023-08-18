return {
  {
    'folke/neodev.nvim'
  },
  {
    'neovim/nvim-lspconfig',

    config = function()
      -- Must set up neodev before LSP.
      require('neodev').setup({})

      -- Set up lspconfig.
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local wk = require('which-key')

      wk.register(
        {
          l = {
            name = 'LSP',
            w = { 'workspace' },
          }
        },
        { prefix = '<Leader>' }
      )

      vim.keymap.set('n', '<Leader>lt', function()
        if vim.diagnostic.is_disabled() then
          vim.diagnostic.enable(0)
        else
          vim.diagnostic.disable(0)
        end
      end, { desc = "Toggle buffer diagnostics" })
      vim.keymap.set('n', '<Leader>le', vim.diagnostic.open_float, { desc = "Show diagnostics" })
      vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set('n', '<Leader>lE', vim.diagnostic.setloclist, { desc = "Send diagnostics to location list" })

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
          vim.keymap.set({'n', 'i'}, '<C-k>', vim.lsp.buf.signature_help, opts_desc('LSP signature help'))
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
        end,
      })

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

      lspconfig.nixd.setup {
        capabilities = capabilities
      }

      lspconfig.pyright.setup {
        capabilities = capabilities
      }

      lspconfig.rust_analyzer.setup {
        capabilities = capabilities
      }
    end
  },

  {
    'mfussenegger/nvim-jdtls',

    ft = 'java',

    config = function()
      local cfg = {
        cmd = {
          'jdt-language-server',
          '-data',
          os.getenv("HOME") .. '/.cache/jdtls/' .. os.getenv('PWD')
        },

        root_dir = vim.fs.dirname(
          vim.fs.find(
            { '.git', 'gradlew', 'mvnw', 'pom.xml' },
            { upward = true }
          )[1]
        ),

        -- Maven should handle the Java version, but here's an example of how to
        -- set it manually:

        -- settings = {
        --   java = {
        --     configuration = {
        --       runtimes = {
        --         {
        --           name = "JavaSE-1.8",
        --           path = os.getenv("JAVA_HOME")
        --         }
        --       }
        --     }
        --   }
        -- }
      }

      require('jdtls').start_or_attach(cfg)
    end
    -- ft = 'java',

    -- config = function ()
    --   print('$HOME/.cache/jdtls/' .. '$PWD')
    --   local cfg = {
    --     cmd = { 'jdt-language-server', '-data', '$HOME/.cache/jdtls/' .. '$PWD' },
    --     root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    --   }
    --   require('jdtls').start_or_attach(cfg)
    -- end,
  }
}

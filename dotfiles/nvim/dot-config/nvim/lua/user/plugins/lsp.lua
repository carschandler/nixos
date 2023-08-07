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

      vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, {desc = "Show diagnostics"})
      vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, {desc = "Previous diagnostic"})
      vim.keymap.set('n', ']e', vim.diagnostic.goto_next, {desc = "Next diagnostic"})
      vim.keymap.set('n', '<Leader>le', vim.diagnostic.setloclist, {desc = "Send diagnostics to location list"})

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev) -- passes the event object
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<Leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<Leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
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
              globals = {'vim'},
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

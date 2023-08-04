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

      lspconfig.rust_analyzer.setup {
        capabilities = capabilities
      }

      lspconfig.pyright.setup {
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

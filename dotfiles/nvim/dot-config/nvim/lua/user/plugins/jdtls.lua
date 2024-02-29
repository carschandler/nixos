return {
  'mfussenegger/nvim-jdtls',

  dependencies='mfussenegger/nvim-dap',

  cond = not vim.g.vscode,
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

      init_options = {
        bundles = {
          vim.fn.glob("$JAVA_DEBUG_PATH/**/com.microsoft.java.debug.plugin-*.jar", true)
        }
      },

      -- Should be able to determine the Java version from Maven, but here's an
      -- example of how to set it manually:

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
}

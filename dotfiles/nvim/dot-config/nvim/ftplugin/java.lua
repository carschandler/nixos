local cfg = {
  cmd = {
    'jdt-language-server',
    '-data',
    os.getenv("HOME") .. '/.cache/jdtls/' .. os.getenv('PWD')
  },

  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),

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

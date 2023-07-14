return {
  'neovim/nvim-lspconfig',

  config = function()
    -- Set up lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require('lspconfig')['rust_analyzer'].setup {
      capabilities = capabilities
    }
    require('lspconfig')['pyright'].setup {
      capabilities = capabilities
    }
  end
}

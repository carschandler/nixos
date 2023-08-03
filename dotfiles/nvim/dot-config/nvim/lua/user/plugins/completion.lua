return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- cmp sources
    'hrsh7th/cmp-nvim-lsp', -- Required
    'hrsh7th/cmp-buffer',   -- Optional
    'hrsh7th/cmp-path',     -- Optional
    'hrsh7th/cmp-cmdline',  -- Added
    'hrsh7th/cmp-nvim-lua', -- Optional
    'hrsh7th/cmp-nvim-lsp-signature-help',
    -- Snippets
    'L3MON4D3/LuaSnip',             -- Required
    'saadparwaiz1/cmp_luasnip',     -- Optional
    'rafamadriz/friendly-snippets', -- Optional

    -- {                                      -- Optional
    --    'williamboman/mason.nvim',
    --    build = function()
    --       pcall(vim.cmd, 'MasonUpdate')
    --    end,
    -- },
    -- {'williamboman/mason-lspconfig.nvim'}, -- Optional
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
      },
      window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
      mapping = {
        -- "Up"
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),

        -- "Down"
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- "Next"
        ['<C-n>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            cmp.complete()
            -- Can set a "reason" and a "config" for this to only invoke completion
            -- for certain sources
          end
        end),

        -- "Previous"
        ['<C-p>'] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          else
            cmp.complete()
          end
        end),

        -- "exiT"
        ['<C-t>'] = cmp.mapping.abort(),
        -- cmp.mapping.close() also exists, which will exit and leave any text that cmp
        -- generated up to that point

        -- cmp.mapping.complete_common_string() exists... only completes a
        -- string whose start matches some other existing one (like bash)

        -- Accept currently selected item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- "Insert"

        ['<C-i>'] = cmp.mapping.confirm({
          select = true,
          --behavior = cmp.ConfirmBehavior.Replace
        }),

        -- "Erase and insert" (replace)
        -- ['<C-e>'] = cmp.mapping.confirm({
        --   select = true,
        --   behavior = cmp.ConfirmBehavior.Replace
        -- }),

        --['<C-f>'] = cmp.mapping(function(fallback)
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, {'i', 's'}),

        --['<C-b>'] = cmp.mapping(function()
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<C-s>'] = cmp.mapping(function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end, { 'i', 's' }),

        --['<C-k>'] = cmp.mapping(function()
        --  if luasnip.expandable() then
        --    luasnip.expand()
        --  end
        --end),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
      }, {
        {
          name = 'buffer',
          keyword_length = 4
        },
        { name = 'path' },
      }),
      experimental = {
        ghost_text = true
      }
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}

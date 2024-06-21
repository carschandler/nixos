---@diagnostic disable: missing-fields
return {
  "hrsh7th/nvim-cmp",
  cond = not vim.g.vscode,
  dependencies = {
    -- cmp sources
    "hrsh7th/cmp-nvim-lsp", -- Required
    "hrsh7th/cmp-buffer",   -- Optional
    "hrsh7th/cmp-path",     -- Optional
    "hrsh7th/cmp-cmdline",  -- Added
    "hrsh7th/cmp-nvim-lua", -- Optional
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "petertriho/cmp-git",
    "rcarriga/cmp-dap",
    "R-nvim/cmp-r",
    -- Snippets
    "L3MON4D3/LuaSnip",             -- Required
    "saadparwaiz1/cmp_luasnip",     -- Optional
    "rafamadriz/friendly-snippets", -- Optional
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local cmp_kinds = {
      Text = '  ',
      Method = '  ',
      Function = '󰊕  ',
      Constructor = '  ',
      Field = '  ',
      Variable = '  ',
      Class = '  ',
      Interface = '  ',
      Module = '  ',
      Property = '  ',
      Unit = '  ',
      Value = '  ',
      Enum = '  ',
      Keyword = '  ',
      Snippet = '  ',
      Color = '  ',
      File = '  ',
      Reference = '  ',
      Folder = '  ',
      EnumMember = '  ',
      Constant = '  ',
      Struct = '  ',
      Event = '  ',
      Operator = '  ',
      TypeParameter = '  ',
    }

    -- For limiting the width of the results menu (see "formatting" below)
    local ELLIPSIS_CHAR = '…'
    local MAX_LABEL_WIDTH = 30
    local MIN_LABEL_WIDTH = 20

    cmp.setup({
      -- For cmp-dap
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
            or require("cmp_dap").is_dap_buffer()
      end,
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
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

        -- Scroll 4 at a time
        ['<C-f>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 4 })
          else
            fallback()
          end
        end),

        -- Scroll 4 at a time
        ['<C-b>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 4 })
          else
            fallback()
          end
        end),

        -- "Exit"
        ['<C-e>'] = cmp.mapping.abort(),
        -- cmp.mapping.close() also exists, which will exit and leave any text that cmp
        -- generated up to that point

        -- cmp.mapping.complete_common_string() exists... only completes a
        -- string whose start matches some other existing one (like bash)

        -- Accept currently selected item or the first in the list.
        -- Set `select` to `false` to only confirm explicitly selected items.
        -- "Insert"
        ['<C-i>'] = cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Insert
        }),

        -- Ctrl+Shift+I doesn't work because standard terminals can't detect
        -- this sequence
        ['<C-M-i>'] = cmp.mapping.confirm({
          select = true,
          behavior = cmp.ConfirmBehavior.Replace
        }),

        -- "Snippet"
        ['<C-S>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-S-S>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-M-S>'] = cmp.mapping(function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end, { 'i', 's' }),

        -- TODO: Do we need this for custom snippets? I think they should show up in
        -- our cmp menu like normal...
        --['<C-k>'] = cmp.mapping(function()
        --  if luasnip.expandable() then
        --    luasnip.expand()
        --  end
        --end),
      },
      window = {
        -- TODO: borders or no borders?
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),

        -- Ensure that cmp border is same color as default floating border
        completion = {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
          winhighlight = 'FloatBorder:FloatBorder',
        },
        documentation = {
          border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
          winhighlight = 'FloatBorder:FloatBorder',
        },
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'cmp_r' },
      }, {
        {
          name = 'buffer',
          keyword_length = 4
        },
        {
          name = 'path',
          option = {
            -- Default is to use the dirname() of the current buffer; we want
            -- the value returned by pwd
            get_cwd = function(_)
              return vim.fn.getcwd()
            end
          },
        },
      }),
      experimental = {
        ghost_text = true
      },
      formatting = {
        format = function(_, vim_item)
          -- Truncate the details section of the entries if too large
          local details_window_fraction = 0.4
          local max_width = math.floor(
            vim.api.nvim_win_get_width(0) * details_window_fraction
          )
          if vim_item.menu ~= nil and string.len(vim_item.menu) >= max_width then
            vim_item.menu = vim.fn.strcharpart(
              vim_item.menu, 0, max_width
            ) .. ELLIPSIS_CHAR
          end

          vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind

          return vim_item
        end,
      },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
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

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'dcampos/nvim-snippy',
    },
    config = function()
      local cmp = require('cmp')
      local snippy = require('snippy')
      local opts = {
        preselect = {
          none = true,
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'snippy' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping(function(original)
            if cmp.visible() then
              if snippy.can_expand() then
                snippy.expand()
              else
                cmp.confirm({ select = true })
              end
            else
              original()
            end
          end),
          ['<C-n>'] = cmp.mapping(function(original)
            if snippy.can_jump(1) then
              snippy.next()
            elseif cmp.visible() then
              cmp.select_next_item()
            else
              original()
            end
          end, {'i', 's'}),
          ['<C-p>'] = cmp.mapping(function(original)
            if snippy.can_jump(-1) then
              snippy.previous()
            elseif cmp.visible() then
              cmp.select_prev_item()
            else
              original()
            end
          end, {'i', 's'}),
        }),
        snippet = {
          expand = function(args)
            require 'snippy'.expand_snippet(args.body)
          end,
        },
      }
      cmp.setup(opts)
    end,
  },
  {'hrsh7th/cmp-nvim-lsp', lazy = true },
  {'hrsh7th/cmp-path', lazy = true },
  {'hrsh7th/cmp-buffer', lazy = true },
  {'dcampos/cmp-snippy', lazy = true },
}

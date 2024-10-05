return {
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  config = function()
    require('lspsaga').setup({
      vim.api.nvim_set_keymap('n', '<Leader>k', ':Lspsaga code_action<CR>', { noremap = true, silent = true }),
      vim.api.nvim_set_keymap('n', 'gd', ':Lspsaga peek_definition<CR>', { noremap = true, silent = true }),
      vim.api.nvim_set_keymap('n', 'gD', ':Lspsaga peek_type_definition<CR>', { noremap = true, silent = true }),
      vim.api.nvim_set_keymap('n', 'gh', ':Lspsaga hover_doc<CR>', { noremap = true, silent = true }),
      vim.api.nvim_set_keymap('n', 'gn', ':Lspsaga rename<CR>', { noremap = true, silent = true }),
      vim.api.nvim_set_keymap('n', 'gr', ':Lspsaga finder<CR>', { noremap = true, silent = true }),
      lightbulb = {
        enable = false,
      },
    })
  end,
}

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(buffer)
      local gitsigns = require('gitsigns')
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- define keymap
      map('n', '<leader>b', function() gitsigns.blame_line { full = true } end)
    end,
  },
}

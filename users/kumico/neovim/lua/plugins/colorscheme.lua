return {
    "devoc09/lflops.nvim",
    config = function()
      require('lflops').setup({
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
      })
      -- colorscheme
      vim.opt.background = "dark"
      vim.cmd("colorscheme lflops")
    end,
}

-- if development in local
-- return {
--   dir = '/home/kumico/go/src/github.com/devoc09/lflops.nvim',
--   config = function()
--     vim.cmd('')
--   end,
-- }

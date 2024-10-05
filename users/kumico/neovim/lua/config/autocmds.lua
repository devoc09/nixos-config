-- neovim-remote
local nvrcmd = "nvr --remote-wait"
vim.g.VISUAL = nvrcmd
vim.g.GIT_EDITOR = nvrcmd

vim.api.nvim_set_keymap('n', 'ts', '', { noremap = true, silent = true, callback = tig_status })

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"gitcommit", "gitrebase", "gitconfig"},
  callback = function()
    vim.bo.bufhidden = "delete"
  end,
})

local function split_type()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0) * 2.1
  if height > width then
    return 'split'
  else
    return 'vsplit'
  end
end

local function open_term(cmd)
  vim.opt.swapfile = false
  vim.opt.buflisted = false
  local split = split_type()

  vim.api.nvim_command(split .. ' term://' .. cmd)
end

local function tig_status()
  open_term('tig status')
end

-- set nonumber when temrinal open
vim.api.nvim_create_autocmd({'TermOpen'}, {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
  end
})


-- Split window
vim.api.nvim_set_keymap('n', 'ss', ':split<Return><C-w>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'sv', ':vsplit<Return>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'st', ':tabnew<Return>', { noremap = true, silent = true })

-- Remap keys
vim.api.nvim_set_keymap('n', '<Left>', '<C-w><<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Right>', '<C-w>><CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Up>', '<C-w>+<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Down>', '<C-w>-<CR>', { noremap = true })
vim.api.nvim_set_keymap('t', ';;', '<C-\\><C-n>', { noremap = true })
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<C-Y>", { noremap = true })
vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<C-E>", { noremap = true })

-- Move windows
vim.api.nvim_set_keymap('n', 'sh', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', 'sk', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', 'sj', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', 'sl', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-i>', '<C-i>', { noremap = true })
vim.api.nvim_set_keymap('n', '<CR><CR>', '<C-w>w', { noremap = true })

-- Switch tabs
vim.api.nvim_set_keymap('n', '<S-Tab>', 'gT', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', 'gt', { noremap = true, silent = true })

-- quickfix window
vim.api.nvim_set_keymap("n", "<C-j>", ":cnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":cprev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":cclose<CR>", { noremap = true, silent = true })

-- Set cmdheight
vim.o.cmdheight = 1

-- Use Terminal shortcut
vim.cmd([[
  autocmd TermOpen * startinsert
  function! s:Openterm() abort
    let w = winwidth(win_getid())
    let h = winheight(win_getid()) * 2.1
    if h > w
      exe 'split'
      exe 'term'
    else
      exe 'vsplit'
      exe 'term'
    endif
  endfunction
  nmap <silent> tt :<C-u>silent call <SID>Openterm()<CR>
]])

-- Clear all buffers
function clearBuffers()
  local buffers = vim.api.nvim_list_bufs()

  for _, buffer in ipairs(buffers) do
    if vim.api.nvim_buf_get_option(buffer, "modified") then
      print("Buffer " .. buffer .. "has unsaved changes")
    else
      vim.api.nvim_buf_delete(buffer, { force = true })
    end
  end
end

vim.api.nvim_set_keymap('n', '<Leader>cl', ':lua clearBuffers()<cr>', { noremap = true, silent = true })

-- yank current buffer file path
vim.api.nvim_set_keymap('n', ';c', ':let @0=expand("%:p")<CR>', { noremap = true, silent = true })

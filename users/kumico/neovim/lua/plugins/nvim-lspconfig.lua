return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    vim.opt.hidden = true
    local nvim_lsp = require("lspconfig")

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

      -- Mappings.
      local opts = { noremap = true, silent = true }
      -- buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      -- buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      -- buf_set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type()<CR>", opts)
      -- buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      -- buf_set_keymap("n", "<Leader>k", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      -- buf_set_keymap("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

      -- format on save
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("Format", { clear = true }),
          buffer = bufnr,
          callback = function() vim.lsp.buf.format(nil, nil, true, nil, nil, nil) end
        })
      end
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    nvim_lsp['gopls'].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "gopls", "serve" },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
        },
      },
    }
    nvim_lsp['rust_analyzer'].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          diagnostic = { enable = false, }
        }
      },
    }
    nvim_lsp['lua_ls'].setup {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';')
          },
          workspace = {
            checkThirdParty = false,
            library = { [vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true },
          },
        }
      },
    }

    -- format on save
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      pattern = { '*.lua', '*.rs' },
      callback = function() vim.lsp.buf.format({ timeout = 1500, async = false }) end,
    })

    -- imports & format on save
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      pattern = { '*.go' },
      callback = function(args)
        vim.lsp.buf.code_action({
          context = { only = { 'source.organizeImports' } },
          apply = true
        })
        vim.wait(100)
        vim.lsp.buf.format({ timeout = 1500, async = false })
      end,
    })
  end,
}

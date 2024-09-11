{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  #------------------------------------------------
  # Neovim plugins
  #------------------------------------------------
  lflops = pkgs.vimUtils.buildVimPlugin {
    name = "lflops.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "devoc09";
      repo = "lflops.nvim";
      rev = "main";
      sha256 = "sha256-GEAKmySAJw6p9xNqdGVWsTjP4NrgcbrBFSWzNcpyY1U=";
    };
  };
  gitsigns = pkgs.vimUtils.buildVimPlugin {
    name = "gitsigns.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      rev = "main";
      sha256 = "sha256-s3y8ZuLV00GIhizcK/zqsJOTKecql7Xn3LGYmH7NLsQ=";
    };
  };
  lualine = pkgs.vimUtils.buildVimPlugin {
    name = "lualine.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "master";
      sha256 = "sha256-gCm7m96PkZyrgjmt7Efc+NMZKStAq1zr7JRCYOgGDuE=";
    };
  };
in {
  home.username = "kumico";
  home.homeDirectory = "/home/kumico";

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 100;
    x11.enable = true;
  };

  xdg.enable = true;

  # Disable warning
  home.enableNixpkgsReleaseCheck = false;

  # Add PATH
  home.sessionPath = [
    "$HOME/go/bin"
  ];

  #------------------------------------------------
  # Packages
  #------------------------------------------------

  home.packages = with pkgs; [
    fzf
    htop
    jq
    ripgrep
    tree
    firefox
    bat
    fd
    rofi
    tig
  ];

  #------------------------------------------------
  # Env vars & dotfiles
  #------------------------------------------------

  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3;
    "tig/config".text = builtins.readFile ./tigrc;
  };

  #------------------------------------------------
  # Programs
  #------------------------------------------------

  programs.git = {
    enable = true;
    userName = "Takumi Katase";
    userEmail = "takumi.katase@devoc.ninja";
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
      commit.gpgsign = true;
      ghq.root = "~/go/src";
      user.signingkey = "~/.ssh/id_rsa.pub";
      url."git@github.com:".insteadOf = "https://github.com";
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  programs.bash = {
    enable = true;
    shellOptions = [];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);
    shellAliases = {
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -o -selection clipboard";
      glog = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.i3status = {
    enable = true;
    general = {
      colors = true;
    };
    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    extraLuaConfig = ''
      --------------------------------------------------------
      -- Options
      --------------------------------------------------------

      vim.o.encoding = "utf-8"
      vim.o.fileformat = "unix"
      vim.o.fileencoding = "utf-8"
      vim.o.mouse = "a"
      vim.o.foldenable = false
      vim.o.wildmenu = true
      vim.o.completeopt = "menu,menuone,noinsert,noselect"
      vim.o.number = false
      vim.o.cursorline = true
      -- vim.o.clipboard = 'unnamed'
      vim.o.belloff = 'all'
      vim.o.scrolloff = 999 -- Keep the cursor centered in the screen

      -- enable set number
      vim.cmd('set number')

      -- Tab and Indentation
      vim.o.autoindent = true  -- Continue indent of the previous line on newline
      vim.o.smartindent = true -- Auto-insert indentation according to syntax
      vim.o.shiftwidth = 4     -- Indentation amount for < and > commands
      vim.o.tabstop = 4        -- Number of spaces that a tab in the file counts for
      vim.o.expandtab = true   -- Convert tabs to spaces

      -- String search settings
      vim.o.incsearch = true  -- Incremental search, searching as you type
      vim.o.ignorecase = true -- Case insensitive searching
      vim.o.smartcase = true  -- Case sensitive if search pattern contains uppercase
      vim.o.hlsearch = true   -- Highlight search results

      -- window split config
      vim.o.splitright = true

      -- statusline & tabline
      vim.o.showtabline = 1
      vim.o.laststatus = 3

      -- guicolors
      if os.getenv("COLORTERM") ~= nil then
        vim.o.termguicolors = true
          end

          vim.o.colorcolumn = "100" -- Highlight 100 character limit

          --------------------------------------------------------
          -- File types
          --------------------------------------------------------

          vim.api.nvim_create_autocmd("FileType", {
              pattern = { "go", "python", "c", "zig", "rust" },
              callback = function()
              vim.opt_local.autoindent = true
              vim.opt_local.smartindent = true
              vim.opt_local.expandtab = true
              vim.opt_local.tabstop = 4
              vim.opt_local.softtabstop = 4
              vim.opt_local.shiftwidth = 4
              end,
              })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "vim", "lua", "sh", "nix" },
        callback = function()
        vim.opt_local.autoindent = true
        vim.opt_local.smartindent = true
        vim.opt_local.expandtab = true
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        end,
      })

      -- disable automatic comment text at line breaks.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
        vim.opt_local.formatoptions:remove { 'r', 'o' }
        end,
      })

      --------------------------------------------------------
      -- Keymaps
      --------------------------------------------------------

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

      --------------------------------------------------------
      -- Plugins
      --------------------------------------------------------

      -- colorscheme
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

      -- Git
      gitsigns = require('gitsigns').setup({
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end
          map('n', '<leader>b', function() gitsigns.blame_line { full = true } end)
        end
      })

      -- StatusLine
      require('lualine').setup {
        options = {
          theme = 'auto',
        },
      }

    '';
    plugins = with pkgs; [
      vimPlugins.nvim-treesitter
      vimPlugins.nvim-web-devicons

      # custom plugins
      lualine
      lflops
      gitsigns
    ];
  };

  programs.go = {
    enable = true;
    goPath = "go";
  };

  programs.keychain = {
    enable = true;
  };

  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

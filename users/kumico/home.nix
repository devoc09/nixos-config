{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
    zigpkgs."master"
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
  };

  xdg.configFile."nvim" = {
    source = ./neovim;
    recursive = true;
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

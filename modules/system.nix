{
  config,
  pkgs,
  nixpkgs-unstable,
  inputs,
  ...
}: {
  # Since we're using fish as our shell
  programs.fish.enable = true;

  users.users.kumico = {
    isNormalUser = true;
    description = "kumico";
    extraGroups = ["wheel"];
    home = "/home/kumico";
    shell = pkgs.fish;
    hashedPassword = "$6$HrH5dJg3trLIzHgK$MzI8s39g6iN4FHwbi8y11XrLJMtriKTCJ21aUwOXJOJMjc362FZfZ./6dNJtZDYl8sTUW5zpumJtpMqX7ANJ9/";
  };

  # Set my time zone
  time.timeZone = "Asia/Tokyo";

  # Set internationalisation properties
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    dpi = 220;
    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
      runXdgAutostartIfNone = true;
    };

    displayManager = {
      lightdm.enable = true;

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 220 40
      '';
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # Application launcher
        i3status # Status bar
        i3lock # Screen locker
      ];
    };
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Manage fonts
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      "${pkgs.fetchzip {
        url = "https://github.com/yuru7/udev-gothic/releases/download/v2.0.0/UDEVGothic_NF_v2.0.0.zip";
        sha256 = "00zw8yr9zl27v98sav4dwwrhvrzfrl3y0bzzyqq2nnx5i3jayy5v";
      }}"
    ];
  };

  # Install packages in global
  environment.systemPackages = [
    pkgs.wget
    pkgs.curl
    pkgs.git
    pkgs.xclip
    pkgs.gnumake

    # This is needed for the vmware user tools clipboard to work.
    # You can test if you don't need this by deleting this and seeing
    # if the clipboard sill works.
    pkgs.gtkmm3

    # for setup c compiler & cross compiling
    pkgs.gcc

    # For hypervisors that support auto-resize, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (pkgs.writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];
}

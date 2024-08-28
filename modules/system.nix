{ config, pkgs, pkgs-2405, inputs, ...}: {
    # Since we're using fish as our shell
    programs.fish.enable = true;

    users.users.kumico = {
        isNormalUser = true;
        description = "kumico";
        extraGroups = [ "wheel" ];
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
            fcitx5.addons = [pkgs.fcitx5-mozc];
            fcitx5.waylandFrontend = true;
        };
    };

    services.xserver = {
        enable = true;
        xkb.layout = "us";
        desktopManager = {
            xterm.enable = false;
        };
        displayManager = {
            defaultSession = "none+i3";
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

    # Add ~/.local/bin to PATH
    environment.localBinInPath = true;

    # Install packages in global
    environment.systemPackages = [
        pkgs.wget
        pkgs.curl
        pkgs.git
        pkgs.firefox
        pkgs.xclip
    ];
}

{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/system.nix
    ../modules/vmware-guest.nix

    # bellow files created by nixos-generate-config command
    ../configuration.nix
    ../hardware-configuration.nix
  ];

  # Disable the default module and import our override. We have
  # customizations to make this work on aarch64.
  disabledModules = ["virtualisation/vmware-guest.nix"];

  # This work through our custom module imported above
  virtualisation.vmware.guest.enable = true;

  boot.loader = {
    # Use the systemd-boot EFI boot loader
    systemd-boot.enable = true;
    systemd-boot.consoleMode = "0";

    # VMware, Parallels both only support this being 0 otherwise you see
    # "error switching console mode" on boot.
    efi.canTouchEfiVariables = true;
  };

  # Define hostname
  networking.hostName = "dev";

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
}

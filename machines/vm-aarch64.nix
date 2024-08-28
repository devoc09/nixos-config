{ config, pkgs, ... }: {
    imports = [
        ../modules/system.nix
        ../modules/vmware-guest.nix

        # bellow files created by nixos-generate-config command
        ../configuration.nix
        ../hardware-configuration.nix
    ];

    # Disable the default module and import our override. We have
    # customizations to make this work on aarch64.
    disabledModules = [ "virtualisation/vmware-guest.nix" ];

    # This work through our custom module imported above
    virtualisation.vmware.guest.enable = true;
}

{
    description = "NixOS systems and tools by kumico";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";

        # neovim-nightly-overlay = {
        #     url = "github:nix-community/neovim-nightly-overlay";
        # };

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-2405, home-manager, ... }@inputs:
    {
        nixosConfigurations = {
            vm-aarch64 = nixpkgs.lib.nixosSystem rec {
                system = "aarch64-linux";
                specialArgs = {
                    pkgs-2405 = import nixpkgs-2405 {
                        inherit system;
                        config.allowUnfree = true;
                    };
                };
                modules = [
                    ./machines/vm-aarch64.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.kumico = import ./users/kumico/home.nix;
                    }
                ];
            };
        };
    };
}

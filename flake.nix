{
    description = "NixOS systems and tools by kumico";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nixpkgs-2405.url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    outputs = inputs@{ self, nixpkgs, nixpkgs-2405, ... }: {
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
                ];
            };
        };
    };
}

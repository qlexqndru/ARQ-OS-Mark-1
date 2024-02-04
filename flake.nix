{
    description = "ARQ Nix configuration";

    nixConfig.bash-prompt = "❄ nix-develop > ";

    inputs = {

        nixpkgs.url = "nixpkgs/nixos-unstable";
        nixpkgs-master.url = "github:nixos/nixpkgs/master";

        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
            system = "x86_64-linux";

            pkgs = import nixpkgs {
                inherit system;
                config = {
                    allowUnfree = true;
                    allowBroken = true;
                };
            };

            flakeLib = import ./flake {
                inherit self inputs;
            };

            inherit (flakeLib) mkSystem;

        in
        {
            nixosModules.default = import ./modules/module.nix inputs { };
            homeManagerModules.default = import ./modules/hm-module.nix inputs { };

            packages = {
                hm-docs = pkgs.callPackage ./pkgs/hm-docs.nix { inherit nixpkgs; };
                nixos-docs = pkgs.callPackage ./pkgs/nixos-docs.nix { inherit nixpkgs; };
            };

            nixosConfigurations = {

                x = mkSystem {
                    inherit pkgs system;
                    username = "x";
                    hostname = "x";
                    machine = "xE14";
                };

                xS = mkSystem {
                    inherit pkgs system;
                    username = "x";
                    hostname = "xS";
                    machine = "xTC";
                };

                xM = mkSystem {
                    inherit pkgs system;
                    username = "x";
                    hostname = "xM";
                    machine = "xM12";
                };
            };
        };
}

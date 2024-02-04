{ self, inputs }:

let

    inherit (inputs) home-manager nixpkgs hyprland;

in

{

    mkSystem = { hostname, machine, pkgs ? nixpkgs, system ? "x86_64-linux", extraModules ? [ ], ... }@args:

        nixpkgs.lib.nixosSystem {
            inherit system pkgs;

            modules = [
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.x = { config, pkgs, ... }: {
                        imports = [
                            (hyprland.homeManagerModules.default)
                            (self.outputs.homeManagerModules.default)
                            ("${self}/hosts/${hostname}/home.nix")
                        ];
                    };
                    home-manager.extraSpecialArgs = {
                        inherit inputs;
                    };
                }
                ({ config, pkgs, ... }: {
                    imports = [
                        (self.outputs.nixosModules.default)
                        ("${self}/machines/${machine}")
                        ("${self}/hosts/${hostname}/nixos.nix")
                    ] ++ extraModules;
                    networking.hostName = hostname;
                })
            ];

            specialArgs = {
                inherit inputs;
            };
        };

}
inputs: { ... }:

{
  imports = [
    ./nixos/options.nix
    (import ./nixos/common.nix inputs)
    ./nixos/desktop-xhyprland.nix
    ./nixos/desktop-xShyprland.nix
  ];
}
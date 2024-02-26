inputs: { ... }:

{
  imports = [
    ./hm-modules/options.nix
    (import ./hm-modules/common.nix inputs)
    ./hm-modules/desktop-xhyprland.nix
    ./hm-modules/desktop-xShyprland.nix
    ./hm-modules/desktop-tools.nix
    (fetchGit { url = "https://github.com/cornerman/shadow-nix"; ref = "refs/tags/v2.0.0"; } + "/import/home-manager.nix")
  ];
}
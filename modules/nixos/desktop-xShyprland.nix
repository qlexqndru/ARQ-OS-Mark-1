{ config, lib, pkgs, ... }:

let

  cfg = config.x;

in

{
    config = lib.mkIf (cfg.desktop == "xShyprland") {

    # Enable network manager
    networking.networkmanager.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Fix gtklock
    security.pam.services.gtklock = { };

    # Login handled by greetd and tuigreet
    services.greetd = {
      enable = (!cfg.disableLoginManager);
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };

    programs.hyprland = {
      enable = true;
    };

    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [

      pamixer
      brightnessctl
      wl-clipboard
      wl-gammarelay-rs

    ];
  };
}
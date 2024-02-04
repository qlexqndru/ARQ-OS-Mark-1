{ config, lib, ... }:

{

  options.x = {
    desktop = lib.mkOption {
      type = lib.types.enum [
        "none"
        "xhyprland"
        "xShyprland"
      ];

      default = "xhyprland";
      description = lib.mdDoc ''
        Which desktop environment to use, if any.
      '';
    };

    gitSigningKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = lib.mdDoc ''
        Git signing key, can be omitted using null value.

        > If using subkey, remember to append `!` to key ID.
      '';
    };

    disableGPG =
    lib.mkEnableOption null
    // {
      default = false;
      description = lib.mdDoc ''
        Disable GPG, can be useful on server or live host.
      '';
    };

    disableNerdfonts =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable nerdfonts, useful when system is supposed to be deployed with deploy-rs.
        '';
      };

    waylandTools =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable collection of useful wayland tools.

          Wayland tools includes:
          - imv (image viewer)
          - sioyek (pdf viewer)
        '';
      };
  };
}
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
        Which desktop to use, if any.
      '';
    };

    disableLoginManager =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Disable login manager.
        '';
      };

    autoLoginUser = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "retro";
      description = ''
        Enable autologin for user.
      '';
    };

    remoteLogon =
      lib.mkEnableOption null
      // {
        default = false;
        description = lib.mdDoc ''
          Enable SSH.
        '';
      };
  };
}

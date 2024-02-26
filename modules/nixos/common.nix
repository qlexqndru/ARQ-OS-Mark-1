inputs: { config, lib, pkgs, ... }:



let

  cfg = config.x;

in

{

  

  config = {

    assertions = [
      {
        assertion = builtins.elem cfg.desktop [ "none" "xhyprland" "xShyprland" ];
        message = "x.desktop got invalid value.";
      }
    ];

    

    system.stateVersion = lib.mkDefault "23.11";

    nix = {
      package = pkgs.nixUnstable;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      registry.nixpkgs.flake = inputs.nixpkgs;
      settings = {
        trusted-users = [ "@wheel" ]; # allow users with sudo access run nix commands without sudo
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    console.keyMap = "us";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # Firewall.
    networking.firewall.enable = false;

    # Users.
    users.users.x = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "adbusers"
        "libvirtd"
      ];
    };


    # System packages.
    environment.systemPackages = with pkgs; [
      debootstrap
    ] ++ lib.optionals (cfg.desktop != "none") [
      gparted
      ventoy-full
      btop
      zip
      unzip
      xfce.thunar
      linuxKernel.packages.linux_6_7.cpupower
      libva-utils
      libvdpau
    ];

      # Hardware drivers
    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Thunar.
    programs.thunar.enable = true;
    programs.xfconf.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
    ];

    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

    services.mullvad-vpn.enable = true;


    # ZSH.
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      shellAliases = {
          ll = "ls -l";
          rebuild = "sudo cp -r /home/x/ARQ.os/* /etc/nixos/ && sudo nixos-rebuild switch";
          update = "sudo nixos-rebuild switch";
      };

      histSize = 10000;
      histFile = "~/.zsh/history";
      
      ohMyZsh = {
          enable = true;
          theme = "kardan";
      };
    };
  };
}
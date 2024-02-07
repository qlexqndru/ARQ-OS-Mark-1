inputs: { config, lib, pkgs, ... }:

let

  cfg = config.x;

in

{

  config = {

    assertions = [
      {
        assertion = builtins.elem cfg.desktop [ "none" "xhyprland" "xShyprland"  ];
        message = "x.desktop got invalid value.";
      }
    ];

    home.stateVersion = lib.mkDefault "22.11";

    # Change NIX_PATH in order to pin nixpkgs to current version. This way
    # `nix shell` etc uses the same nixpkgs version as system configuration.
    home.sessionVariables = {
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}\${NIX_PATH:+:}$NIX_PATH";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # SSH config
    programs.ssh = {
      enable = true;
      # forwardAgent = true; # security wise it's probably smart to don't enable this, but use it per connection
      includes = [ "~/.ssh/config.d/*" ];
    };

    services.ssh-agent.enable = true;

    programs.bash = {
      enable = true;
      historyIgnore = [ "l" "ls" "ll" "cd" "exit" ];
      historyControl = [ "erasedups" ];
      shellAliases = {
        grep = "grep --color=auto";
        ".." = "cd ..";
      };
      initExtra = ''
        # Custom colored bash prompt
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      '';
      profileExtra = ''
        # Include user's private bin if present
        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi
      '';
    };

    # Kitty.
    programs.kitty = {
      enable = true;
      font = {
        name = "Rec Mono Semicasual";
        size = 11;
      };
          
      shellIntegration.enableZshIntegration = true;

      settings = {

        background = "#001100";
        foreground = "#00bb00";
        selection_background = "#00bb00";
        selection_foreground = "#001100";
        url_color = "#009900";
        cursor = "#00bb00";
        active_border_color = "#007700";
        inactive_border_color = "#003300";
        active_tab_background = "#001100";
        active_tab_foreground = "#00bb00";
        inactive_tab_background = "#003300";
        inactive_tab_foreground = "#009900";
        tab_bar_background = "#003300";

        # normal
        color0 = "#001100";
        color1 = "#007700";
        color2 = "#00bb00";
        color3 = "#007700";
        color4 = "#009900";
        color5 = "#00bb00";
        color6 = "#005500";
        color7 = "#00bb00";

        # bright
        color8 = "#007700";
        color9 = "#009900";
        color10 = "#003300";
        color11 = "#005500";
        color12 = "#009900";
        color13 = "#00dd00";
        color14 = "#005500";
        color15 = "#00ff00";
              
        window_padding_width = 25;
        background_opacity = "0.70";

        confirm_os_window_close = 0;
      };    
    };

    # Git settings
    programs.git = {
      enable = true;
      userEmail = "qlexqndru@outlook.com";
      userName = "qlexqndru";
      extraConfig = {
        pull.ff = "only";
      };
      ignores = [
        ".ccls*"
        "npm-debug.log"
        ".DS_Store"
        "Thumbs.db"
        ".dir-locals.el"
        "compile_commands.json"
        ".envrc"
        ".direnv"
        "result"
      ];
    };

    home.packages =
      with pkgs;
      [
        graphviz
        ripgrep
        dtach
        ltunify
        tree
        unixtools.netstat
        unixtools.route
        whois
        fira-code
        fira-code-symbols
        iosevka

        mullvad
        telegram-desktop
        vlc
        floorp
        vscode
        xfce.mousepad
        kitty
        swww
      ];
  };
}

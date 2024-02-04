{ config, lib, pkgs, ... }:

let

  cfg = config.x;

in

{
  config =
    let
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      notify = "${pkgs.libnotify}/bin/notify-send";
      lockCmd = "${pkgs.gtklock}/bin/gtklock --daemonize -s ${config.xdg.configHome}/gtklock/style.css";
      fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
      grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
      swappy = "${pkgs.swappy}/bin/swappy";
      ewwCmd = pkgs.writeScriptBin "launch-eww" ''
                ## Files and cwd
                FILE="${config.home.homeDirectory}/.cache/eww_launch.dashboard"
                CFG="${config.xdg.configHome}/eww"

                ## Run eww daemon if not running already
                if [[ ! `pidof eww` ]]; then
                	${pkgs.eww-wayland}/bin/eww daemon
                  sleep 1
                fi

                ## Open widgets
                run_eww() {
        	        ${pkgs.eww-wayland}/bin/eww --config "$CFG" open-many \
                  		   bg clock leftdash sysbars network power-buttons
                }

                ## Launch or close widgets accordingly
                if [[ ! -f "$FILE" ]]; then
                	touch "$FILE"
                 	run_eww
                else
                	${pkgs.eww-wayland}/bin/eww --config "$CFG" close \
        					       bg clock leftdash sysbars network power-buttons
                  rm "$FILE"
                fi
      '';
    in
    lib.mkIf (cfg.desktop == "xShyprland") {

      x.waylandTools = lib.mkDefault true;

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        extraConfig = ''

          ########################################################################
          ########################################################################

          # Monitors configurations.

          ########################################################################

          # Main settings.
          |
          monitor=DP-1,highres,0x0,1,transform,1
          monitor=VGA-1,highres,1080x0,1,transform,1

          ########################################################################

          # Main modifier.
          |
          $mainMod = SUPER # windows key

          ########################################################################

          # Night shift.
          |
          exec = wl-gammarelay-rs
          |
          bind = $mainMod,I,exec,busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 6200
          bind = $mainMod,J,exec,busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 4200
          bind = $mainMod,N,exec,busctl --user -- set-property rs.wl-gammarelay / rs.wl.gammarelay Temperature q 2200

          ########################################################################

          # SWWW init and set wallpaper.
          |
          exec-once=swww init && swww img -o "DP-1" ~/.config/hypr/swallver.png && swww img -o "VGA-1" ~/.config/hypr/swallver.png

          ########################################################################
          ########################################################################

          # Hardware control.

          ########################################################################

          # Audio.
          |
          bind = , XF86AudioMute, exec, ${pkgs.avizo}/bin/volumectl toggle-mute
          bind = , XF86AudioRaiseVolume, exec, ${pkgs.avizo}/bin/volumectl -u up
          bind = , XF86AudioLowerVolume, exec, ${pkgs.avizo}/bin/volumectl -u down
          bind = , XF86AudioMicMute, exec, ${pkgs.avizo}/bin/volumectl -m toggle-mute

          ########################################################################

          # Brightness.
          |
          bind = , XF86MonBrightnessUp, exec, ${pkgs.avizo}/bin/lightctl up
          bind = , XF86MonBrightnessDown, exec, ${pkgs.avizo}/bin/lightctl down

          ########################################################################

          # Power ops.
          |
          bind = $mainMod, L, exec, ${lockCmd}
          bind = $mainMod, P, exec, systemctl reboot
          bind = $mainMod, O, exec, systemctl suspend
          bind = $mainMod, K, exec, hyprctl dispatch exit 0
          bind = $mainMod, M, exec, systemctl poweroff

          ########################################################################
          ########################################################################

          # Applications control.

          ########################################################################

          # Fuzzel app launcher.
          |
          bind = $CONTROL, tab, exec, ${fuzzel}

          ########################################################################

          # Assign apps.
          |
          $term = kitty
          $file = thunar
          $browser = floorp
          $code = code
          |
          # Application shortcuts.
          |
          bind = $mainMod, Q, exec, $term  # open terminal
          bind = $mainMod, W, exec, $browser # open browser
          bind = $mainMod, E, exec, $file # open file manager
          bind = $mainMod, T, exec, $code # open code

          ########################################################################

          # EWW control and launcher.
          |
          exec-once=${pkgs.eww-wayland}/bin/eww daemon
          bind = $mainMod, A, exec, ${ewwCmd}/bin/launch-eww

          ########################################################################

          # Notifications.
          |
          exec-once=systemctl --user start avizo.service
          
          ########################################################################
          ########################################################################

          # Windows control.

          ########################################################################

          # Window/Session actions.
          |
          bind = $mainMod, Z, killactive  # killactive, kill the window on focus
          # bind = $mainMod SHIFT, Z, exit,
          bind = $mainMod, C, togglefloating, # toggle the window on focus to float
          bind = $mainMod, V, togglesplit, # dwindle
          bind = $mainMod, F, fullscreen,
          bind = $mainMod SHIFT, G, togglegroup,

          ########################################################################

          # Move/Resize windows with mainMod + LMB/RMB and dragging.
          |
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          ########################################################################

          # Scroll through existing workspaces with mainMod + scroll.
          |
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e

          ########################################################################

          # Switch workspaces with mainMod + [0-9].
          |
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          ########################################################################
          
          # Move active window to a workspace with mainMod + SHIFT + [0-9].
          |
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10

          ########################################################################

          # Move window silently to workspace Super + Alt + [0-9].
          |
          bind = $mainMod ALT, 1, movetoworkspacesilent, 1
          bind = $mainMod ALT, 2, movetoworkspacesilent, 2
          bind = $mainMod ALT, 3, movetoworkspacesilent, 3
          bind = $mainMod ALT, 4, movetoworkspacesilent, 4
          bind = $mainMod ALT, 5, movetoworkspacesilent, 5
          bind = $mainMod ALT, 6, movetoworkspacesilent, 6
          bind = $mainMod ALT, 7, movetoworkspacesilent, 7
          bind = $mainMod ALT, 8, movetoworkspacesilent, 8
          bind = $mainMod ALT, 9, movetoworkspacesilent, 9
          bind = $mainMod ALT, 0, movetoworkspacesilent, 10

          ########################################################################  
          ########################################################################  

          # Style and general settings.

          ########################################################################  

          # Styling. 
          |
          general {
              gaps_in = 3
              gaps_out = 10
              border_size = 2
              col.active_border = rgba(074d07cc)
              col.inactive_border = rgba(353836cc) rgba(353836cc) 45deg
              layout = dwindle
              resize_on_border = true
          }
          group {
              col.border_active = rgba(353836cc) rgba(353836cc) 45deg
              col.border_inactive = rgba(353836cc) rgba(353836cc) 45deg
              col.border_locked_active = rgba(353836cc) rgba(353836cc) 45deg
              col.border_locked_inactive = rgba(353836cc) rgba(353836cc) 45deg
          }
          decoration {
              rounding = 10
              drop_shadow = false

              blur {
                  enabled = yes
                  size = 5
                  passes = 4
                  new_optimizations = on
                  ignore_opacity = on
                  xray = true
              }
          }

          ########################################################################  

          input {
            kb_layout = us
            kb_model = pc105
            kb_variant = altgr-intl
            kb_options =
            kb_rules =
            follow_mouse = 2
            touchpad {
              natural_scroll = true
            }
          }

          gestures {
            workspace_swipe = true
            workspace_swipe_fingers = 3
          }

          dwindle {
              pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = yes # you probably want this
          }
          
          misc {
              vrr = 0
              disable_hyprland_logo = true
          }

          ########################################################################        
          ########################################################################    
        '';
      };

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.kitty}/bin/kitty";
            layer = "overlay";
            width = 55;
          };
          #colors.background = "000000";
        };
      };

      # Volume and brightness indicator
      services.avizo.enable = true;

      programs.eww = {
        enable = true;
        package = pkgs.eww-wayland;
        configDir = ./eww;
      };

      # Swayidle locks device, turns off screen and suspends machine
      #services.swayidle = {
      #  enable = true;
       # extraArgs = [ "-w" ];
      #  systemdTarget = "hyprland-session.target";
      #  events = [
       #   { event = "before-sleep"; command = lockCmd; }
       #   { event = "lock"; command = lockCmd; }
      #  ];
     #   timeouts = [
     #     { timeout = 600; command = "${ewwCmd}/bin/launch-eww"; }
     #     { timeout = 900; command = lockCmd; }
     #     { timeout = 1800; command = "${hyprctl} dispatch dpms off"; resumeCommand = "${hyprctl} dispatch dpms on"; }
     #     { timeout = 1860; command = "systemctl suspend"; } # TODO: Check if this is a good way to suspend machine after screen turns off
      #  ];
      #};

      # Mako notification service
      services.mako = {
        enable = true;
        anchor = "top-center";
        defaultTimeout = 5000;
      };

      xdg = {
        enable = true;

        configFile."hypr/swallver.png" = {
          source = ../../assets/swallver.png;
          recursive = true;
        };

        configFile."Thunar/uca.xml".text = ''
          <actions nighteye="disabled">
            <action>
            <icon>utilities-terminal</icon>
            <name>Open Terminal Here</name>
            <submenu/>
            <unique-id>1706975482071193-1</unique-id>
            <command>kitty -d %f</command>
            <description>Example for a custom action</description>
            <range/>
            <patterns>*</patterns>
            <startup-notify/>
            <directories/>
            </action>
          </actions>
        '';

        configFile."swappy/config".text = ''
          [Default]
          save_dir=$HOME/Pictures/Screenshots
          save_filename_format=%Y%m%d-%H%M%S.png
          show_panel=false
          line_size=5
          text_size=20
          paint_mode=brush
          early_exit=true
          fill_shape=false
        '';

        configFile."networkmanager-dmenu/config.ini".text = ''
          [dmenu]
          dmenu_command = ${fuzzel} -d
          wifi_chars = ▂▄▆█
          pinentry = pinentry-qt

          [editor]
          terminal = ${pkgs.kitty}/bin/kitty
          gui_if_available = true
        '';

        configFile."gtklock/style.css".text = ''
          @define-color bg rgb(59, 66, 82);
          @define-color text1 #fff;
          @define-color text2 #b48ead;

          * {
            color: @text1;
          }

          entry#input-field {
            color: @text2;
          }

          window {
            background-color: @bg;
          }
        '';

        configFile."/home/x/.floorp/2i5ls1kp.default/chrome/userChrome.css".text = ''

          @charset "UTF-8";
          @-moz-document url(chrome://browser/content/browser.xhtml) {

            #appcontent
              > #tabbrowser-tabbox
              > #tabbrowser-tabpanels
              > .deck-selected
              > .browserContainer
              > .browserStack
              > browser {
              border-radius: 8px !important;
              margin: 14px !important;
            }

            .browserContainer {
              background-color: var(
                --lwt-accent-color-inactive,
                var(--lwt-accent-color)
              ) !important;
              background-image: var(--lwt-header-image), var(--lwt-additional-images) !important;
              background-repeat: no-repeat, var(--lwt-background-tiling) !important;
              background-position: right top, var(--lwt-background-alignment) !important;
            }

            #titlebar {
              display: none !important;
            }

            .titlebar-buttonbox-container {
              display: none !important;
            }

            toolbarbutton[open="true"] {
              --is-bar-visible: visible !important;
              opacity: 1 !important;
              transition: opacity 175ms ease-in-out;
            }

            #navigator-toolbox{ --toolbar-bgcolor: #000000; --toolbar-color: #00bb00;  }

            #urlbar {
              color: #00bb00 !important;
              background-color: #000000 !important;
            }
          }
        '';
      };

      services.blueman-applet.enable = true;

      # Fix for small cursor issue
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 16;
        x11 = {
          enable = true;
          defaultCursor = "Adwaita";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          name = "Vimix-Black";
          package = pkgs.vimix-icon-theme;
        };
      };

      services.clipman = {
        enable = true;
        systemdTarget = "hyprland-session.target";
      };

      services.udiskie = {
        enable = true;
        tray = "never";
      };
    };
}

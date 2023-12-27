{ pkgs, lib, ... }:


let
  rofi_power = ./rofi/config/rofi-power.sh;
  colors_set = {
    bg = "#2c2c2e";
    fg = "#9f9f9f";
    hi = "#efef8f";
    ac = "#a0a0a0";
    tx = "#040404";
    ia = "#8f8f8f";
    be = "#8faf9f";
    yw = "#ccdc90";
    gn = "#88b090";
    rd = "#e89393";
  };
in
{
  imports = [
    ./rofi
  ];

  home.packages = [
    pkgs.i3lock-fancy-rapid
  ];

  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      modifier = "Mod4";

      bars = [];

      colors = {
        focused = {
          border = colors_set.ac;
          background = colors_set.ac;
          text = colors_set.tx;
          indicator = colors_set.ac;
          childBorder = colors_set.ac;
        };
        unfocused = {
          border = colors_set.bg;
          background = colors_set.bg;
          text = colors_set.ia;
          indicator = colors_set.bg;
          childBorder = colors_set.bg;
        };
      };

      window.border = 2;
      window.titlebar = false;

      gaps = {
        inner = 6;
        outer = 6;
        bottom = 10;
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun -show-icons -theme ${./rofi/config/launcher-style.rasi}";
        "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${modifier}+Shift+s" = "exec ${pkgs.spectacle}/bin/spectacle -r";
        "${modifier}+Shift+e" = "exec ${rofi_power}";
      };
  
      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ${ ./wallpaper.png }";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.slack}/bin/slack -u";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.discord}/bin/discord --start-minimized";
          always = true;
          notification = false;
        }
        {
          command = "${builtins.toString (pkgs.writeScriptBin "polybar-start" ''
         ${pkgs.procps}/bin/pkill polybar
         if type "xrandr"; then
             for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/cut -d" " -f1); do
                 MONITOR=$m ${pkgs.polybar}/bin/polybar --reload examples &
             done
         else
             ${pkgs.polybar}/bin/polybar --reload example &
         fi
         '')}/bin/polybar-start";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
          always = true;
          notification = false;
        }
      ];
    };
  };
}

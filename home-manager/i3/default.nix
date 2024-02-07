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
    pkgs.xdotool
    pkgs.bc
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
        "${modifier}+Shift+e" = "exec ${rofi_power}";
        "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
        "${modifier}+Shift+s" = "exec ${pkgs.flameshot}/bin/flameshot gui";
        "${modifier}+Shift+h" = "move workspace to output left";
        "${modifier}+Shift+j" = "move workspace to output down";
        "${modifier}+Shift+k" = "move workspace to output up";
        "${modifier}+Shift+l" = "move workspace to output right";
        "${modifier}+minus" = "exec ${./scratchpad_show.sh} --width 100ppt --height 35ppt --hgap right0ppt --vgap bottom65ppt --selector 'instance=\"scratchkitty\"'";
      };
  
      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-scale ${ ./wallpaper.png }";
          always = true;
          notification = false;
        }
        {
          command = "${pkgs.slack}/bin/slack -u";
          notification = false;
        }
        {
          command = "${pkgs.discord}/bin/discord --start-minimized";
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
          notification = false;
        }
        {
          command = "${pkgs.kitty}/bin/kitty --name scratchkitty";
          always = true;
          notification = false;
        }
      ];
    };
    extraConfig = ''
      for_window [instance="scratchkitty"] floating enable, resize set 1920 400, move absolute position 0 0, move window to scratchpad
    '';
  };
}

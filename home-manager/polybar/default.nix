{ pkgs, lib, ... }:

let
  colors = {
    background = "#28C7C675";
    background-alt = "#4D4D4C";
    foreground = "#C5C8C6";
    primary = "#A1A1A6";
    secondary = "#8ABEB7";
    alert = "#A54242";
    disabled = "#707880";
  };
  spotify-status = pkgs.substituteAll {
    src = ./spotify_status.py;
    isExecutable = true;
    python3 = pkgs.python3.withPackages ( ps: with ps; [ dbus-python ] );
  };
  system-nvidia-smi = pkgs.substituteAll {
    src = ./system-nvidia-smi.sh;
    isExecutable = true;
    tr = "${pkgs.coreutils}/bin/tr" ;
    awk = "${pkgs.gawk}/bin/awk" ;
  };
  cpu_info = pkgs.substituteAll {
    src = ./cpu_info.sh;
    isExecutable = true;
    head = "${pkgs.coreutils}/bin/head" ;
    grep = "${pkgs.gnugrep}/bin/grep";
    cat = "${pkgs.coreutils}/bin/cat" ;
    numfmt = "${pkgs.coreutils}/bin/numfmt" ;
    sleep = "${pkgs.coreutils}/bin/sleep" ;
    awk = "${pkgs.gawk}/bin/awk" ;
  };
in
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
        i3Support = true;
    };
    script = ''
      # sleep 2
      # if type "xrandr"; then
      #     for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/cut -d" " -f1); do
      #         MONITOR=$m ${pkgs.polybar}/bin/polybar --reload examples &
      #     done
      # else
      #     ${pkgs.polybar}/bin/polybar --reload example &
      # fi
    '';
    config = {

      "bar/examples" = {
        width = "100%";
        height = "24pt";

        monitor = "\${env:MONITOR:}";

        radius = "4";

        bottom = "true";

        background = "${colors.background}";
        foreground = "${colors.foreground}";

        line-size = "3pt";

        border-size = "1pt";
        border-color = "#00000000";

        padding-left = "1";
        padding-right = "1";

        module-margin = "1";
        module-margin-left = "1";

        #separator = "│";
        separator = "|";
        separator-foreground = "${colors.disabled}";

        font-0 = "Fira Mono:size=11;2";
        font-1 = "Fira Code Nerd Font:size=10;1";
        font-2 = "Emoji";
        #font-2 = "AvantGarde:size=13;2";

        modules-left = "xworkspaces";
        modules-right = "spotify pulseaudio memory battery cpu gpu date";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = "true";

        tray-position = "right";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        pin-workspaces = true;

        label-active = "%name%";
        label-active-background = "${colors.background-alt}";
        label-active-underline= "${colors.primary}";
        label-active-padding = "1";

        label-occupied = "%name%";
        label-occupied-foreground = "${colors.disabled}";
        label-occupied-padding = "1";

        label-urgent = "%name%";
        label-urgent-foreground = "${colors.alert}";
        label-urgent-padding = "1";

        label-empty = "%name%";
        label-empty-foreground = "${colors.disabled}";
        label-empty-padding = "1";
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };

      "module/pulseaudio" = {
        type = "custom/script";
        tail = true;
        #label-padding = 2;
        label-foreground = "${colors.foreground}";

        exec = ''${./pipewire.sh} --mute-color "${colors.disabled}" --set-nick "alsa_output.pci-0000_06_00.6.analog-stereo=Speakers"  --set-nick "alsa_output.pci-0000_01_00.1.hdmi-stereo=HDMI Speakers" output listen'';
        click-right = "exec pavucontrol &";
        click-left = "${./pipewire.sh} volume_mute";
        click-middle = ''${./pipewire.sh} next_sink'';
        scroll-up = "${./pipewire.sh} volume_up";
        scroll-down = "${./pipewire.sh} volume_down";
      };

      "module/spotify" = {
        type = "custom/script";
        interval = 1;
        format = "<label>";
        exec = "${spotify-status} -f '{play_pause} {artist} - {song}' -p ','";
        format-underline = "#1db954";
        click-left = "${pkgs.playerctl}/bin/playerctl --player=spotify play-pause";
        click-right = "${pkgs.playerctl}/bin/playerctl --player=spotify next";
        click-middle = "${pkgs.playerctl}/bin/playerctl --player=spotify previous";
        scroll-up = "${pkgs.playerctl}/bin/playerctl --player=spotify volume 0.05+";
        scroll-down = "${pkgs.playerctl}/bin/playerctl --player=spotify volume 0.05-";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = "RAM ";
        format-prefix-foreground = "${colors.primary}";
        label = "%percentage_used:2%%";
      };

      "module/battery" = {
        type = "internal/battery";
        full-at = "98";
        low-at = "20";
        battery = "BAT1";
        adapter = "ACAD";
        label-full = "%{F#A1A1A6}Full%{F-} %percentage_raw%%";
        label-charging = "%{F#A1A1A6}Charging%{F-} %percentage_raw%%";
        label-discharging = "%{F#A1A1A6}Battery%{F-} %percentage_raw%%";
        label-low = "%{F#FF8333}BATTERY LOW%{F-} %percentage_raw%%";
        format-low = "<label-low><animation-low>";
        animation-low-0 = "!";
        animation-low-1 = " ";
        animation-low-framerate = "200";
      };

      "module/cpu" = {
        type = "custom/script";
        format-prefix = "CPU ";
        format-prefix-foreground = "${colors.primary}";
        exec = "/usr/bin/env ${pkgs.bash}/bin/bash ${cpu_info}";
        tail = true;
      };

      "module/gpu" = {
        type = "custom/script";
        format-prefix = "GPU ";
        format-prefix-foreground = "${colors.primary}";
        exec = "${system-nvidia-smi}";
        interval = 3;
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;

        date = "%H:%M";
        date-alt = "%Y-%m-%d %H:%M:%S";

        label = "%date%";
        label-foreground = "${colors.primary}";
      };

      settings = {
        screenchange-reload = "true";
        pseudo-transparency = "true";
      };

    };
  };
}

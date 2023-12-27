{ pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;

    theme = "Arc-Dark";

    extraConfig = {
      modi = "drun,run,window";
    };
  };

  xdg.configFile = {
    "rofi/themes/power-style.rasi" = {
      enable = true;
      source = ./config/power-style.rasi;
    };
    "rofi/themes/colors.rasi" = {
      enable = true;
      source = ./config/colors.rasi;
    };
  };
}

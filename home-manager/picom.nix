{ pkgs, lib, ... }:

{
  services.picom = {
    enable = true;

    settings = {
      blur = {
        method = "gaussian";
        size = 30;
        deviation = 5.0;
      };
      blur-background-exclude = [
        "class_g = 'Rofi'"
      ];
    };

  };
}

{ pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code Light";
    };
    settings = {
      background_opacity = "0.8";


      editor = "${pkgs.neovim}/bin/nvim";
    };
  };
}

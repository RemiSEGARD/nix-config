{ lib, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userEmail = "remi.segard@epita.fr";
    userName = "Remi SEGARD";

    aliases = {
      lol = "log --oneline --graph";
      lola = "log --oneline --graph --all";
    };

    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };
}

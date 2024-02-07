{ pkgs, lib, ... }:

{
  xdg.configFile."nvim/lua" = {
    enable = true;
    recursive = true;
    source = ./lua;
  };
  programs.neovim = {
    enable = true;
    vimAlias = true;

    defaultEditor = true;

    extraLuaConfig = "require('requires')";


    coc = {
      enable = true;

      settings = {
        "suggest.noselect" = true;
        languageserver = {
          clangd = {
            command = "${pkgs.clang-tools}/bin/clangd";
            rootPatterns=  [ "compile_flags.txt" "compile_commands.json" ];
            filetypes = [ "c" "cc" "cpp" "c++" "objc" "objcpp" ];
            extraArgs = [
              "-I" "${pkgs.glibc.dev}/include/"
            ];
          };
          nix = {
            command = "${pkgs.nil}/bin/nil";
            filetypes = [ "nix" ];
            rootPatterns=  [ "flake.nix" ".git" ];
          };
          cmake = {
            command = "${pkgs.cmake-language-server}/bin/cmake-language-server";
            filetypes = ["cmake"];
            rootPatterns = [ "build/"];
            initializationOptions = {
              buildDirectory = "build";
            };
          };
        };
      };
    };
  };
}

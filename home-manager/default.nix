{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "remi";
  home.homeDirectory = "/home/remi";

  #xsession.windowManager.i3 = import ./i3.nix { inherit pkgs lib; };
  imports = [
    ./polybar
    ./i3
    ./neovim
    ./bash.nix
    ./git.nix
    ./kitty.nix
    ./picom.nix
  ];

  nixpkgs.config.allowUnfree = true;

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Papirus-Maia";
    iconTheme.package = pkgs.papirus-maia-icon-theme;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    discord
    slack
    spotify
    pavucontrol
    blueman
    arandr

    pulseaudio
    zip
    unzip

    gcc
    gnumake
    llvmPackages_16.clang-unwrapped
    cmake
    ninja
    autoconf
    automake
    gdb
    man-pages
    ripgrep

    virt-manager

    coq_8_9
    python312

    yarn
    nodejs_20

    xsel

    htop
    tree

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
    dejavu_fonts
    fira
    fira-code
    fira-code-symbols
    font-awesome
    jetbrains-mono
    material-design-icons

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/remi/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.ssh = {
    enable = true;
    extraConfig = "AddKeysToAgent yes";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

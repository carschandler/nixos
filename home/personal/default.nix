# Stuff we need on personal computers, but not at work
{ pkgs, config, ... }: {
  imports = [
    ../fonts
    ../hyprland
  ];

  home.packages = with pkgs; [
    # terminal emulators
    alacritty
    foot
    kitty
    wezterm

    # gui apps
    gimp
    libreoffice-fresh
    obsidian
    spotify
    vscode-fhs
  ];


  xdg.configFile = {
    "foot".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/dotfiles/foot/dot-config/foot";
  };

  home.stateVersion = "22.11";
}


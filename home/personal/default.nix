# Stuff we need on personal computers, but not at work
{ pkgs, ... }: {
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
    libreoffice-fresh
    spotify
  ];
}


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
    obsidian
    spotify
    vscode-fhs
  ];

  xdg.desktopEntries = {
    obsidian = {
      name = "Obsidian";
      exec = "obsidian";
      terminal = false;
    };
  };
}


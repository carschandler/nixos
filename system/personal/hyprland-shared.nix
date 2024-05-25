{ inputs, pkgs, lib, ... }:

{
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
    xwayland.enable = true;
  };

  security.pam.services.hyprlock = {};

  environment.systemPackages = with pkgs; [
    ## Required by hyprland
    # Notification Daemon
    mako

    # pipewire should be taken care of in ./configuration.nix
    # pipewire
    # wireplumber

    # qt stuff / authentication agent
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.polkit-kde-agent

    ## Optional
    # Status bar

    # App Launcher
    tofi

    # Wallpaper
    hyprpaper

    # Cursor
    hyprcursor

    # Clipboard
    wl-clipboard
    cliphist

    # Audio control GUI
    pavucontrol

    # Brightness control
    brightnessctl

    # Media control
    playerctl
  ];
}

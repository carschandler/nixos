{ config, pkgs, ... }:

{
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
  };

  environment.systemPackages = with pkgs; [
    ## Required by hyprland
    # Notification Daemon
    mako
    # pipewire
    pipewire
    wireplumber
    # qt stuff / authentication agent
    libsForQt5.qt5.qtwayland
    libsForQt5.polkit-kde-agent
    qt6.qtwayland
    # XDPH is handled by the module (?)

    ## Optional
    # Status bar
    waybar
    # App Launcher
    tofi
    # Wallpaper
    hyprpaper
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

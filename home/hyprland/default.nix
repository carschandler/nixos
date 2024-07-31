{inputs, outputs, config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "hypr/source.conf".source = 
      config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/hyprland/dot-config/hypr/hyprland-source.conf";
    "hypr/noanims.sh".source =
      config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/hyprland/dot-config/hypr/noanims.sh";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig = "source=./source.conf";
  };
  
  home.packages = with pkgs; [
    # Notification Daemon
    mako
    swaynotificationcenter

    # pipewire should is taken care of at system level
    # pipewire
    # wireplumber

    # qt stuff / authentication agent
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.polkit-kde-agent

    # Status bar
    nwg-panel

    # App Launcher
    tofi
    nwg-drawer

    # Logout menu
    nwg-bar

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

    # Screenshots
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    pkgs.hyprpicker
 ];

  programs.hyprlock = {
    enable = true;
  };
}

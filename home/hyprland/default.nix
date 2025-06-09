{
  config,
  pkgs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "hypr/source.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hyprland/dot-config/hypr/hyprland-source.conf";
    "hypr/noanims.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hyprland/dot-config/hypr/noanims.sh";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Default true; conflicts with UWSM
    extraConfig = "source=./source.conf";
  };

  home.packages = with pkgs; [
    # Notification Daemon
    mako
    swaynotificationcenter

    # qt stuff / authentication agent
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.polkit-kde-agent

    # Status bar
    nwg-panel

    # App Launcher
    rofi-wayland
    tofi

    # Logout menu
    nwg-bar

    # Wallpaper
    hyprpaper

    # Cursor
    hyprcursor

    # Clipboard
    # wl-clipboard -> moved to linux config
    cliphist

    # Audio control GUI
    pavucontrol

    # Brightness control
    brightnessctl

    # Screenshots
    hyprshot
  ];

  programs = {
    hyprlock = {
      enable = true;
    };

    tofi =
      let
        fontFile = (import ../fonts/systemFonts).sans.getFile pkgs;
      in
      {
        enable = true;
        settings = {
          font = fontFile;
          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          padding-left = "35%";
          padding-top = "35%";
          result-spacing = 25;
          num-results = 5;
          background-color = "#000a";
          text-color = "#ebdbb2";
          selection-color = "#689d6a";
          selection-match-color = "#8ec07c";
        };
      };
  };

  services = {
    swayosd = {
      enable = true;
      topMargin = 0.95;
    };

    mako = {
      enable = true;
      settings = {
        backgroundColor = "#282828E6";
        borderColor = "#BBBBBBCC";
        borderRadius = 10;
        borderSize = 2;
        defaultTimeout = 10000;
        font = (import ../fonts/systemFonts).sans.name;
      };
    };
  };
}

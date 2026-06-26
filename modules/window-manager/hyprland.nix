{
  ...
}:
{
  flake.modules.nixos.hyprland = {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    security.pam.services.hyprlock = { };
  };

  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
    in
    {
      hyprlock = {
        enable = true;
      };
      xdg.configFile = {
        "hypr/hyprland-source.lua".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hyprland/dot-config/hypr/hyprland-source.lua";
        "hypr/noanims.sh".source =
          config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hyprland/dot-config/hypr/noanims.sh";
      };

      home.file.".local/share/icons/macOS".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hyprland/dot-local/share/icons/macOS";

      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false; # Default true; conflicts with UWSM
        configType = "lua";
        # HM always writes the entry hyprland.lua; have it just require our
        # out-of-store-symlinked hyprland-source.lua so Hyprland still
        # hot-reloads on save (Lua equivalent of the old source= approach).
        extraConfig = ''require("hyprland-source")'';
      };

      home.packages = with pkgs; [
        # Notification Daemon
        # swaync in services below

        # qt stuff / authentication agent
        qt6.qtwayland
        qt5.qtwayland

        hyprpolkitagent

        # Status bar
        # nwg-panel

        # App Launcher
        rofi
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

        swaync = {
          enable = true;
          style = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swaync/dot-config/style.css";
        };

      };
    };
}

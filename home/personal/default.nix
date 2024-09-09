# Stuff we need on personal computers, but not at work
{
  pkgs,
  config,
  inputs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  imports = [
    ../fonts
    ../hyprland
  ];

  home.packages = with pkgs; [
    # terminal emulators
    alacritty
    foot
    wezterm
    # kitty in programs

    # gui apps
    _1password-gui
    discord
    evince
    gimp
    ladybird
    libreoffice-fresh
    nautilus
    obsidian
    spotify
    thunderbird
    chromium
    vlc
    vscode-fhs
    xfce.thunar
    zathura
    zed-editor

    # hardware utils
    usbutils
    usb-reset
    glxinfo
  ];

  # programs.thunderbird = {
  #   enable = true;
  #   profiles.chan = {
  #     isDefault = true;
  #   };
  # };

  programs = {
    kitty =
      let
        monospaceFont = (import ../fonts/systemFonts).monospace.name;
      in
      {
        enable = true;
        theme = "Gruvbox Dark";
        settings = {
          font_family = "${monospaceFont}";
          bold_font = "${monospaceFont} Bold";
          italic_font = "${monospaceFont} Italic";
          bold_italic_font = "${monospaceFont} Bold Italic";
          font_size = 12;
          background_opacity = "0.9";
        };
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
      backgroundColor = "#282828E6";
      borderColor = "#BBBBBBCC";
      borderRadius = 10;
      borderSize = 2;
      defaultTimeout = 10000;
      font = (import ../fonts/systemFonts).sans.name;
    };
  };

  xdg.configFile = {
    foot.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/foot/dot-config/foot";

    # "mako/config" = {
    #   text = ''
    #   '';
    #   onChange = "${pkgs.mako}/bin/makoctl reload";
    # };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common = {
        default = [ "gtk" ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };
      sway = {
        default = [
          "wlr"
          "gtk"
        ];
      };
    };
  };

  # For Electron apps
  home.sessionVariables = {
    DEFAULT_BROWSER = "firefox";
    BROWSER = "firefox";
  };

  home.stateVersion = "22.11";
}

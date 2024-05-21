# Stuff we need on personal computers, but not at work
{ pkgs, config, inputs, systemFont, codeFont, ... }:
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
    # kitty below
    wezterm

    # gui apps
    discord
    evince
    gimp
    gnome.nautilus
    libreoffice-fresh
    libsForQt5.dolphin
    obsidian
    spotify
    thunderbird
    vscode-fhs

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
    kitty = {
      enable = true;
      theme = "Gruvbox Dark";
      settings = {
        font_family = "${codeFont}";
        bold_font = "${codeFont} Bold";
        italic_font = "${codeFont} Italic";
        bold_italic_font = "${codeFont} Bold Italic";
        font_size = 12;
        background_opacity = "0.9";
      };
    };

    tofi = {
      enable = true;
      settings = {
        font = "${pkgs.freefont_ttf}/share/fonts/truetype/FreeSansBold.ttf";
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
      backgroundColor="#282828E6";
      borderColor="#BBBBBBCC";
      borderRadius=10;
      defaultTimeout=10000;
      font=systemFont;
    };
  };

  xdg.configFile = {
    foot.source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/foot/dot-config/foot";

    # "mako/config" = {
    #   text = ''
    #   '';
    #   onChange = "${pkgs.mako}/bin/makoctl reload";
    # };
  };



  home.stateVersion = "22.11";
}


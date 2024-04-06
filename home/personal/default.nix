# Stuff we need on personal computers, but not at work
{ pkgs, config, ... }:
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
    vscode-fhs

    # hardware utils
    usbutils
    usb-reset
    glxinfo
  ];

  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark";
    settings = {
      font_family = "SauceCodePro NF Medium";
      bold_font = "SauceCodePro NF Bold";
      italic_font = "SauceCodePro NF Medium Italic";
      bold_italic_font = "SauceCodePro NF Bold Italic";
      font_size = 12;
      background_opacity = "0.9";
    };
  };

  services.swayosd = {
    enable = true;
    topMargin = 0.95;
  };

  xdg.configFile = {
    "foot".source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/foot/dot-config/foot";

    "mako".source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/mako/dot-config/mako";
  };


  home.stateVersion = "22.11";
}


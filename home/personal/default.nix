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
    vscode-fhs

    # hardware utils
    usbutils
    usb-reset
    glxinfo
  ];

  programs.thunderbird = {
    enable = true;
    profiles.chan = {
      isDefault = true;
    };
  };

  programs.kitty = {
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

  services.swayosd = {
    enable = true;
    topMargin = 0.95;
  };

  xdg.configFile = {
    foot.source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/foot/dot-config/foot";

    # "mako".source = config.lib.file.mkOutOfStoreSymlink
    #   "${dotfiles}/mako/dot-config/mako";
    "mako/config" = {
      text = ''
        background-color=#282828E6
        border-color=#BBBBBBCC
        border-radius=10
        default-timeout=10000
        font=${systemFont}
      '';
      onChange = "${pkgs.mako}/bin/makoctl reload";
    };
  };


  home.stateVersion = "22.11";
}


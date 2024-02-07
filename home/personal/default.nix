# Stuff we need on personal computers, but not at work
{ pkgs, config, lib, ... }: {
  imports = [
    ../fonts
    ../hyprland
  ];

  # FIXME: remove this after obsidian updates
  nixpkgs.config.permittedInsecurePackages =
    lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";

  warnings = (
    lib.optionals (pkgs.obsidian.version != "1.5.3") "Check to see if Obsidian updated Electron"
  );

  home.packages = with pkgs; [
    # terminal emulators
    alacritty
    foot
    # kitty below
    wezterm

    # gui apps
    discord
    gimp
    gnome.nautilus
    libreoffice-fresh
    obsidian
    libsForQt5.dolphin
    spotify
    vscode-fhs


    # hardware utils
    usbutils
    usb-reset
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

  xdg.configFile = {
    "foot".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos/dotfiles/foot/dot-config/foot";
  };

  home.stateVersion = "22.11";
}


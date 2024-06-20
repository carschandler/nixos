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
  
  home.packages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    pkgs.hyprpicker
  ];

  programs.hyprlock = {
    enable = true;
  };
}

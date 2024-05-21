{inputs, outputs, config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "hypr/hyprland-source.conf".source = 
      config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/hyprland/dot-config/hypr/hyprland-source.conf";
  };

  home.file.".local/bin/h".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/hyprland/hyprland_wrapped.sh";

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.x86_64-linux.hyprland;
    systemd.enable = true;
    xwayland.enable = true;
    extraConfig = "source=./hyprland-source.conf";
  };
  
  home.packages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    pkgs.hyprpicker
  ];
}

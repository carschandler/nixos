{inputs, outputs, config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  xdg.configFile = {
    "hypr/hyprland-source.conf".source = 
      config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/hyprland/dot-config/hypr/hyprland-source.conf";

    "tofi".source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/tofi/dot-config/tofi";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;
    recommendedEnvironment = true;
    extraConfig = "source=./hyprland-source.conf";
  };
}

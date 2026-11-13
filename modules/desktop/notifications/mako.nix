{ config, ... }:
{
  # Alternative to swaync (see hyprland.nix); not used by any host right now.
  flake.modules.homeManager.mako = {
    services.mako = {
      enable = true;
      settings = {
        backgroundColor = "#282828E6";
        borderColor = "#BBBBBBCC";
        borderRadius = 10;
        borderSize = 2;
        margin = 10;
        defaultTimeout = 10000;
        font = config.meta.fonts.sans.name;
      };
    };
  };
}

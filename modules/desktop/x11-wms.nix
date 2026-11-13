{
  # X11 tiling/floating WMs (i3, awesome) as an alternative to Hyprland
  flake.modules.nixos.x11-wms =
    { pkgs, ... }:
    {
      environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

      services.xserver = {
        enable = true;
        desktopManager.xterm.enable = false;

        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [
            dmenu # application launcher most people use
            i3status # gives you the default i3 status bar
            i3blocks # if you are planning on using i3blocks over i3status
          ];
        };

        windowManager.awesome = {
          enable = true;
          luaModules = with pkgs.luaPackages; [
            luarocks # is the package manager for Lua modules
            luadbi-mysql # Database abstraction layer
            awesome-wm-widgets # Community collection of widgets
          ];
        };
      };

      programs.i3lock.enable = true; # default i3 screen locker
    };
}

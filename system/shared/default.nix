{ pkgs, ... }:
{
  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = [
        pkgs.libGL
      ];
    };
  };

  services.dbus.enable = true;
}

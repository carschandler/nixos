# NixOS setup shared by every machine I sit in front of (not servers).
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos.workstation = {
    imports = with nixos; [
      nix
      nix-ld
      locale
      fileshare
      main-user
      networkmanager
      neovim
      audio
      bluetooth
      printing
      automount
    ];

    users.mutableUsers = false;
    users.users.${config.meta.users.main.username}.extraGroups = [ "video" ];

    services.dbus.enable = true;
    programs.npm.enable = true;
  };
}

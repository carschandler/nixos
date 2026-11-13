# NixOS setup shared by headless machines
{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  flake.modules.nixos.server = {
    imports = with nixos; [
      nix
      locale
      main-user
      neovim
      ssh-server
    ];
  };
}

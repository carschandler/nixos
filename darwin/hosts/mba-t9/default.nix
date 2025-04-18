{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/t9.nix
    ../../modules/shared.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  shared.enable = true;
  t9.enable = true;

  networking.hostName = "mba-t9";

  system.stateVersion = 5;
  ids.gids.nixbld = 350;
}

{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/shared.nix
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  shared.enable = true;

  networking.hostName = "mbp";

  system.stateVersion = 5;
  ids.gids.nixbld = 30000;
}

{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  home = {
    homeDirectory = lib.mkForce "/Users/chan";
  };

  home.stateVersion = "24.05";

  home.sessionPath = [
    "$HOME/Library/Flutter/bin"
  ];
}

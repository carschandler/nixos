{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.username = lib.mkForce "cchandler";
  home.stateVersion = "23.11";
}

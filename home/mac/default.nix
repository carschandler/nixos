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

  programs.docker-cli = {
    enable = true;
    settings = {
      cliPluginsExtraDirs = [
        "/opt/homebrew/lib/docker/cli-plugins"
      ];
      currentContext = "colima";
    };
  };

  home.stateVersion = "24.05";

  home.sessionPath = [
    "$HOME/Library/Flutter/bin"
  ];
}

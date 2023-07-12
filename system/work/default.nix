{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    "${modulesPath}/profiles/minimal.nix"

    nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  # Enable nix flakes (did this above)
  # nix.package = pkgs.nixFlakes;
  # nix.extraOptions = ''
  #   experimental-features = nix-command flakes
  # '';


  users.users.chan = {
    isNormalUser = true;
    home = "/home/chan";
    description = "Cars Chandler (Work)";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "22.05";

}

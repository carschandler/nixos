{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [
    ../shared
    ./hardware-configuration.nix
    ./disko.nix
    # ./lanzaboote.nix
  ];

  services = {
    tailscale.enable = true;
    openssh.enable = true;
  };

  # FIXME: delete after enabling lanzaboote
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.chan = {
    isNormalUser = true;
    home = "/home/chan";
    description = "Cars Chandler (T9)";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    initialHashedPassword = "$y$j9T$3F0wnFpeirh.ucFK101Z6/$Nk6T1in2qPfMCrai/x.tnIplqhtFP9AOzbmuSCVZ5R5";
  };

  environment.systemPackages = [
    pkgs.postman
    pkgs.slack
    pkgs.thunderbird
    pkgs.glxinfo
  ];

  networking = {
    hostName = "desktop-t9";
    hostId = "bd4e6365";
  };

  hardware.graphics = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.05";
}

{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [ ../shared ];

  services = {
    tailscale.enable = true;
    openssh.enable = true;
  };

  users.users.chan = {
    isNormalUser = true;
    home = "/home/chan";
    description = "Cars Chandler (T9)";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    openssh.authorizedKeys.keyFiles = [
    ];
  };

  environment.systemPackages = [
    pkgs.postman
    pkgs.slack
    pkgs.thunderbird
    pkgs.glxinfo
  ];

  networking = {
    hostName = "desktop-t9";
  };

  hardware.graphics = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.05";
}

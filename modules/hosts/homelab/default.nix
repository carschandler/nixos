{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
  lan = config.meta.network.lan;
in
{
  configurations.nixos.homelab.module = {
    imports = with nixos; [
      inputs.disko.nixosModules.disko
      ./_hardware-configuration.nix
      ./_disko.nix
      server
      lanzaboote
      zfs
      nvidia
      intel-video-acceleration
      power-saving
      incus
      fileshare-server
    ];

    boot.loader.efi.canTouchEfiVariables = true;
    boot.lanzaboote.pkiBundle = "/etc/secureboot";

    networking = {
      # Required by ZFS; generated using head -c 8 /etc/machine-id
      # NOTE: this is actually from an old system, but we can't change it to match
      # the machine-id on this system now that it has been initialized as this, so
      # just leave it as-is since it seems to be an arbitrary choice.
      hostId = "c007d31d";
      interfaces.eno1.ipv4.addresses = [
        {
          address = lan.hosts.homelab;
          inherit (lan) prefixLength;
        }
      ];
      defaultGateway = lan.gateway;
      inherit (lan) nameservers;
    };

    users.users.chan = {
      extraGroups = [ "video" ];
      initialHashedPassword = "$y$j9T$mKGUGgyfGw.85QRIZ20gG0$SkKYGrxS79JHmk4fvRgIdElUHkQrglZbI4GcfivOkq8";
    };

    system.stateVersion = "24.05";
  };

  configurations.home."chan@homelab" = {
    system = "x86_64-linux";
    module = {
      imports = [ homeManager.base ];
      home.stateVersion = "24.05";
    };
  };
}

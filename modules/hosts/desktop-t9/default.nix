{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.desktop-t9.module =
    { config, pkgs, ... }:
    {
      imports = with nixos; [
        inputs.disko.nixosModules.disko
        ./_hardware-configuration.nix
        ./_disko.nix
        workstation
        nvidia
        hyprland
        lanzaboote
        zfs
        docker
        ssh-server
        tailscale
        tailscale-exit-node
        podman
        ly
        crossmacro
        openrgb
        hyprwhspr
        t9
      ];

      users.users.chan.hashedPassword = "$y$j9T$uxCqrhaofIQdeJERyH4ZB/$d7LgPgp3CLQNSKnkLYKLZqrXS/F3gqfMDKglePFWmWB";

      boot.lanzaboote.pkiBundle = "/keep/secureboot";

      services.openssh.ports = [
        22
        3022
      ];

      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        powerManagement.enable = true;
      };

      system.stateVersion = "25.05";
    };

  configurations.home."chan@desktop-t9" = {
    system = "x86_64-linux";
    module = {
      imports = with homeManager; [
        base
        linux-desktop
        t9
        hyprland
      ];

      home.stateVersion = "22.11";
    };
  };
}

{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.laptop.module = {
    imports = with nixos; [
      ./_hardware-configuration.nix
      workstation
      dual-boot
      nvidia
      hyprland
      docker
    ];

    users.users.chan.hashedPassword = "$y$j9T$UPPnh1xdGG0NfzhKD/em1.$u7vkDL0bTSYqhLQsFC29HPKTPlGruZIvnQHJS9zA173";

    # TODO
    # Fingerprint reader
    # services.fprintd = {
    #   enable = true;
    #   package = pkgs.fprintd-tod;
    #   tod = {
    #     enable = true;
    #     driver = pkgs.libfprint-2-tod1-goodix;
    #   };
    # };

    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    system.stateVersion = "22.11";
  };

  configurations.home."chan@laptop" = {
    system = "x86_64-linux";
    module = {
      imports = with homeManager; [
        base
        linux-desktop
        hyprland
      ];

      home.stateVersion = "22.11";
    };
  };
}

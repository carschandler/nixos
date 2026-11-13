{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
  lan = config.meta.network.lan;
in
{
  configurations.nixos.desktop.module =
    { pkgs, ... }:
    {
      imports = with nixos; [
        ./_hardware-configuration.nix
        workstation
        dual-boot
        nvidia
        hyprland
        docker
        ssh-server
        tailscale
        x11-wms
        flatpak
        fileshare-client
      ];

      users.users.chan.hashedPassword = "$y$j9T$UPPnh1xdGG0NfzhKD/em1.$u7vkDL0bTSYqhLQsFC29HPKTPlGruZIvnQHJS9zA173";

      networking = {
        # Required by ZFS; generated using head -c 8 /etc/machine-id
        # NOTE: this is actually from an old system, but we can't change it to match
        # the machine-id on this system now that it has been initialized as this, so
        # just leave it as-is since it seems to be an arbitrary choice.
        hostId = "5e16045e";
        interfaces.wlp8s0.ipv4.addresses = [
          {
            address = lan.hosts.desktop;
            inherit (lan) prefixLength;
          }
        ];
        defaultGateway = lan.gateway;
        inherit (lan) nameservers;
      };

      boot.loader.grub.gfxmodeEfi = "1280x1024";
      boot.loader.grub.font = "${pkgs.source-code-pro}/share/fonts/opentype/SourceCodePro-Medium.otf";

      # Attempt to fix Bluetooth ACPI _PRR error after suspend
      boot.kernelModules = [ "btintel" ];

      # This fixed hyprland crashing after waking from suspend!
      hardware.nvidia.powerManagement.enable = true;

      programs.bash.shellAliases = {
        bosereset = "sudo usb-reset 05a7:1020";
      };

      system.stateVersion = "22.11";
    };

  configurations.home."chan@desktop" = {
    system = "x86_64-linux";
    module =
      { pkgs, ... }:
      {
        imports = with homeManager; [
          base
          linux-desktop
          hyprland
          gaming
        ];

        home.packages = [
          pkgs.slack
        ];
        programs.spotify-player.enable = true;

        home.stateVersion = "22.11";
      };
  };
}

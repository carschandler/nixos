# Fallback boot entry with a completely separate config (other DEs/WMs, a
# different user), selectable from the boot menu.
{ config, inputs, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.desktop-t9.module.specialisation.alt = {
    inheritParentConfig = false;
    configuration =
      { pkgs, ... }:
      {
        imports = with nixos; [
          inputs.disko.nixosModules.disko
          ./_hardware-configuration.nix
          ./_disko.nix
          nix
          zfs
          locale
          neovim
          nvidia
          audio
          bluetooth
          printing
          automount
          x11-wms
          t9
        ];

        networking = {
          hostName = "desktop-t9";
          hostId = "bd4e6365";
        };

        hardware.nvidia.powerManagement.enable = true;

        services.displayManager.gdm.enable = true;
        services.displayManager.cosmic-greeter.enable = true;
        services.desktopManager.cosmic.enable = true;

        programs.sway.enable = true;
        programs.sway.wrapperFeatures.gtk = true;

        services.gnome.gnome-keyring.enable = true;

        users.mutableUsers = false;
        users.users.frankie = {
          isNormalUser = true;
          home = "/home/frankie";
          description = "Cars Chandler";
          extraGroups = [
            "wheel"
            "networkmanager"
            "video"
          ];
          hashedPassword = "$y$j9T$uxCqrhaofIQdeJERyH4ZB/$d7LgPgp3CLQNSKnkLYKLZqrXS/F3gqfMDKglePFWmWB";
        };

        environment.systemPackages = [
          pkgs.thunderbird
          pkgs.firefox
          pkgs.pavucontrol
          pkgs.vscode-fhs
          pkgs.mesa-demos
          pkgs.wezterm
          pkgs.alacritty
          pkgs.fuzzel
          pkgs.swaylock
          pkgs.waybar
          pkgs.grim # screenshot functionality
          pkgs.slurp # screenshot functionality
          pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
          pkgs.mako # notification system developed by swaywm maintainer
        ];

        system.stateVersion = "25.05";
      };
  };
}

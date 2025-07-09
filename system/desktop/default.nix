# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    # Shared configuration between all systems
    ../personal
    ../shared

    # System-specific hardware configuration
    ./hardware-configuration.nix
  ];

  services.tailscale.enable = true;

  networking.hostName = "desktop";

  boot.loader.grub.gfxmodeEfi = "1280x1024";
  boot.loader.grub.font = "${pkgs.source-code-pro}/share/fonts/opentype/SourceCodePro-Medium.otf";

  # Attempt to fix Bluetooth ACPI _PRR error after suspend
  boot.kernelModules = [ "btintel" ];

  hardware.nvidia = {
    # This fixed hyprland crashing after waking from suspend!
    powerManagement.enable = true;
  };

  programs.bash.shellAliases = {
    bosereset = "sudo usb-reset 05a7:1020";
  };

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
  # nix.settings = {
  #   substituters = [ "https://cosmic.cachix.org/" ];
  #   trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  # };

  # services.xserver.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # environment.systemPackages = [ pkgs.adwaita-icon-theme ];

  # services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # programs.regreet = {
  #   enable = true;
  #   settings = {
  #     background.path = "$HOME/nixos/wallpapers/space.png";
  #     GTK = {
  #       application_prefer_dark_theme = true;
  #       cursor_theme_name = "Adwaita";
  #       icon_theme_name = "Adwaita";
  #       theme_name = "Adwaita";
  #     };
  #   };
  # };
  #
  # services.greetd.settings.default_session = {
  #   command = "Hyprland --config /etc/greetd/regreet-hyprland.conf";
  #   user = "greeter";
  # };

  virtualisation = {
    docker = {
      enable = true;
    };
    incus = {
      enable = false;
    };
  };

  # Enable GPU passthrough in docker using docker run --device=nvidia.com/gpu=all
  hardware.nvidia-container-toolkit.enable = lib.mkIf config.virtualisation.docker.enable true;

  # Required for incus, but causes problems for docker; specifically docker
  # compose
  networking.nftables.enable = lib.mkIf config.virtualisation.incus.enable true;

  users.users.chan.extraGroups = [
    "docker"
    "incus-admin"
  ];

  # environment.gnome.excludePackages

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

  # TODO: Trying to get desktop monitor brightness control...
  # programs.light.enable = true;
  # users.users.chan.extraGroups = [ "wheel" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      AllowUsers = [ "chan" ]; # Allows all users by default. Can be [ "user1" "user2" ]
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "22.11";
}

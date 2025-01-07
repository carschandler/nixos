{ config, pkgs, ... }:

{
  imports = [
    # Shared configuration between all systems

    # System-specific hardware configuration
    ./hardware-configuration.nix
    ./disko.nix
  ];

  services = {
    printing.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "homelab"; # Define your hostname.
    # Required by ZFS; generated using head -c 8 /etc/machine-id
    # NOTE: this is actually from an old system, but we can't change it to match
    # the machine-id on this system now that it has been initialized as this, so
    # just leave it as-is since it seems to be an arbitrary choice.
    hostId = "c007d31d";
    interfaces.eno1.ipv4.addresses = [
      {
        address = "192.168.1.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # This fixed hyprland crashing after waking from suspend!
    # powerManagement.enable = true;

    # Experimental support for turning off GPU when not in use
    # powerManagement.finegrained = true;
  };

  # CUDA binary cache
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  virtualisation.docker.enable = true;
  users.users = {
    chan = {
      isNormalUser = true;
      description = "Cars Chandler";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "docker"
      ];
      packages = [ ];
      openssh.authorizedKeys.keyFiles = [
        ../../keys/desktop
        ../../keys/laptop
        ../../keys/macbook
        ../../keys/iphone
      ];
      initialHashedPassword = "$y$j9T$mKGUGgyfGw.85QRIZ20gG0$SkKYGrxS79JHmk4fvRgIdElUHkQrglZbI4GcfivOkq8";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };

  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05";
}

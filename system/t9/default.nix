{
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
    ./hyprland-shared.nix
    ./ssh.nix
    ./lanzaboote.nix
  ];

  services = {
    tailscale.enable = true; # done
    openssh.enable = true; # done
    hardware.openrgb.enable = true; # done
  };

  networking.nftables.enable = true; # done
  virtualisation.incus.enable = true; # done
  # virtualisation.incus.preseed = { # done
  #   networks = [
  #     {
  #       config = {
  #         "ipv4.address" = "10.0.0.1/24";
  #         "ipv4.nat" = "true";
  #       };
  #       name = "docker0";
  #       type = "bridge";
  #     }
  #   ];
  #   profiles = [
  #     {
  #       devices = {
  #         eth0 = {
  #           name = "eth0";
  #           network = "docker0";
  #           type = "nic";
  #         };
  #         root = {
  #           path = "/";
  #           pool = "default";
  #           size = "20GiB";
  #           type = "disk";
  #         };
  #       };
  #     }
  #   ];
  # };

  specialisation = {
    alt = {
      inheritParentConfig = false;
      configuration = {
        imports = [ ./alt-specialisation.nix ];
      };
    };
  };

  # done
  users.mutableUsers = false;
  users.users.chan = {
    isNormalUser = true;
    home = "/home/chan";
    description = "Cars Chandler";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "incus-admin"
    ];
    hashedPassword = "$y$j9T$uxCqrhaofIQdeJERyH4ZB/$d7LgPgp3CLQNSKnkLYKLZqrXS/F3gqfMDKglePFWmWB";
  };

  environment.systemPackages = [
    pkgs.postman
    pkgs.slack
    pkgs.thunderbird
    pkgs.glxinfo
    pkgs.overskride
    inputs.wezterm.packages.x86_64-linux.default
  ];

  networking = {
    hostName = "desktop-t9";
    hostId = "bd4e6365";
  };

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement.enable = true;
  };

  # Auto-mount USB (hopefully?)
  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.udisks2.enable = true;

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  # TODO determine if any of this needs to be system-specific
  # sound.enable = true; # Removed per https://nixos.wiki/wiki/PipeWire
  services.pulseaudio.enable = false; # Required by NixOS to use PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # Set to true per https://nixos.wiki/wiki/PipeWire
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  # Enable blueman for managing connections
  services.blueman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.05";
}

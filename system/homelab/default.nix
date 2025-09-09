{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./boot
    ./hardware
    ./services
  ];

  networking = {
    hostName = "homelab"; # Define your hostname.
    # Required by ZFS; generated using head -c 8 /etc/machine-id
    # NOTE: this is actually from an old system, but we can't change it to match
    # the machine-id on this system now that it has been initialized as this, so
    # just leave it as-is since it seems to be an arbitrary choice.
    hostId = "c007d31d";
    interfaces.eno1.ipv4.addresses = [
      {
        address = "10.12.23.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = "10.12.23.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  users = {
    groups = {
      smb = { };
    };
    users = {
      chan = {
        isNormalUser = true;
        description = "Cars Chandler";
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
          "docker"
          "smb"
        ];
        packages = [ ];
        initialHashedPassword = "$y$j9T$mKGUGgyfGw.85QRIZ20gG0$SkKYGrxS79JHmk4fvRgIdElUHkQrglZbI4GcfivOkq8";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.sbctl
  ];

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

  system.stateVersion = "24.05";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}

{
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  services.displayManager.gdm.enable = true;

  # services.desktopManager.gnome.enable = true;

  ### i3, awesome
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3blocks # if you are planning on using i3blocks over i3status
      ];
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
        awesome-wm-widgets # Community collection of widgets
      ];

    };

  };
  programs.i3lock.enable = true; # default i3 screen locker
  ###

  programs.niri.enable = true;
  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;

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
    pkgs.postman
    pkgs.slack
    pkgs.thunderbird
    pkgs.firefox
    pkgs.pavucontrol
    pkgs.vscode-fhs
    pkgs.glxinfo
    pkgs.overskride
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
  services.gnome.gnome-keyring.enable = true;

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

  # environment.variables = {
  #   NIXOS_OZONE_WL = "1";
  # };

  # Enable blueman for managing connections
  # services.blueman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.05";
}

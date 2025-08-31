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
  imports = [ ./hyprland-shared.nix ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    fontSize = 16;
    configurationLimit = 3;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = [
  #       pkgs.dmenu # application launcher most people use
  #       pkgs.i3status # gives you the default i3 status bar
  #       pkgs.i3lock # default i3 screen locker
  #       pkgs.i3blocks # if you are planning on using i3blocks over i3status
  #     ];
  #   };
  # };

  # security.polkit.enable = true;
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

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

  # TODO figure out how to handle this with networking.networkmanager
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # This keeps NixOS from throwing the system time on our Windows install out of
  # whack
  time.hardwareClockInLocalTime = true;

  # # Enable the X11 windowing system.
  # # TODO determine if we need this
  # services.xserver.enable = true;

  # # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # # Configure keymap in X11
  # services.xserver = {
  #   layout = "us";
  #   xkbVariant = "";
  # };

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
  environment.systemPackages = [
    pkgs.overskride
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  # Enable blueman for managing connections
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # TODO figure out what to do with this / home-manager
  users.users.chan = {
    isNormalUser = true;
    description = "Cars Chandler";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys = {
      keyFiles = lib.filesystem.listFilesRecursive ../../keys;
    };
    hashedPassword = "$y$j9T$UPPnh1xdGG0NfzhKD/em1.$u7vkDL0bTSYqhLQsFC29HPKTPlGruZIvnQHJS9zA173";
  };

  users.mutableUsers = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Shared configuration between all systems
    ../personal

    # System-specific hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop"; # Define your hostname.

  boot.loader.grub.gfxmodeEfi = "1280x1024";
  boot.loader.grub.font = "${pkgs.source-code-pro}/share/fonts/opentype/SourceCodePro-Medium.otf";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = [
        pkgs.dmenu #application launcher most people use
        pkgs.i3status # gives you the default i3 status bar
        pkgs.i3lock #default i3 screen locker
        pkgs.i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
    windowManager.awesome = {
      enable = true;
    };
  };

  hardware.nvidia = {
    # This fixed hyprland crashing after waking from suspend!
    powerManagement.enable = true;
  };

  # Attempt to fix electron apps... didn't work, but may be good to keep?
  hardware.opengl.extraPackages = [ pkgs.libvdpau-va-gl ];

  # FIXME
  services.dbus.enable = true;

  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";

  programs.bash.shellAliases = {
    bosereset = "sudo usb-reset 05a7:1020";
  };

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
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [ ../shared ];

  # Check https://github.com/nix-community/NixOS-WSL/tree/main/modules for options
  wsl = {
    enable = true;
    defaultUser = "chan";
    useWindowsDriver = true;
    startMenuLaunchers = true;
    usbip = {
      enable = true;
      # Determine which Bus ID to enable using usbipd.exe in PowerShell (may
      # need to launch in admin mode)
      # autoAttach = [ "4-1" ];
    };
    wslConf = {
      interop.appendWindowsPath = false;
      network = {
        hostname = "TORCH-LT-7472";
        generateResolvConf = false;
      };
    };
  };

  services.tailscale.enable = true;

  users.users.chan = {
    isNormalUser = true;
    home = "/home/chan";
    description = "Cars Chandler (Work)";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    openssh.authorizedKeys.keyFiles = [
      ./work_arch_rsa.pub
      ./work_windows_rsa.pub
      ./work_ubuntu_rsa.pub
    ];
  };

  networking = {
    search = [ "torch2003.com " ];
    nameservers = [ "10.255.255.254" ];
  };

  # For mount.cifs, required unless domain name resolution is not needed.
  fileSystems."/mnt/share" = {
    device = "//10.200.11.72/OpticsLab";
    fsType = "cifs";
    options = [
      "rw"
      "noatime"
      "uid=1000"
      "gid=1000"
      "dir_mode=0777"
      "file_mode=0777"
      "credentials=/mnt/c/Users/rchandler/.smbcredentials"
    ];
  };

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      mesa.drivers
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = [
    pkgs.glxinfo
    pkgs.cifs-utils
  ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "23.11";

  services.openssh.enable = true;
}

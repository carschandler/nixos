{ lib, pkgs, config, inputs, ... }:

{
  imports = [
  ];

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
      };
    };
  };

  users.users.chan = {
    isNormalUser = true;
    home = "/home/chan";
    description = "Cars Chandler (Work)";
    extraGroups = [ "wheel" "networkmanager" "video"];
    openssh.authorizedKeys.keyFiles = [
      ./work_arch_rsa.pub
      ./work_windows_rsa.pub
    ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    setLdLibraryPath = true;

    extraPackages = with pkgs; [
      mesa.drivers
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = [
    pkgs.glxinfo
  ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Chicago";

  system.stateVersion = "23.11";

  services.openssh.enable = true;
  services.sshd.enable = true;
}

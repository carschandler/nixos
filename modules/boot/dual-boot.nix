{
  # GRUB with os-prober, for machines that also boot Windows
  flake.modules.nixos.dual-boot = {
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

    # This keeps NixOS from throwing the system time on our Windows install out of
    # whack
    time.hardwareClockInLocalTime = true;
  };
}

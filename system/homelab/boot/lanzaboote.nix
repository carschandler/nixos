{
  lib,
  ...
}:
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      # lanzaboote replaces systemd-boot
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # To decrypt LUKS using TPM, this must be enabled
    initrd.systemd.enable = true;
  };

}

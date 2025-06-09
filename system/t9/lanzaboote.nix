{
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    loader = lib.mkForce {
      # lanzaboote replaces systemd-boot
      systemd-boot.enable = false;
      grub.enable = false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/keep/secureboot";
    };

    # To decrypt LUKS using TPM, this must be enabled
    initrd.systemd.enable = true;
  };
}

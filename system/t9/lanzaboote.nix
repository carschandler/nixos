{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  securebootDir = "/keep/secureboot";
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = [
    pkgs.sbctl
  ];

  boot = {
    loader = lib.mkForce {
      # lanzaboote replaces systemd-boot
      systemd-boot.enable = false;
    };

    lanzaboote = {
      enable = true;
      # Move /var/lib/sbctl/{GUID,keys} here
      pkiBundle = securebootDir;
    };

    # To decrypt LUKS using TPM, this must be enabled
    initrd.systemd.enable = true;
  };

  environment.etc."sbctl/sbctl.conf" = {
    text = ''
      keydir: ${securebootDir}/keys
      guid: ${securebootDir}/GUID
    '';
  };
}

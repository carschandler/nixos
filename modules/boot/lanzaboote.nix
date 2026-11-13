{ inputs, ... }:
{
  # Secure boot. Hosts set `boot.lanzaboote.pkiBundle` to wherever their keys
  # live; sbctl is pointed at the same place.
  flake.modules.nixos.lanzaboote =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      pkiBundle = config.boot.lanzaboote.pkiBundle;
    in
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      environment.systemPackages = [
        pkgs.sbctl
      ];

      boot = {
        # lanzaboote replaces systemd-boot
        loader.systemd-boot.enable = lib.mkForce false;

        lanzaboote.enable = true;
      };

      environment.etc."sbctl/sbctl.conf" = {
        text = ''
          keydir: ${pkiBundle}/keys
          guid: ${pkiBundle}/GUID
        '';
      };
    };
}

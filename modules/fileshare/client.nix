{ config, ... }:
let
  share = config.meta.fileshare;
in
{
  # Mount the homelab's share over NFS on first access
  flake.modules.nixos.fileshare-client = {
    imports = [ config.flake.modules.nixos.fileshare ];

    boot.supportedFilesystems = [ "nfs" ];
    fileSystems.${share.path} = {
      device = "${share.server}:${share.path}";
      fsType = "nfs";
      options = [
        "nfsvers=4.2"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };
}

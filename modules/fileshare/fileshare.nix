{ config, ... }:
{
  meta.fileshare = {
    path = "/flash";
    server = config.meta.network.lan.hosts.homelab;
    nfsClients = [
      config.meta.network.lan.hosts.desktop
      # TODO: which machine is this?
      "${config.meta.network.lan.prefix}.10"
    ];
  };

  # Shared group for files on the homelab's /flash share (NFS/Samba), so the
  # gid lines up across machines.
  flake.modules.nixos.fileshare = {
    # Imported by several other features; a key lets the module system
    # dedupe it instead of merging the group members twice.
    key = "fileshare";

    users.groups.fileshare = {
      gid = 1111;
      members = [
        config.meta.users.main.username
        "root"
      ];
    };
  };
}

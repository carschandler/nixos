{
  # Hosts with a ZFS root. Don't force-import the root pool: if it wasn't
  # exported cleanly, fail loudly instead of risking a pool another system
  # still has imported. (The default flips to false in 26.11 anyway.)
  flake.modules.nixos.zfs = {
    boot.zfs.forceImportRoot = false;
  };
}

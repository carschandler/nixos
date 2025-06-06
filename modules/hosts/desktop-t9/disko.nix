let
  root_fs_partition = {
    size = "100%";
    content = {
      type = "zfs";
      pool = "rootpool";
    };
  };
  boot_partition =
    { mountpoint }:
    {
      size = "1G";
      type = "EF00";
      content = {
        inherit mountpoint;
        type = "filesystem";
        format = "vfat";
        mountOptions = [ "umask=0077" ];
      };
    };
  swap_partition = {
    size = "64G";
    content = {
      type = "swap";
      resumeDevice = false;
    };
  };
  zfs_rootfs_options = {
    # Enables access control lists
    acltype = "posixacl";
    # Disables tracking the time a file is accessed (viewed/ls'ed)
    atime = "off";
    # Supposedly a bit faster than zstd at the cost of slightly less
    # compression
    compression = "lz4";
    # We'll mount datasets rather than the pool itself
    mountpoint = "none";
    # Sets extended attributes in inode instead of with hidden sidecar
    # folders
    xattr = "sa";
  };
  zfs_options = {
    # 12 is a good default value... this pertains to the physical sector
    # size of the storage device in use. It's hard to find information about
    # this for the SSD I'm using, and a test I found showed that tweaking
    # this on an SSD didn't provide any performance boost, so I'm leaving it
    # at 12.
    ashift = "12";
  };
in
{
  disko.devices = {
    disk = {
      desktop-t9 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7KHNJ0Y137832L";
        content = {
          type = "gpt";
          partitions = {
            ESP = boot_partition { mountpoint = "/boot"; };
            swap = swap_partition;
            zfs = root_fs_partition;
          };
        };
      };
    };
    # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
    # https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
    zpool = {
      rootpool = {
        type = "zpool";
        # -O options for zpool create
        rootFsOptions = zfs_rootfs_options;
        # -o options for zpool create
        options = zfs_options;
        datasets = {
          # All datasets under drop are erased on reboot
          "drop" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "drop/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "false";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rootpool/drop/root@blank$' || zfs snapshot rootpool/drop/root@blank";
          };
          "drop/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };
          # All datasets under keep are persisted on reboot
          "keep" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "keep/keep" = {
            type = "zfs_fs";
            mountpoint = "/keep";
            options."com.sun:auto-snapshot" = "true";
          };
          "keep/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            # Used by services.zfs.autoSnapshot options.
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}

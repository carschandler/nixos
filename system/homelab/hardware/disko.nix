let
  root_fs_partition = {
    size = "400G"; # GiB
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
      homelab = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_500GB_22127H802862";
        content = {
          type = "gpt";
          partitions = {
            ESP = boot_partition { mountpoint = "/boot"; };
            swap = swap_partition;
            zfs = root_fs_partition;
          };
        };
      };
      flash0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT4000P3PSSD8_2411E89FE7EE";
        content = {
          type = "gpt";
          partitions = {
            ESP = boot_partition { mountpoint = "/boot2"; };
            zfs-mirror = root_fs_partition;
            flash = {
              size = "100%";
              content = {
                type = "luks";
                name = "flashluks";
                passwordFile = "/tmp/secret.phrase";
                settings = {
                  # Enables TRIM; does have some security concerns, but they seem minor to me
                  allowDiscards = true;
                  # keyFile = "/tmp/secret.key";
                  # keyFileTimeout = 30;
                  # fallbackToPassword = true;
                };
                content = {
                  type = "zfs";
                  pool = "flashpool";
                };
              };
            };
          };
        };
      };
      # spin0 = {
      #   type = "disk";
      #   device = "FIXME";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       zfs = {
      #         size = "100%";
      #         content = {
      #           type = "zfs";
      #           pool = "spinpool";
      #         };
      #       };
      #     };
      #   };
      # };
    };
    # https://wiki.archlinux.org/title/Install_Arch_Linux_on_ZFS
    # https://jrs-s.net/2018/08/17/zfs-tuning-cheat-sheet/
    zpool = {
      rootpool = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "mirror";
                # This needs to be an absolute path value most likely
                # https://github.com/nix-community/disko/blob/380847d94ff0fedee8b50ee4baddb162c06678df/lib/types/zpool.nix#L140
                members = [
                  "/dev/disk/by-partlabel/disk-homelab-zfs"
                  "/dev/disk/by-partlabel/disk-flash0-zfs-mirror"
                ];
              }
            ];
          };
        };
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
      flashpool = {
        type = "zpool";
        # -O options for zpool create
        rootFsOptions = zfs_rootfs_options;
        # -o options for zpool create
        options = zfs_options;
        datasets = {
          "flashroot" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "flashroot/flash" = {
            type = "zfs_fs";
            mountpoint = "/flash";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}

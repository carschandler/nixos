{ config, lib, ... }:
let
  share = config.meta.fileshare;
  lan = config.meta.network.lan;
  exportTo = opts: lib.concatMapStringsSep " " (client: "${client}(${opts})") share.nfsClients;
in
{
  # Serve the share over NFS (for Linux) and Samba (for everything else)
  flake.modules.nixos.fileshare-server = {
    imports = [ config.flake.modules.nixos.fileshare ];

    fileSystems."/nfs${share.path}" = {
      device = share.path;
      fsType = "none";
      options = [ "bind" ];
    };

    services.nfs.server = {
      enable = true;
      exports = ''
        /nfs       ${exportTo "rw,fsid=0,no_subtree_check,sync"}
        /nfs${share.path} ${exportTo "rw,insecure,no_subtree_check,sync,nohide"}
      '';
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
    };

    networking.firewall = {
      enable = true;
      # for NFSv3; view with `rpcinfo -p`
      allowedTCPPorts = [
        111
        2049
        4000
        4001
        4002
        20048
      ];
      allowedUDPPorts = [
        111
        2049
        4000
        4001
        4002
        20048
      ];
    };

    services.samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "chandrive";
          "netbios name" = "chandrive";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "${lan.prefix}. fd00:: 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        flash = {
          "path" = share.path;
          "browseable" = "yes";
          "writable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # "force user" = "username";
          # "force group" = "groupname";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    services.avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
    };

  };
}

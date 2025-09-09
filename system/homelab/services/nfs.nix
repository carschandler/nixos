{
  config,
  pkgs,
  lib,
  ...
}:
{
  fileSystems."/nfs/flash" = {
    device = "/flash";
    options = [ "bind" ];
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /nfs       10.12.23.3(rw,fsid=0,no_subtree_check,sync)
      /nfs/flash 10.12.23.3(rw,insecure,no_subtree_check,sync,nohide)
    '';
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
  };

  networking.firewall = {
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
}

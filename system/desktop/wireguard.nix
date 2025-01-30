{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.useNetworkd = true;

  users.users.systemd-network = {
    extraGroups = [ "keys" ];
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          # Maximum transmission unit in bytes to set for the device
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/run/keys/wireguard-private";
          ListenPort = 51820;
          RouteTable = "main"; # wg-quick creates routing entries automatically but we must use use this option in systemd.
        };
        wireguardPeers = [
          # configuration since nixos-unstable/nixos-24.11
          {
            # macbook
            PublicKey = "X9U03TYA7e86HAHsdPseTCaZx6Jgj4Xs9YcJJ0C0m38=";
            AllowedIPs = [ "10.100.0.2" ];
          }
        ];
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = [ "10.100.0.1/24" ];
      networkConfig = {
        IPMasquerade = "ipv4";
      };
    };
  };
}

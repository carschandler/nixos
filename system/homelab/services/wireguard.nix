{ pkgs, ... }:
{
  # networking.nat = {
  #   enable = true;
  #   enableIPv6 = true;
  #   externalInterface = "eno1";
  #   internalInterfaces = [ "wg0" ];
  # };
  networking.firewall = {
    allowedUDPPorts = [
      61822
      61823
    ];
  };
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [
        "10.0.0.1/24"
        "fd00::1/64"
      ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 61822;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      # postSetup = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eno1 -j MASQUERADE
      # '';

      # This undoes the above command
      # postShutdown = ''
      #   ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o eno1 -j MASQUERADE
      # '';

      privateKeyFile = "/keep/wireguard-keys/private";
      generatePrivateKeyFile = true;
      # TODO generate public key automatically from private key

      peers = [
        # List of allowed peers.
        {
          # macbook
          # Feel free to give a meaning full name
          # Public key of the peer (not a file path).
          publicKey = "BFNgdnAQCmiF+Uc+9MKJXx0ntAxOpKP6KBNqglQtWBQ=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [
            "10.0.0.2/32"
            "fd00::2/64"
          ];
        }
      ];
    };
  };
}

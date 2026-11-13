{
  configurations.nixos.desktop-t9.module = {
    networking = {
      hostId = "bd4e6365";
      networkmanager.dns = "default";
      nameservers = [
        "8.8.8.8"
        "8.8.4.4"
        "1.1.1.1"
      ];

      firewall.allowedTCPPortRanges = [
        {
          from = 3000;
          to = 3100;
        }
      ];
    };

    # NOTE: networking.nftables.enable was previously true (for incus). It is now
    # removed: incus is disabled, and native-nftables mode conflicts with Docker,
    # which still manages its rules via iptables-nft. Running both produced two
    # independent rule sets over the same packets and silently dropped Tailscale's
    # inbound STUN replies (UDP: false). The default NixOS firewall (iptables-nft)
    # coexists cleanly with Docker. Re-enabling incus does not require flipping
    # this back on.

    services.tailscale = {
      # Tailscale MagicDNS (100.100.100.100) has been intermittently taking 6-9s
      # to resolve, occasionally exceeding the 5s timeout AWS SDK clients use for
      # credential/identity resolution. 1.1.1.1 is also blocked on this network.
      # Disable accept-dns and use Google's resolver instead (see networking.nameservers above).
      extraSetFlags = [ "--accept-dns=false" ];
    };
  };
}

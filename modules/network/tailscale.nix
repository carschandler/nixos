{
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      # Open the WireGuard UDP port
      openFirewall = true;
    };

    # Trust the tailscale0 interface, and loosen reverse-path filtering so
    # Tailscale's asymmetric (encrypted-in / decrypted-out) traffic is not
    # dropped.
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
    };
  };

  # Advertise this node as an exit node (0.0.0.0/0 + ::/0). "both" enables
  # IPv4 and IPv6 forwarding so subnet routing / exit-node actually works and
  # clears the "IP forwarding is disabled" health warning.
  flake.modules.nixos.tailscale-exit-node = {
    services.tailscale.useRoutingFeatures = "both";
  };

  flake.modules.darwin.tailscale = {
    homebrew.casks = [ "tailscale-app" ];
  };
}

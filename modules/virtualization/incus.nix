{ config, ... }:
{
  flake.modules.nixos.incus = {
    virtualisation.incus.enable = true;
    # Required for incus, but causes problems for docker (specifically docker
    # compose), so don't combine the two.
    networking.nftables.enable = true;
    # Let instances reach the host for DHCP/DNS
    networking.firewall.trustedInterfaces = [ "incusbr0" ];
    users.users.${config.meta.users.main.username}.extraGroups = [ "incus-admin" ];
  };
}

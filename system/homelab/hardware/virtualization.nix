{ lib, config, ... }:
{
  virtualisation.incus.enable = true;
  networking.nftables.enable = lib.mkIf config.virtualisation.incus.enable true;
}

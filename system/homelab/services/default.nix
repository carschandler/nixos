{ ... }:
{
  imports = [
    ./immich.nix
    ./samba.nix
    ./ssh.nix
    ./wireguard.nix
    ./cloudflare-dyndns.nix
  ];
}

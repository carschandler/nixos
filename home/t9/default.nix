{ pkgs, lib, ... }:
{
  home.packages = [
    pkgs.postman
    pkgs.slack
    pkgs.thunderbird
    ./lib.mkIf
    (lib.versionAtLeast pkgs.livekit-cli.version "2.4.1")
    (lib.warn "pkgs.livekit-cli has updated to 2.4.1; remove manual build" pkgs.livekit-cli)
    (pkgs.callPackage ./livekit-cli/package.nix { })
  ];
}

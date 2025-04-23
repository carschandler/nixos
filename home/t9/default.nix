{ pkgs, lib, ... }:
{
  home.packages = [
    # FIXME: need these on linux but not mac
    # pkgs.postman
    # pkgs.slack
    # pkgs.thunderbird
    (
      if (lib.versionAtLeast pkgs.livekit-cli.version "2.4.1") then
        (lib.warn "pkgs.livekit-cli has updated to 2.4.1; remove manual build" pkgs.livekit-cli)
      else
        (pkgs.callPackage ./livekit-cli/package.nix { })
    )
  ];
}

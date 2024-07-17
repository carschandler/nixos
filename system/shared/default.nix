{ pkgs, ... }:
{
  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
        libGL
        glib
        zbar
        # Included by default
        # zlib
        # zstd
        # stdenv.cc.cc
        # curl
        # openssl
        # attr
        # libssh
        # bzip2
        # libxml2
        # acl
        # libsodium
        # util-linux
        # xz
        # systemd
      ];
    };
  };

  services.dbus.enable = true;
}

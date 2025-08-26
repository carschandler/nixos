{ pkgs, ... }:
{
  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = [
        pkgs.libGL
        pkgs.glib
        pkgs.zbar
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

    appimage = {
      enable = true;
      binfmt = true;
    };

    npm = {
      enable = true;
    };
  };

  services.dbus.enable = true;

  # So that root can use them?
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}

{ pkgs, ... }:
{
  users.groups.fileshare = {
    gid = 1111;
    members = [
      "chan"
      "root"
    ];
  };

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
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}

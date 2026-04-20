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
      libraries = [
        pkgs.libGL
        pkgs.glib
        pkgs.zbar
        pkgs.libva.out
        pkgs.portaudio
        pkgs.libxcb
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
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://cache.flox.dev"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}

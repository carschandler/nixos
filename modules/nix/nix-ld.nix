{
  # Run unpatched dynamic binaries (uv-managed pythons, downloaded tools, ...)
  flake.modules.nixos.nix-ld =
    { pkgs, ... }:
    {
      # OpenSSL builds outside of Nix (e.g. uv's python-build-standalone via nix-ld)
      # default to /etc/ssl/cert.pem, which NixOS doesn't provide
      environment.etc."ssl/cert.pem".source = "/etc/ssl/certs/ca-certificates.crt";

      programs.nix-ld = {
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

      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    };
}

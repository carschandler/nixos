{ config, inputs, ... }:
{
  # Speech-to-text for Hyprland, using Parakeet on CUDA
  flake.modules.nixos.hyprwhspr =
    { pkgs, ... }:
    let
      # Same nixpkgs, evaluated with CUDA enabled globally. This is how
      # cache.nixos-cuda.org builds packages, so CUDA builds come from the cache
      # instead of compiling for an hour (a local `.override { cudaSupport = true; }`
      # produces a different derivation that is never cached).
      cudaPkgs = import inputs.nixpkgs {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };
    in
    {
      # required to listen for keyboard shortcuts
      users.users.${config.meta.users.main.username}.extraGroups = [ "input" ];

      services.hyprwhspr-rs = {
        enable = true;
        package = pkgs.hyprwhspr-rs.override {
          # Parakeet runs through onnxruntime, which is linked in
          inherit (cudaPkgs) onnxruntime;
          # whisper-cpp is only put on PATH for the Whisper backend, which we
          # don't use, so the default (cached, CPU-only) build is fine.
        };
      };
    };
}

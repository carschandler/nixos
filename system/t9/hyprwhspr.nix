{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # required to listen for keyboard shortcuts
  users.users.chan.extraGroups = [ "input" ];

  # have it auto start as a systemd unit with
  # services.hyprwhspr-rs.enable = true;

  # optional: to enable cuda (for AMD do `rocmSupport` instead of `cudaSupport`)
  # cuda is unfree so not in the default nixos build caches
  # I highly recommend adding the cuda build cache to your nixconfig https://discourse.nixos.org/t/cuda-cache-for-nix-community/56038
  services.hyprwhspr-rs = {
    enable = true;
    package = pkgs.hyprwhspr-rs.override {
      # to optimize build time you can skip enabling cudaSupport for one of these two
      # for whisper do whisper-cpp, for NVIDIA Parakeet do onnxruntime
      whisper-cpp = pkgs.whisper-cpp.override {
        cudaSupport = true;
        cudaPackages = pkgs.cudaPackages // {
          flags = pkgs.cudaPackages.flags // {
            cmakeCudaArchitecturesString = "61";
          };
        };
      };
      onnxruntime = pkgs.onnxruntime.override { cudaSupport = true; };
    };
  };
}

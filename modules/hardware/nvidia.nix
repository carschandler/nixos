{
  flake.modules.nixos.nvidia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      hardware.graphics = {
        enable = true;
        # VA-API on top of the nvidia VDPAU driver
        extraPackages = [ pkgs.libvdpau-va-gl ];
      };

      environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];

      # Enable GPU passthrough in docker using docker run --device=nvidia.com/gpu=all
      hardware.nvidia-container-toolkit.enable = lib.mkDefault config.virtualisation.docker.enable;

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        # Modesetting is needed for most Wayland compositors
        modesetting.enable = true;

        # Use the open source version of the kernel module
        # Only available on driver 515.43.04+
        open = false;

        # Enable the nvidia settings menu
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
      };

      # CUDA binary cache (after the general caches from the `nix` module)
      nix.settings = {
        extra-substituters = lib.mkAfter [
          "https://cache.nixos-cuda.org"
        ];
        extra-trusted-substituters = lib.mkAfter [
          "https://cache.nixos-cuda.org"
        ];
        extra-trusted-public-keys = lib.mkAfter [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };
    };
}

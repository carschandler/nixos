{ config, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      # Modesetting is needed for most Wayland compositors
      modesetting.enable = true;

      open = false;

      # Enable the nvidia settings menu
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # This fixed hyprland crashing after waking from suspend!
      # powerManagement.enable = true;

      # Experimental support for turning off GPU when not in use
      # Only available on notebooks (https://download.nvidia.com/XFree86/Linux-x86_64/435.17/README/dynamicpowermanagement.html)
      # powerManagement.finegrained = true;
    };
  };

  # CUDA binary cache
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}

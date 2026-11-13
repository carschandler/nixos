{
  # Accelerated video via the Intel media driver
  flake.modules.nixos.intel-video-acceleration =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        extraPackages = [
          pkgs.intel-media-driver
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
}

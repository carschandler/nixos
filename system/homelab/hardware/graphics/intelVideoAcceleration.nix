{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hardware.graphics.intelVideoAcceleration;
in
{
  options.hardware.graphics.intelVideoAcceleration = {
    enable = lib.mkEnableOption "accelerated video via Intel media driver";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = [
          pkgs.intel-media-driver
        ];
      };
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}

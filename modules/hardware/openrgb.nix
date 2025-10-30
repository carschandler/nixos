{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.openrgb = {
    services.hardware.openrgb.enable = true;
  };
}

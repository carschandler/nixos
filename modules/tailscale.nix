{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.tailscale = {
    services.tailscale.enable = true;
  };

  flake.modules.darwin.tailscale = {
    homebrew.casks = [ "tailscale" ];
  };
}

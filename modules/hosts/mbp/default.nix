{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin.mbp.module = {
    imports = with darwin; [
      base
      tailscale
    ];

    system.stateVersion = 5;
    ids.gids.nixbld = 30000;
  };

  configurations.home."chan@mbp" = {
    system = "aarch64-darwin";
    module = {
      imports = with homeManager; [
        base
        mac
      ];

      home.stateVersion = "24.05";
    };
  };
}

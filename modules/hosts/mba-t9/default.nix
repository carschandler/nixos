{ config, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
in
{
  configurations.darwin.mba-t9.module = {
    imports = with darwin; [
      base
      tailscale
      t9
    ];

    system.stateVersion = 5;
    ids.gids.nixbld = 350;
  };

  configurations.home."chan@mba-t9" = {
    system = "aarch64-darwin";
    module = {
      imports = with homeManager; [
        base
        mac
        t9
      ];

      home.stateVersion = "24.05";
    };
  };
}

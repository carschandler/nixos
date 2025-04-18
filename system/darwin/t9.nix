{ lib, config, ... }:
let
  cfg = config.t9;
in
{
  options.t9 = {
    enable = lib.mkEnableOption "Transform9 configuration";
    apps = {
      communication = {
        enable = lib.mkEnableOption "communication apps";
      };
      development = {
        enable = lib.mkEnableOption "development apps";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    t9.apps.communication.enable = lib.mkDefault true;
    t9.apps.development.enable = lib.mkDefault true;

    homebrew.brews = [
      "livekit-cli"
    ];

    homebrew.casks =
      [ "jordanbaird-ice" ]
      ++ lib.optionals cfg.apps.communication.enable [
        "slack"
        "emclient"
      ]
      ++ lib.optionals cfg.apps.development.enable [
        "postman"
      ];

    ids.gids.nixbld = lib.mkForce 350;
    networking.hostName = lib.mkForce "mba-t9";
  };
}

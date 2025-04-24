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

    homebrew = {
      brews = [
        "aws-amplify"
      ];
      casks =
        [ "jordanbaird-ice" ]
        ++ lib.optionals cfg.apps.communication.enable [
          "slack"
        ]
        ++ lib.optionals cfg.apps.development.enable [
          "postman"
        ];
    };

  };
}

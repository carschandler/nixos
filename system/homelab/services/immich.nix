{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.immich = {
    enable = true;
    # In case we need to roll back to an older version...
    # package = pkgs.immich.override {
    #   sourcesJSON = ./immichsources.json;
    # };
    openFirewall = true;
    host = "::";
    mediaLocation = "/flash/services/immich";
    database.enableVectors = false;
  };

  hardware.graphics.intelVideoAcceleration.enable = true;

  users.users.immich.extraGroups = [
    "video"
    "render"
    "fileshare"
  ];

  systemd.tmpfiles.settings = {
    "immich-media-location" = {
      "/flash/services/immich" = {
        d = {
          group = "immich";
          mode = "0775";
          user = "immich";
        };
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.immich = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
    mediaLocation = "/flash/services/immich";
  };

  hardware.graphics.intelVideoAcceleration.enable = true;

  users.users.immich.extraGroups = [
    "video"
    "render"
    "smb"
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

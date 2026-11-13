{ config, ... }:
{
  flake.modules.nixos.networkmanager = {
    networking.networkmanager.enable = true;
    users.users.${config.meta.users.main.username}.extraGroups = [ "networkmanager" ];
  };
}

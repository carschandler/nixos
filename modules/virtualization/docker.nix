{ config, ... }:
{
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
    users.users.${config.meta.users.main.username}.extraGroups = [ "docker" ];
  };
}

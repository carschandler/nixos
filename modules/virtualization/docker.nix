{
  config,
  ...
}:
{
  flake.modules.nixos.docker = {
    services.virtualisation.docker = true;
    users.groups.docker.members = config.flake.users.admins;
  };
}

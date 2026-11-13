{ config, ... }:
{
  # Mouse/keyboard macro recorder
  flake.modules.nixos.crossmacro = {
    services.crossmacro = {
      enable = true;
      users = [ config.meta.users.main.username ];
    };
  };
}

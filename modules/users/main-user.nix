# The primary account. Hosts still set their own password hash.
{ config, ... }:
let
  inherit (config.meta.users) main;
in
{
  flake.modules.nixos.main-user = {
    users.users.${main.username} = {
      isNormalUser = true;
      home = "/home/${main.username}";
      description = main.name;
      extraGroups = [ "wheel" ];
    };
  };

  flake.modules.darwin.main-user = {
    system.primaryUser = main.username;
  };

  flake.modules.homeManager.main-user =
    { pkgs, ... }:
    {
      home = {
        inherit (main) username;
        homeDirectory =
          if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${main.username}" else "/home/${main.username}";
      };
    };
}

{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.main-user = {
    users.mutableUsers = false;
    users.users.${config.flake.users.main.username} = {
      isNormalUser = true;
      home = "/home/${config.flake.users.main.username}";
      description = config.flake.users.main.name;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$uxCqrhaofIQdeJERyH4ZB/$d7LgPgp3CLQNSKnkLYKLZqrXS/F3gqfMDKglePFWmWB";
    };
  };

  flake.modules.homeManager.main-user =
    { pkgs, ... }:
    {
      home = {
        username = config.flake.users.main;
        homeDirectory =
          if pkgs.stdenv.isDarwin then
            "/Users/${config.flake.users.main}"
          else
            "/home/${config.flake.users.main}";
      };
    };
}

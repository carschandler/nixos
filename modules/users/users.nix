{
  inputs,
  config,
  lib,
  ...
}:
let
  eachUser = users: fn: builtins.map fn users;
in
{
  flake.users = rec {
    main = {
      username = "chan";
      name = "Cars Chandler";
    };
    admins = [ main.username ];
    guests = [ ];
  };

  flake.modules.nixos.users = {
    users.mutableUsers = false;
  };
}

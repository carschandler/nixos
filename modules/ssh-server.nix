{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.ssh-server = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "prohibit-password";
        AllowUsers = config.flake.users.admins;
      };
    };

    users.users.chan.openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ./ssh-keys;
  };
}

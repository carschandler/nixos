{ config, ... }:
{
  flake.modules.nixos.ssh-server =
    { lib, ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
          AllowUsers = config.meta.users.admins;
        };
      };

      users.users.${config.meta.users.main.username}.openssh.authorizedKeys.keyFiles =
        lib.filesystem.listFilesRecursive ./ssh-keys;
    };
}

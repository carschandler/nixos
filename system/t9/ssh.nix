{ lib, ... }:
{
  services.openssh = {
    enable = true;
    ports = [
      22
      3022
    ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      AllowUsers = [ "chan" ];
    };
  };

  users.users.chan.openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ../../keys;
  # users.users.chan.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArumpJlbFQwex6lN/vUMVk6q1WTCu+PxeBIvTB9rr9P garrettyarmowich@gyarmo.local"
  # ];
}

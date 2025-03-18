{ ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      AllowUsers = [ "chan" ];
    };
  };
  users.users.chan.openssh.authorizedKeys.keyFiles = [
    ../../../keys/desktop
    ../../../keys/laptop
    ../../../keys/macbook
    ../../../keys/iphone
  ];
}

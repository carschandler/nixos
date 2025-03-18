{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./graphics
    ./powerManagement.nix
    ./virtualization.nix
  ];
}

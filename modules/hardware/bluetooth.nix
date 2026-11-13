{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      # Enable blueman for managing connections
      services.blueman.enable = true;
      environment.systemPackages = [
        pkgs.overskride
      ];
    };
}

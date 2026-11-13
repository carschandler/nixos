{
  # Auto-mount USB drives
  flake.modules.nixos.automount = {
    services.gvfs.enable = true;
    services.devmon.enable = true;
    services.udisks2.enable = true;
  };
}

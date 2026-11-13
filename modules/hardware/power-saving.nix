{
  flake.modules.nixos.power-saving = {
    powerManagement.powertop.enable = true;
  };
}

{
  # TUI display manager
  flake.modules.nixos.ly = {
    services.displayManager.ly.enable = true;
  };
}

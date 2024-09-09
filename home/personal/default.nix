# Stuff we need on personal machines, but not at work
{
  pkgs,
  config,
  inputs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  imports = [
    ../fonts
  ];

  xdg.configFile = {
    foot.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/foot/dot-config/foot";
  };
}

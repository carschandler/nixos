# Home-manager setup every host gets, on any OS.
{ config, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  flake.modules.homeManager.base =
    { config, ... }:
    let
      homedir = config.home.homeDirectory;
    in
    {
      imports = with homeManager; [
        main-user
        nix
        shells
        cli-tools
        scripts
        vcs
        neovim
        languages
        ai-agents
      ];

      programs.home-manager.enable = true;

      home.sessionVariables = {
        HMDIR = "${homedir}/nixos/modules";
        DOTFILES = "${homedir}/nixos/dotfiles";
        DEVSHELLS = "${homedir}/nixos/devshells";
        # Gruvbox color palette
        NNN_FCOLORS = "020b0c0a00060e0701d60d09";
      };

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
    };
}

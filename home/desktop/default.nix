{ pkgs, ... }:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.clonehero
    pkgs.nvtop
  ];
  programs.obs-studio = {
    enable = true;
  };
}

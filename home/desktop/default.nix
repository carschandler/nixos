{ pkgs, ... }:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.clonehero
    pkgs.nvtopPackages.full
  ];
  programs.obs-studio = {
    enable = true;
  };
  programs.spotify-player = {
    enable = true;
  };
}

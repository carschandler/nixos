{ pkgs, ... }:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.clonehero
    # pkgs.nvtopPackages.nvidia
    pkgs.slack
  ];
  programs.obs-studio = {
    enable = true;
  };
  programs.spotify-player = {
    enable = true;
  };
}

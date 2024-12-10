{ pkgs, ... }:
{
  home.packages = [
    pkgs.prismlauncher
    pkgs.clonehero
    pkgs.ladybird
  ];

  home.stateVersion = "22.11";
}

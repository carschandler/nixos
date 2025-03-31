{ pkgs, ... }:
{
  home.packages = [
    pkgs.postman
    pkgs.slack
    pkgs.thunderbird
  ];
}

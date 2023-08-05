{ pkgs, ... }: {
  imports = [
    ../fonts
  ];

  home.packages = [
    pkgs.libreoffice-fresh
  ];
}


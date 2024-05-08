{ config, pkgs, ... }:
{
  nixpkgs.config.input-fonts.acceptLicense = true;

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [
     "SourceCodePro"
     "CommitMono"
    ]; })
    
    source-code-pro
    cantarell-fonts
    public-sans
    ibm-plex
    inter
    lato
    roboto
    noto-fonts-lgc-plus
    # input-fonts
  ];

  fonts.fontconfig.enable = true;
}

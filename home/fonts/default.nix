{ config, pkgs, ... }:
{
  nixpkgs.config.input-fonts.acceptLicense = true;

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [
     "SourceCodePro"
     "Hack"
     "Iosevka"
     "Hasklig"
    ]; })
    
    source-code-pro
    cantarell-fonts
    #input-fonts
  ];

  fonts.fontconfig.enable = true;
}

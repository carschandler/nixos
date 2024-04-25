{ config, pkgs, ... }:
{
  nixpkgs.config.input-fonts.acceptLicense = true;

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [
     "SourceCodePro"
    ]; })
    
    source-code-pro
    cantarell-fonts
    public-sans
    # input-fonts
  ];

  fonts.fontconfig.enable = true;
}

{ config, pkgs, ... }:
{
  nixpkgs.config.input-fonts.acceptLicense = true;

  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [
     "SourceCodePro"
     "CommitMono"
    ]; })
    
    freefont_ttf
    source-code-pro
    cantarell-fonts
    public-sans
    ibm-plex
    inter
    lato
    roboto
    # input-fonts
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ (import ./systemFonts).sans.name ];
      monospace = [ (import ./systemFonts).monospace.name ];
      serif = [ (import ./systemFonts).serif.name ];
    };
  };
}

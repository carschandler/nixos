{ config, ... }:
let
  inherit (config.meta) fonts;
in
{
  flake.modules.homeManager.fonts =
    { pkgs, ... }:
    {
      nixpkgs.config.input-fonts.acceptLicense = true;

      home.packages = with pkgs; [
        nerd-fonts.commit-mono
        nerd-fonts.sauce-code-pro
        freefont_ttf
        source-code-pro
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
          sansSerif = [ fonts.sans.name ];
          monospace = [ fonts.monospace.name ];
          serif = [ fonts.serif.name ];
        };
      };
    };
}

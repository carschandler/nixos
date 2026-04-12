{ ... }:
{
  flake.modules.homeManager.mako = {
    programs.mako = {
      enable = true;
      settings = {
        backgroundColor = "#282828E6";
        borderColor = "#BBBBBBCC";
        borderRadius = 10;
        borderSize = 2;
        margin = 10;
        defaultTimeout = 10000;
        font = (import ../fonts/systemFonts).sans.name;
      };
    };
  };
}

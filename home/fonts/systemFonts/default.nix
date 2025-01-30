let
  mkSystemFont =
    {
      name,
      getPackage,
      relFilesDir,
      fileName,
      boldName,
      boldFileName,
    }:
    rec {
      inherit name fileName getPackage;
      getFileDir = pkgs: "${getPackage pkgs}/${relFilesDir}";
      getFile = pkgs: "${getFileDir pkgs}/${fileName}";
      bold = {
        name = boldName;
        fileName = boldFileName;
        getFile = pkgs: "${getFileDir pkgs}/${fileName}";
      };
    };
in
rec {
  sans = Inter;
  monospace = CommitMono;
  serif = FreeSerif;

  FreeSans = mkSystemFont rec {
    name = "FreeSans";
    getPackage = pkgs: pkgs.freefont_ttf;
    relFilesDir = "share/fonts/truetype";
    fileName = "FreeSans.ttf";
    boldName = "${name} Bold";
    boldFileName = "${name}Bold.ttf";
  };
  CommitMono = mkSystemFont rec {
    name = "CommitMono Nerd Font";
    getPackage = pkgs: pkgs.nerd-fonts.commit-mono;
    relFilesDir = "share/fonts/opentype/NerdFonts";
    fileName = "CommitMonoNerdFont-Regular.otf";
    boldName = "${name} Bold";
    boldFileName = "CommitMonoNerdFont-Bold.otf";
  };
  FreeSerif = mkSystemFont rec {
    name = "FreeSerif";
    getPackage = pkgs: pkgs.freefont_ttf;
    relFilesDir = "share/fonts/truetype";
    fileName = "FreeSerif.ttf";
    boldName = "${name} Bold";
    boldFileName = "${name}Bold.ttf";
  };
  Inter = mkSystemFont rec {
    name = "Inter";
    getPackage = pkgs: pkgs.inter;
    relFilesDir = "share/fonts/truetype";
    fileName = "InterVariable.ttf";
    boldName = "${name} Bold";
    boldFileName = fileName;
  };
}

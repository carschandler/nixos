{
  description = "Python Data Science Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      python_package = "python3";
      pypkgs =
        ps: with ps; [
          debugpy
          ipython
          jupyter

          (matplotlib.override { enableQt = true; })
          numpy
          pandas
          pillow
          plotly
          scipy
          seaborn
          xarray
        ];
      py = pkgs.${python_package}.withPackages pypkgs;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = [
          py
          pkgs.black
        ];

        # Might be required for matplotlib depending on platform
        QT_PLUGIN_PATH = with pkgs.qt5; "${qtbase}/${qtbase.qtPluginPrefix}";
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

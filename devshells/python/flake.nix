{
  description = "Python Data Science Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    let
      python_package = "python312";
      pypkgs = ps: with ps; [
        ipython
        jupyter
        numpy
        pandas
        scipy
        seaborn
        plotly
        xarray
        matplotlib.override { enableGtk3 = true; }
      ];
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        py = pkgs.${python_package}.withPackages pypkgs;
      in {
        devShells.default = pkgs.mkShell {

          packages = [ 
            py
            pkgs.black
          ];

          buildInputs = [
            # pkgs.qt5.qtwayland
          ];

          # QT_PLUGIN_PATH = with pkgs.qt5; "${qtbase}/${qtbase.qtPluginPrefix}";
        };
      }
    );
}

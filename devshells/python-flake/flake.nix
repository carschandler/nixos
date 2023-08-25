{
  description = "Python Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      python_package = "python3";
      pypkgs = ps: with ps; [
        ipython
        numpy
        scipy
        pandas
        seaborn
        jupyter
        plotly
        vtk
        matplotlib.override { enableQt = true; }
        opencv4
        # feeble attempts at other backends
        # tkinter
        # pygobject3

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
            pkgs.qt5.qtwayland
          ];

          shellHook = ''
            alias jnb='jupyter notebook --no-browser'
          '';

          QT_PLUGIN_PATH = with pkgs.qt5; "${qtbase}/${qtbase.qtPluginPrefix}";
        };
      }
    );
}

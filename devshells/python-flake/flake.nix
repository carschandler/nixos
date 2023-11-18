{
  description = "Python Data Science Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      python_package = "python3";
      pypkgs = ps: with ps; [
        ipython
        jupyter
        numpy
        pandas
        scipy
        seaborn
        plotly
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

          shellHook = ''
            alias jnb='jupyter notebook'
            alias jnbnb='jupyter notebook --no-browser'
          '';

          # QT_PLUGIN_PATH = with pkgs.qt5; "${qtbase}/${qtbase.qtPluginPrefix}";
        };
      }
    );
}

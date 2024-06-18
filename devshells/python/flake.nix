{
  description = "Python Data Science Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      python_package = "python3";
      pypkgs = ps: with ps; [
        debugpy
        ipython
        jupyter
        matplotlib.override { enableGtk3 = true; }
        numpy
        pandas
        plotly
        scipy
        seaborn
        xarray
      ];
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      py = pkgs.${python_package}.withPackages pypkgs;
    in {
        devShells.x86_64-linux.default = pkgs.mkShell {
          packages = [ 
            py
            pkgs.black
          ];
        };

        formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}

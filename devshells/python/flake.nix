{
  description = "Python Data Science Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
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
          devShells.default = pkgs.mkShell {
            packages = [
              py
              pkgs.black
            ];

            # Might be required for matplotlib depending on platform
            QT_PLUGIN_PATH = with pkgs.qt5; "${qtbase}/${qtbase.qtPluginPrefix}";
          };

          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}

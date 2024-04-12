{
  description = "Python Data Science Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fhs = pkgs.buildFHSUserEnv {
          name = "my-fhs-environment";

          targetPkgs = _: [
            pkgs.micromamba
          ];

          profile = ''
            set -e
            eval "$(micromamba shell hook --shell=posix)"
            export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.micromamba
            set +e
          '';
        };
      in {
        devShells.default = fhs.env;
      }
    );
}

{
  description = "Python Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = [ 
            pkgs.jdt-language-server
            pkgs.python39
            pkgs.temurin-bin-8
            pkgs.maven
          ];

          # shellHook = ''
          # '';
        };
      }
    );
}

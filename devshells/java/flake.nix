{
  description = "Java devshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        {
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.jdt-language-server
              pkgs.vscode-extensions.vscjava.vscode-java-debug
              pkgs.temurin-bin-8
              pkgs.maven
            ];
          };

          JAVA_DEBUG_PATH = pkgs.vscode-extensions.vscjava.vscode-java-debug;
          formatter = pkgs.nixfmt-rfc-style;
        };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}

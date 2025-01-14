{
  description = "Java Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.jdt-language-server
          pkgs.vscode-extensions.vscjava.vscode-java-debug
          pkgs.temurin-bin-8
          pkgs.maven
        ];

        JAVA_DEBUG_PATH = pkgs.vscode-extensions.vscjava.vscode-java-debug;
      };

      formatter.x86_64-linux = pkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

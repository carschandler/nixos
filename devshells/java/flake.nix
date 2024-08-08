{
  description = "Python Shell";

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
          pkgs.python39
          pkgs.temurin-bin-8
          pkgs.maven
        ];

        formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      };
    };
}

{
  description = "Rust devshell";

  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      naersk,
    }:
    let
      pkgs = import nixpkgs.legacyPackages.x86_64-linux;
      naersk-lib = pkgs.callPackage naersk { };
    in
    {
      defaultPackage.x86_64-linux = naersk-lib.buildPackage ./.;

      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.cargo
          pkgs.rustc
          pkgs.rustfmt
          pkgs.rust-analyzer
          pkgs.rustPackages.clippy
        ];

        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

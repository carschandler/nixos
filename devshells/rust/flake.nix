{
  description = "Rust devshell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    { nixpkgs, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs { inherit system overlays; };

      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" ];
        # targets = [];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          rustToolchain
          (pkgs.rust-analyzer.override { rustSrc = "${rustToolchain}/lib/rustlib/src/rust/library"; })
        ];
      };
    };
}

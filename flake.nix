{
  description = "Chan's NixOS & Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # wezterm = {
    #   url = "github:wezterm/wezterm?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # opencode = {
    #   url = "github:anomalyco/opencode";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    conview = {
      url = "git+ssh://git@github.com/Transform9/conview.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    inputs:
    # Every .nix file under ./modules is a flake-parts module (paths containing
    # a `_`-prefixed segment are skipped by import-tree). See README.md.
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}

{ inputs, ... }:
let
  settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.flox.dev"
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.flox.dev"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
    ];
  };
in
{
  flake.modules.nixos.nix = {
    # So that root can use them too
    nix = { inherit settings; };
    nixpkgs.config.allowUnfree = true;
  };

  flake.modules.homeManager.nix =
    { pkgs, ... }:
    {
      nix = {
        enable = true;
        package = pkgs.nix;
        settings = {
          inherit (settings) experimental-features;
        };
        # Pin the nixpkgs version that this flake uses to the registry so that
        # `nix` commands use the same nixpkgs as our system does
        registry.nixpkgs.flake = inputs.nixpkgs;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };

      nixpkgs = {
        overlays = [ ];
        config = {
          allowUnfree = true;
        };
      };

      home.sessionVariables.NIXPKGS_ALLOW_UNFREE = 1;
    };
}

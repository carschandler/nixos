{
  description = "Chan's NixOS & Home Manager configuration flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/desktop
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./system/laptop
          hyprland.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      "chan@desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home/home.nix
        ];
      };
      "chan@laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # pkgs = import nixpkgs {
        #   inherit system;
        #   overlays = [];
        # }; 
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home/home.nix
          hyprland.homeManagerModules.default
        ];
      };
    };
  };
}

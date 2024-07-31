{
  description = "Chan's NixOS & Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # Don't override hyprland's nixpkgs or the Cachix won't work
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
    };

    # emanote = {
    #   url = "github:srid/emanote";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./system/desktop ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./system/laptop ];
        };

        TORCH-LT-7472 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/work
            nixos-wsl.nixosModules.default
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
            ./home/shared
            ./home/personal
            ./home/desktop
          ];
        };
        "chan@laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/personal
          ];
        };
        "chan@TORCH-LT-7472" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/work
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

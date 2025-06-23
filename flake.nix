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

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/desktop
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./system/laptop ];
        };

        homelab = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./system/homelab
            inputs.disko.nixosModules.disko
            inputs.lanzaboote.nixosModules.lanzaboote
          ];
        };

        desktop-t9 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.disko.nixosModules.disko
            ./system/t9
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
            ./home/hyprland
            ./home/linux
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
            ./home/hyprland
            ./home/linux
          ];
        };

        "chan@homelab" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/homelab
          ];
        };

        "cchandler@astro" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/torch
            ./home/torch/astro
            ./home/linux
          ];
        };

        "chan@mbp" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/personal
            ./home/mac
          ];
        };

        "chan@mba-t9" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/personal
            ./home/mac
            ./home/t9
          ];
        };

        "chan@desktop-t9" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/linux
            ./home/t9
            ./home/hyprland
            ./home/personal
          ];
        };
      };

      darwinConfigurations = {
        "mbp" = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin/hosts/mbp
          ];
          specialArgs = {
            inherit inputs;
          };
        };

        "mba-t9" = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin/hosts/mba-t9
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

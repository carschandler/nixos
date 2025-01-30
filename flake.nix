{
  description = "Chan's NixOS & Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Don't override hyprland's nixpkgs or the Cachix won't work
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-contrib.url = "github:hyprwm/contrib";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nixos-wsl,
      nix-darwin,
      nix-homebrew,
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
            inputs.nixos-cosmic.nixosModules.default
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
            disko.nixosModules.disko
            inputs.lanzaboote.nixosModules.lanzaboote
          ];
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
        "chan@TORCH-LT-7472" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/work
            ./home/work/laptop
          ];
        };
        "cchandler@astro" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home/shared
            ./home/work
            ./home/work/astro
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
      };

      darwinConfigurations = {
        "mbp" = nix-darwin.lib.darwinSystem {
          modules = [
            ./system/darwin
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "chan";
              };
            }
          ];
          # specialArgs = {
          #   inherit inputs;
          # };
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

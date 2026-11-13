# Turns `configurations.<class>.<name>.module` into flake outputs.
#
# `module` is a deferred module, so any number of files can contribute to the
# same host; e.g. modules/hosts/homelab/*.nix all define
# `configurations.nixos.homelab.module`.
{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkOption types;

  configurationType =
    extraOptions:
    types.lazyAttrsOf (
      types.submodule {
        options = {
          module = mkOption {
            type = types.deferredModule;
            description = "Module defining this configuration; usually just imports from `flake.modules`.";
          };
        }
        // extraOptions;
      }
    );
in
{
  options.configurations = {
    nixos = mkOption {
      type = configurationType { };
      default = { };
      description = "NixOS hosts, exposed as `nixosConfigurations.<name>`.";
    };

    darwin = mkOption {
      type = configurationType { };
      default = { };
      description = "nix-darwin hosts, exposed as `darwinConfigurations.<name>`.";
    };

    home = mkOption {
      type = configurationType {
        system = mkOption {
          type = types.str;
          example = "x86_64-linux";
          description = "System whose nixpkgs this standalone home-manager configuration is built with.";
        };
      };
      default = { };
      description = ''Standalone home-manager configurations, exposed as `homeConfigurations."<user>@<host>"`.'';
    };
  };

  config.flake = {
    nixosConfigurations = lib.mapAttrs (
      name:
      { module }:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [
          module
          { networking.hostName = lib.mkDefault name; }
        ];
      }
    ) config.configurations.nixos;

    darwinConfigurations = lib.mapAttrs (
      name:
      { module }:
      inputs.nix-darwin.lib.darwinSystem {
        modules = [
          module
          { networking.hostName = lib.mkDefault name; }
        ];
      }
    ) config.configurations.darwin;

    homeConfigurations = lib.mapAttrs (
      _:
      { system, module }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [ module ];
      }
    ) config.configurations.home;
  };
}

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixgl,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [ ../fonts ];

  nixpkgs = { };

  # Add stuff for your user as you see fit
  home.packages = with pkgs; [
    # TODO: find out if there is a way to make nixGL work with nvidia on WSL
    # pkgs.nixgl.auto.nixGLNvidia
    pixi
    meld
  ];

  programs = {
    ssh = {
      enable = true;
      matchBlocks = {
        "canasta" = {
          hostname = "canasta.torch2003.com";
          user = "rchandler";
        };
        "fs2" = {
          hostname = "fs2.torch2003.com";
          user = "rchandler";
        };
        "astro" = {
          hostname = "10.5.21.78";
          user = "cchandler";
        };
      };
    };

    git.extraConfig = {
      "http \"https://repo.torchtechnologies.com\"" = {
        sslCAInfo = "${config.home.homeDirectory}/nixos/home/work/certs/DigiCertGlobalG2TLSRSASHA2562020CA1-1.pem";
      };
    };
  };

  home.stateVersion = "23.11";
}

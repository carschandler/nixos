{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nixgl,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  # You can import other home-manager modules here
  imports = [ ../fonts ];

  nixpkgs = { };

  # Add stuff for your user as you see fit
  home.packages = with pkgs; [
    # TODO: find out if there is a way to make nixGL work with nvidia on WSL
    # pkgs.nixgl.auto.nixGLNvidia
    ollama
    pixi
  ];

  home.file.".local/bin/clip.exe".source = symlink "/mnt/c/Windows/System32/clip.exe";
  home.file.".local/bin/explorer.exe".source = symlink "/mnt/c/Windows/explorer.exe";
  home.file.".local/bin/powershell.exe".source = symlink "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";
  home.file.".local/bin/excel.exe".source = symlink "/mnt/c/Program Files/Microsoft Office/root/Office16/EXCEL.EXE";
  home.file.".local/bin/code".source = symlink "/mnt/c/Users/rchandler/AppData/Local/Programs/Microsoft VS Code Insiders/bin/code-insiders";

  home.sessionVariables = {
    BROWSER = "/mnt/c/Users/rchandler/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe";
    # BROWSER = "/mnt/c/Users/rchandler/AppData/Local/Microsoft/WindowsApps/Arc.exe";
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "NVIDIA";
  };

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

    bash = {
      bashrcExtra = ''
        MICROMAMBA_INIT="${config.home.homeDirectory}/.activate_micromamba.sh"
        if [[ -e $MICROMAMBA_INIT ]]; then
          source $MICROMAMBA_INIT
        fi
      '';
    };

    git.extraConfig = {
      "http \"https://repo.torchtechnologies.com\"" = {
        sslCAInfo = "${config.home.homeDirectory}/nixos/home/work/certs/DigiCertGlobalG2TLSRSASHA2562020CA1-1.pem";
      };
      credential.helper = "/mnt/c/Users/rchandler/AppData/Local/Programs/Git/mingw64/bin/git-credential-manager.exe";
    };
  };

  home.stateVersion = "23.11";
}

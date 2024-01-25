{ inputs, outputs, lib, config, pkgs, nixgl, ... }: {
  # You can import other home-manager modules here
  imports = [
    ../fonts
  ];

  nixpkgs = {
  };

  # Add stuff for your user as you see fit
  home.packages = with pkgs; [
    # TODO: find out if there is a way to make nixGL work with nvidia on WSL
    # pkgs.nixgl.auto.nixGLNvidia
  ];
  
  home.file.".local/bin/clip.exe".source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Windows/System32/clip.exe";
  home.file.".local/bin/powershell.exe".source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";
  home.file.".local/bin/excel.exe".source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Program Files/Microsoft Office/root/Office16/EXCEL.EXE";
  home.file.".local/bin/code".source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/rchandler/AppData/Local/Programs/Microsoft VS Code Insiders/bin/code-insiders";

  home.sessionVariables = {
    BROWSER = "/mnt/c/Users/rchandler/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe";
  };

  programs.ssh = {
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
    };
  };

  home.stateVersion = "23.11";
}

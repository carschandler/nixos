{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    ../fonts
  ];

  # Add stuff for your user as you see fit
  home.packages = with pkgs; [
  ];
  
  home.file.".local/bin/clip.exe".source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Windows/System32/clip.exe";
  home.file.".local/bin/powershell.exe".source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe";

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
}

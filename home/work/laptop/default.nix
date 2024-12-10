{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  programs = {
    git.extraConfig = {
      credential.helper = "/mnt/c/Users/rchandler/AppData/Local/Programs/Git/mingw64/bin/git-credential-manager.exe";
    };
  };

  home.sessionVariables = {
    BROWSER = "/mnt/c/Program Files/Zen Browser/zen.exe";
    # BROWSER = "/mnt/c/Users/rchandler/AppData/Local/BraveSoftware/Brave-Browser/Application/brave.exe";
    # BROWSER = "/mnt/c/Users/rchandler/AppData/Local/Microsoft/WindowsApps/Arc.exe";
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "NVIDIA";
  };

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

  home.stateVersion = "23.11";
}

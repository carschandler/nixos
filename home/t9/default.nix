{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  # programs.hyprpanel = {
  #   enable = true;
  #   systemd.enable = true;
  # };

  # programs.bash.profileExtra = ''
  #   if [[ ! -z $DISPLAY ]] uwsm check may-start && uwsm select; then
  #     exec uwsm start default
  #   fi
  # '';

  home.packages = [
    # (pkgs.callPackage ./awscli2/package.nix { })
    pkgs.awscli2
    # pkgs.aws-sam-cli
    pkgs.terraform
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.typescript-language-server
    (
      if (lib.versionAtLeast pkgs.livekit-cli.version "2.4.1") then
        (lib.warn "pkgs.livekit-cli has updated to 2.4.1; remove manual build" pkgs.livekit-cli)
      else
        (pkgs.callPackage ./livekit-cli/package.nix { })
    )
    pkgs.github-copilot-cli
  ];

  programs = {
    claude-code = {
      enable = true;
    };
    codex = {
      enable = true;
    };
    gemini-cli.enable = true;
    opencode = {
      enable = true;
      settings = {
        permission = {
          edit = "ask";
          webfetch = "ask";
          bash = {
            "*" = "ask";
            "terraform *" = "deny";
            "rg *" = "allow";
            "grep *" = "allow";
            "jq *" = "allow";
            "git diff *" = "allow";
            "git status *" = "allow";
            "git log *" = "allow";
            "ls *" = "allow";
            "pwd" = "allow";
          };
        };
      };
    };
  };
}

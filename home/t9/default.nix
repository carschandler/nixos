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
    pkgs.awscli2
    pkgs.aws-sam-cli
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
  ];

  programs = {
    claude-code = {
      enable = true;
    };
    codex = {
      enable = true;
    };
  };
}

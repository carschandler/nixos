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

  home.packages = (
    [
      inputs.conview.packages.${pkgs.stdenv.hostPlatform.system}.default

      # (pkgs.callPackage ./awscli2/package.nix { })
      pkgs.act
      pkgs.awscli2
      pkgs.ssm-session-manager-plugin
      # pkgs.aws-sam-cli
      pkgs.terraform
      pkgs.ngrok
      pkgs.nodejs_24
      pkgs.pnpm
      pkgs.typescript-language-server
      pkgs.twilio-cli
      pkgs.crush
      pkgs.ffmpeg
      pkgs.livekit-cli
    ]
    ++ (if lib.strings.hasSuffix "linux" pkgs.stdenv.hostPlatform.system then [ pkgs.vite ] else [ ])
  );

  programs = {
    # claude-code = {
    #   enable = true;
    # };
    codex = {
      enable = true;
    };
  };
}

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
      pkgs.hunk
    ]
    ++ (
      if lib.strings.hasSuffix "linux" pkgs.stdenv.hostPlatform.system then
        [
          pkgs.vite
          pkgs.livekit-cli
        ]
      else
        [ ]
    )
  );

  # Terraform keeps a private copy of every provider in each root's
  # .terraform/ dir (~300MB per aws provider, and this monorepo has 14 roots).
  # Point it at a shared cache so each root symlinks into a single copy
  # instead. Note that Terraform never prunes this directory, so stale
  # versions must be deleted by hand after a `terraform init -upgrade`.
  home.file.".terraformrc".text = ''
    plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
  '';

  # Load-bearing: Terraform will not create the cache directory itself, and
  # silently falls back to per-root copies if it is missing.
  home.file.".terraform.d/plugin-cache/.keep".text = "";

  programs = {
    claude-code = {
      enable = true;
    };
    codex = {
      enable = true;
    };
  };
}

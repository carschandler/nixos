{
  # Offline speech-to-text (Parakeet/Whisper). Pick the model in Handy's own
  # settings. On Wayland it can't grab global shortcuts, so the compositor binds
  # `handy --toggle-transcription` (see the hyprland dotfiles).
  flake.modules.homeManager.handy =
    { lib, pkgs, ... }:
    {
      home.packages = [
        pkgs.handy
      ]
      # Types the transcription into the focused window on Wayland
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.wtype ];

      systemd.user.services.handy = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        Unit = {
          Description = "Handy speech-to-text";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.handy} --start-hidden";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}

{
  # Speech-to-text: Handy (offline Parakeet/Whisper) plus an overlay that
  # animates a spectrum wave at the bottom of the screen while Handy records.
  #
  # Pick the model in Handy's own settings. On Wayland Handy can't grab global
  # shortcuts, so the compositor binds `handy --toggle-transcription` (see the
  # hyprland dotfiles). The hyprland module imports this one, so every Hyprland
  # machine gets both.
  flake.modules.homeManager.stt =
    { lib, pkgs, ... }:
    let
      sttVisualizer = pkgs.callPackage ./_stt-visualizer/package.nix { };
    in
    {
      home.packages = [
        pkgs.handy
        sttVisualizer
      ]
      # Types the transcription into the focused window on Wayland
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.wtype ];

      systemd.user.services = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        handy = {
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

        # Layer-shell overlay: fades in only while Handy holds a mic stream open
        # (detected via PipeWire), so it needs no changes to Handy. It once
        # exited cleanly without a crash, so restart on any exit.
        stt-visualizer = {
          Unit = {
            Description = "STT visualizer overlay (shown while Handy records)";
            PartOf = [ "graphical-session.target" ];
            After = [
              "graphical-session.target"
              "handy.service"
            ];
          };
          Service = {
            ExecStart = lib.getExe sttVisualizer;
            Restart = "always";
            RestartSec = 2;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };

  # `nix run .#stt-visualizer` / `nix build .#stt-visualizer`
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        stt-visualizer = pkgs.callPackage ./_stt-visualizer/package.nix { };
      };
    };
}

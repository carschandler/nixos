{
  # Small wrapper scripts in ~/.local/bin
  flake.modules.homeManager.scripts =
    { pkgs, lib, ... }:
    {
      home.sessionPath = [
        "$HOME/.local/bin"
      ];

      home.file =
        let
          localBin = {
            "hms" = ''nh home switch $HOME/nixos/ "$@"'';
            "hmn" = ''home-manager news --flake $HOME/nixos/ "$@"'';
            "nrs" = ''nh os switch $HOME/nixos/ "$@"'';
            "nfu" = ''nix flake update --commit-lock-file --flake $HOME/nixos/ "$@"'';
            "drs" = ''darwin-rebuild switch --flake $HOME/nixos/ "$@"'';
            "battery" = "cat /sys/class/power_supply/BAT0/capacity";
            "py" = ''nix develop ~/nixos/devshells/python/ "$@"'';
            "l" = ''lsd --group-dirs=first "$@"'';
            "ll" = ''lsd --group-dirs=first --color=always --icon=always -l "$@" | less -rF'';
            "lr" = ''lsd --group-dirs=first --color=always --icon=always -l --date=relative "$@" | less -rF'';
            "la" = ''lsd --group-dirs=first --color=always --icon=always -A "$@" | less -rF'';
            "lt" = ''lsd --group-dirs=first --tree --color=always --icon=always "$@" | less -rF'';
            "lla" = ''lsd --group-dirs=first --color=always --icon=always -la "$@" | less -rF'';
            "llt" = ''lsd --group-dirs=first --color=always --icon=always -l --tree "$@" | less -rF'';
            "ta" = "tmux attach -E";
            "ti" = ''
              tmux move-window -t 99

              tmux new-window -n backend -c ~/projects/t9-ai-backend
              tmux new-window -n t9lib -c ~/projects/t9lib
              tmux new-window -n core -c ~/projects/agent-core
              tmux new-window -n console -c ~/projects/console
              tmux new-window -n nix -c ~/nixos -t 9

              tmux kill-window -t 99
              tmux select-window -t 0
            '';
          };
        in
        lib.attrsets.concatMapAttrs (name: value: {
          ".local/bin/${name}" = {
            source = pkgs.writeShellScript name value;
          };
        }) localBin;
    };
}

{
  # Interactive shells, prompt, and shell integrations
  flake.modules.homeManager.shells =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
    in
    {
      programs = {
        bash = {
          enable = true;
          shellAliases = {
            ls = "lsd --group-dirs=first";
            rt = "cd $(git rev-parse --show-toplevel)";
          };
          bashrcExtra = ''
            shopt -s direxpand
            shopt -s cdable_vars

            # Prevent nix paths from being duplicated every time a new shell is
            # initiated
            NIX_PATHS="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:"
            NEWPATH=''${PATH/$NIX_PATHS}
            while [[ $NEWPATH =~ $NIX_PATHS ]]; do
              PATH=$NEWPATH
              NEWPATH=''${NEWPATH/$NIX_PATHS}
            done
          '';
          initExtra =
            let
              cfg = config.programs.zoxide;
              cfgOptions = lib.concatStringsSep " " cfg.options;
            in
            lib.mkOrder 2500 ''
              eval "$(${cfg.package}/bin/zoxide init bash ${cfgOptions})"
            '';

        };

        zsh = {
          enable = true;
        };

        fish = {
          enable = true;
        };

        nushell = {
          enable = true;
          extraConfig = ''
            $env.config.completions.algorithm = "fuzzy"
            $env.edit_mode = "vi"
            $env.config.keybindings = [
              {
                name: insert_last_token
                modifier: alt
                keycode: char_.
                mode: [ vi_normal vi_insert emacs ]
                event: [
                  { edit: InsertString, value: "!$" }
                  { send: Enter }
                ]
              },
              {
                name: fzf_insert_files
                modifier: control
                keycode: char_t
                mode: [emacs, vi_normal, vi_insert]
                event: {
                  send: executehostcommand
                  cmd: "commandline edit --insert (fzf --multi | lines | each { |it| $'($it)' } | str join ' ')"
                }
              },
              {
                name: carapace_fzf
                modifier: shift
                keycode: backtab # Shift+Tab
                mode: [emacs, vi_normal, vi_insert]
                event: {
                  send: executehostcommand
                  cmd: "do {
                    # 1. Get the current command line buffer
                    let cmd = (commandline)
                    let spans = ($cmd | split row ' ')

                    # 2. Get completions from carapace
                    let carapace_out = (carapace $spans.0 nushell ...$spans | from json)
                    if ($carapace_out | is-empty) { return }

                    # 3. Extract just the values and pipe to fzf
                    let selected = (
                        $carapace_out 
                        | get value 
                        | str join (char nl) 
                        | fzf --height 40% --layout=reverse
                    )

                    if ($selected | is-empty) { return }

                    # 4. Drop the partially typed word, append the fzf selection, and replace the buffer
                    let new_cmd = ($spans | drop 1 | append $selected | str join ' ')
                    commandline edit --replace $new_cmd
                  }"
                }
              }
            ]
          '';
        };

        carapace = {
          enable = true;
          enableNushellIntegration = true;
          package = pkgs.symlinkJoin {
            name = "carapace-wrapped";
            meta.mainProgram = "carapace";
            paths = [ pkgs.carapace ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/carapace \
                --set CARAPACE_MATCH 1
            '';
          };
        };

        readline = {
          enable = true;
          extraConfig = ''
            # Makes Tab cycle through completion options and show a single menu
            # instead of repeating available options over and over
            TAB: menu-complete
            set show-all-if-ambiguous on

            # Completes the common prefix first before cycling through options
            set menu-complete-display-prefix on

            # Ignore case in completion
            set completion-ignore-case on
            # Treat - and _ equally in completion
            set completion-map-case

            # Show LS_COLORS in completion options
            set colored-stats

            # Flash the cursor over the matching paren
            set blink-matching-paren on

            # Discard changes to history after hitting return
            set revert-all-at-newline on
          '';
        };

        starship = {
          enable = true;
        };

        zoxide = {
          enable = true;
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
          stdlib = ''
            layout_uv() {
                if [[ -d ".venv" ]]; then
                    VIRTUAL_ENV="$(pwd)/.venv"
                fi

                if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
                    log_status "No virtual environment exists. Executing \`uv venv\` to create one."
                    uv venv
                    VIRTUAL_ENV="$(pwd)/.venv"
                fi

                PATH_add "$VIRTUAL_ENV/bin"
                export UV_ACTIVE=1  # or VENV_ACTIVE=1
                export VIRTUAL_ENV
            }        
          '';
        };

        fzf = {
          enable = true;
          enableBashIntegration = true;
          defaultOptions = [
            "-m"
            "--bind ctrl-a:toggle-all"
          ];
          defaultCommand = "fd --type f";
        };
      };

      xdg.configFile."starship.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/dot-config/starship.toml";
    };
}

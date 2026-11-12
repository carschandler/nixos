{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  homedir = config.home.homeDirectory;
  dotfiles = "${homedir}/nixos/dotfiles";
in
{
  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    # Pin the nixpkgs version that this flake uses to the registry so that
    # `nix` commands use the same nixpkgs as our system does
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # You can import other home-manager modules here
  imports = [ ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "chan";
    homeDirectory = "/home/${config.home.username}";
    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  home.packages = with pkgs; [
    # cli programs
    _1password-cli
    cbonsai
    difftastic
    elvish
    fastfetch
    fd
    file
    gnumake
    htop
    jj-starship
    jq
    just
    libnotify
    lsd
    mc
    nh
    pandoc
    pdfgrep
    pixi
    ripgrep
    skim
    tmux
    toipe
    tree-sitter
    typos
    typst
    unzip
    wget
    xdg-utils
    xh
    xonsh
    xplr
    yq
    zellij
    zip
    zk

    # language tools
    pnpm

    # language servers
    basedpyright
    bash-language-server
    efm-langserver
    lua-language-server
    nil
    pyright
    typescript-language-server
    yaml-language-server

    # debuggers (prefer to install as a language dev dependency)
    vscode-js-debug

    # formatters/linters
    black
    isort
    nixfmt
    prettier
    stylua
  ];

  programs = {
    home-manager = {
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

    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
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

    gh = {
      enable = true;
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "carschandler";
          email = "92899389+carschandler@users.noreply.github.com";
        };
        alias = {
          lg = "log --all --oneline --graph --color=always --decorate";
          lgg = "log --oneline --graph --color=always --decorate";
        };
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      ignores = [
        "*.DS_Store"
      ];

      signing.format = null;
    };

    helix = {
      enable = true;
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "carschandler";
          email = "92899389+carschandler@users.noreply.github.com";
        };
        ui.default-command = "log";
        template-aliases = {
          "format_short_signature(signature)" = "signature.name()";
        };
        aliases = {
          la = [
            "log"
            "-r"
            "all()"
          ];
          lb = [
            "log"
            "-r"
            "(main..@)::"
          ];
          db = [
            "diff"
            "-r"
            "(main..@)::"
          ];
          newleaf = [
            "new"
            "heads(@::)"
          ];
        };
      };
    };

    neovim = {
      enable = true;

      # Ensure that neovim has access to gcc from nix, not whatever the system's
      # gcc is. This is so treesitter doesn't freak out.
      extraWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [ pkgs.gcc ]}"
      ];

      extraPackages = [
        pkgs.luajitPackages.tree-sitter-cli
      ];

      # Trying out this version now that we don't have gcc installed by default
      # so that we don't have to rebuild neovim every time. NOTE: works on some
      # systems but on others there is a different gcc that is further up in the
      # path and overrides.
      # extraPackages = [ pkgs.gcc ];

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withRuby = false;
      withPython3 = true;

      # Prevent home-manager from writing .config/nvim/init.lua, which
      # collides with the mkOutOfStoreSymlink of .config/nvim below.
      sideloadInitLua = true;
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

    pi-coding-agent = {
      enable = true;
    };

    opencode = {
      enable = true;
      # package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        permission = {
          edit = "ask";
          webfetch = "ask";
          bash = {
            "*" = "ask";
            "terraform *" = "deny";
            "terraform fmt *" = "allow";
            "terraform plan *" = "allow";
            "terraform validate" = "allow";
            "rg *" = "allow";
            "fd *" = "allow";
            "fd *-x*" = "ask";
            "fd *--exec*" = "ask";
            "fd *-X*" = "ask";
            "fd *--exec-batch*" = "ask";
            "find *" = "allow";
            "find *-exec*" = "ask";
            "find *--exec*" = "ask";
            "find *-execdir*" = "ask";
            "find *--execdir*" = "ask";
            "sed *" = "allow";
            "grep *" = "allow";
            "jq *" = "allow";
            "git diff *" = "allow";
            "git status *" = "allow";
            "git log *" = "allow";
            "git grep *" = "allow";
            "git show *" = "allow";
            "git branch" = "allow";
            "git branch --show-current" = "allow";
            "git branch -a" = "allow";
            "git branch --all" = "allow";
            "git merge-base *" = "allow";
            "git blame" = "allow";
            "git status" = "allow";
            "git blame *" = "allow";
            "git describe *" = "allow";
            "git rev-parse *" = "allow";
            "git reflog" = "allow";
            "git reflog show" = "allow";
            "git reflog show *" = "allow";
            "git reflog list" = "allow";
            "git reflog exists *" = "allow";
            "git remote" = "allow";
            "git remote -v" = "allow";
            "git remote get-url *" = "allow";
            "git remote show *" = "allow";
            "git ls-files *" = "allow";
            "git ls-tree *" = "allow";
            "git ls-remote *" = "allow";
            "git show-ref *" = "allow";
            "git for-each-ref *" = "allow";
            "git check-ignore *" = "allow";
            "git check-attr *" = "allow";
            "git shortlog *" = "allow";
            "git tag --list" = "allow";
            "git tag --list *" = "allow";
            "git tag -l" = "allow";
            "git tag -l *" = "allow";
            "git stash list" = "allow";
            "git stash show" = "allow";
            "git stash show *" = "allow";
            "git config --list" = "allow";
            "git config --get *" = "allow";
            "git config --get-all *" = "allow";
            "git config --get-regexp *" = "allow";
            "git count-objects *" = "allow";
            "git fsck *" = "allow";
            "git worktree list" = "allow";
            "gh pr view *" = "allow";
            "gh pr diff *" = "allow";
            "gh auth status" = "allow";
            "gh status" = "allow";
            "gh repo list *" = "allow";
            "gh repo view *" = "allow";
            "gh repo status *" = "allow";
            "gh pr list *" = "allow";
            "gh pr checks *" = "allow";
            "gh pr status" = "allow";
            "gh issue list *" = "allow";
            "gh issue view *" = "allow";
            "gh issue status" = "allow";
            "gh release list *" = "allow";
            "gh release view *" = "allow";
            "gh run list *" = "allow";
            "gh run view *" = "allow";
            "gh run watch *" = "allow";
            "gh workflow list" = "allow";
            "gh workflow view *" = "allow";
            "gh search *" = "allow";
            "gh gist list" = "allow";
            "gh gist view *" = "allow";
            "gh project list" = "allow";
            "gh project view *" = "allow";
            "gh project item-list *" = "allow";
            "gh ruleset list *" = "allow";
            "gh ruleset view *" = "allow";
            "gh extension list" = "allow";
            "gh alias list" = "allow";
            "jj log *" = "allow";
            "jj diff *" = "allow";
            "jj st *" = "allow";
            "jj status *" = "allow";
            "jj show *" = "allow";
            "jj status" = "allow";
            "jj st" = "allow";
            "jj diff" = "allow";
            "jj log" = "allow";
            "jj show" = "allow";
            "jj root" = "allow";
            "jj files" = "allow";
            "jj file list *" = "allow";
            "jj file show *" = "allow";
            "jj interdiff *" = "allow";
            "jj obslog *" = "allow";
            "jj evolog *" = "allow";
            "jj op log *" = "allow";
            "jj op show *" = "allow";
            "jj workspace list" = "allow";
            "jj bookmark list *" = "allow";
            "jj tag list *" = "allow";
            "jj config list" = "allow";
            "jj config get *" = "allow";
            "jj config path" = "allow";
            "jj git remote list *" = "allow";
            "git reflog write *" = "ask";
            "git reflog delete *" = "ask";
            "git reflog drop *" = "ask";
            "git reflog expire *" = "ask";
            "git fsck *--lost-found*" = "ask";
            "git diff *--output*" = "ask";
            "git diff -o*" = "ask";
            "git diff * -o*" = "ask";
            "git log *--output*" = "ask";
            "git log -o*" = "ask";
            "git log * -o*" = "ask";
            "git show *--output*" = "ask";
            "git show -o*" = "ask";
            "git show * -o*" = "ask";
            "git reflog *--output*" = "ask";
            "git reflog show -o*" = "ask";
            "git reflog show * -o*" = "ask";
            "jj op restore *" = "ask";
            "jj op abandon *" = "ask";
            "jj op revert *" = "ask";
            "jj op integrate *" = "ask";
            "jj bookmark advance *" = "ask";
            "jj bookmark create *" = "ask";
            "jj bookmark delete *" = "ask";
            "jj bookmark forget *" = "ask";
            "jj bookmark move *" = "ask";
            "jj bookmark rename *" = "ask";
            "jj bookmark set *" = "ask";
            "jj bookmark track *" = "ask";
            "jj bookmark untrack *" = "ask";
            "jj config edit *" = "ask";
            "jj config gc *" = "ask";
            "jj config set *" = "ask";
            "jj config unset *" = "ask";
            "jj git fetch *" = "ask";
            "jj git push *" = "ask";
            "jj git clone *" = "ask";
            "jj git import *" = "ask";
            "jj git export *" = "ask";
            "gh api *" = "ask";
            "aws sts get-caller-identity" = "allow";
            "aws configure list" = "allow";
            "aws cloudwatch describe-*" = "allow";
            "aws cloudwatch get-metric-data *" = "allow";
            "aws cloudwatch get-metric-statistics *" = "allow";
            "aws cloudwatch list-metrics *" = "allow";
            "aws cloudwatch get-dashboard *" = "allow";
            "aws cloudwatch list-dashboards *" = "allow";
            "aws cloudwatch get-metric-widget-image *" = "allow";
            "aws logs describe-*" = "allow";
            "aws logs get-log-events *" = "allow";
            "aws logs get-log-group-fields *" = "allow";
            "aws logs get-query-results *" = "allow";
            "aws logs filter-log-events *" = "allow";
            "aws logs tail *" = "allow";
            "aws dynamodb list-*" = "allow";
            "aws dynamodb describe-*" = "allow";
            "aws dynamodb get-item *" = "allow";
            "aws dynamodb batch-get-item *" = "allow";
            "aws dynamodb query *" = "allow";
            "aws dynamodb scan *" = "allow";
            "aws lambda list-*" = "allow";
            "aws lambda get-*" = "allow";
            "aws ecs list-*" = "allow";
            "aws ecs describe-*" = "allow";
            "aws s3 ls" = "allow";
            "aws s3 ls *" = "allow";
            "aws s3api list-*" = "allow";
            "aws s3api head-bucket *" = "allow";
            "aws s3api head-object *" = "allow";
            "aws s3api get-bucket-*" = "allow";
            "aws s3api get-object-acl *" = "allow";
            "aws s3api get-object-attributes *" = "allow";
            "aws s3api get-object-tagging *" = "allow";
            "aws ec2 describe-*" = "allow";
            "aws rds describe-*" = "allow";
            "aws eks list-*" = "allow";
            "aws eks describe-*" = "allow";
            "aws ecr list-*" = "allow";
            "aws ecr describe-*" = "allow";
            "aws ecr batch-get-image *" = "allow";
            "aws cloudtrail describe-*" = "allow";
            "aws cloudtrail get-*" = "allow";
            "aws cloudtrail lookup-events *" = "allow";
            "aws xray get-*" = "allow";
            "aws xray list-*" = "allow";
            "aws xray batch-get-*" = "allow";
            "aws iam get-*" = "allow";
            "aws iam list-*" = "allow";
            "aws logs start-query *" = "ask";
            "aws logs stop-query *" = "ask";
            "aws lambda invoke *" = "ask";
            "aws ecs execute-command *" = "ask";
            "aws ecs run-task *" = "ask";
            "aws ecs stop-task *" = "ask";
            "aws s3 cp *" = "ask";
            "aws s3 sync *" = "ask";
            "aws s3api get-object *" = "ask";
            "aws dynamodb put-item *" = "ask";
            "aws dynamodb update-item *" = "ask";
            "aws dynamodb delete-item *" = "ask";
            "aws dynamodb batch-write-item *" = "ask";
            "aws dynamodb create-table *" = "ask";
            "aws dynamodb delete-table *" = "ask";
            "aws dynamodb update-table *" = "ask";
            "aws dynamodb export-table-to-point-in-time *" = "ask";
            "aws dynamodb restore-table-to-point-in-time *" = "ask";
            "aws dynamodb execute-statement *" = "ask";
            "aws dynamodb batch-execute-statement *" = "ask";
            "aws ssm get-parameter *" = "ask";
            "aws ssm get-parameters *" = "ask";
            "aws ssm get-parameters-by-path *" = "ask";
            "aws ssm send-command *" = "ask";
            "aws ssm start-session *" = "ask";
            "aws secretsmanager get-secret-value *" = "ask";
            "aws ecr get-login-password *" = "ask";
            "aws eks get-token *" = "ask";
            "aws eks update-kubeconfig *" = "ask";
            "aws sts assume-role *" = "ask";
            "aws sts get-session-token *" = "ask";
            "aws sts get-federation-token *" = "ask";
            "aws configure set *" = "ask";
            "date *" = "allow";
            "ls *" = "allow";
            "echo *" = "allow";
            "cat *" = "allow";
            "head *" = "allow";
            "tail *" = "allow";
            "stat *" = "allow";
            "sort *" = "allow";
            "file *" = "allow";
            "realpath *" = "allow";
            "readlink *" = "allow";
            "du *" = "allow";
            "wc *" = "allow";
            "diff *" = "allow";
            "mkdir *" = "allow";
            "pwd" = "allow";
            "npm test *" = "allow";
            "npm run test *" = "allow";
            "npx eslint *" = "allow";
            "npm run lint *" = "allow";
            "npm run build *" = "allow";
            "npm run build" = "allow";
            "npm run verify" = "allow";
            "npm run verify *" = "allow";
            "npm run check *" = "allow";
            "npm run format-check *" = "allow";
            "npm run typecheck *" = "allow";
            "just check *" = "allow";
            "just test *" = "allow";
            "just test-deterministic *" = "allow";
            "just lint *" = "allow";
            "just format *" = "allow";
            "just typecheck" = "allow";
            "pnpm check *" = "allow";
            "pnpm test *" = "allow";
            "pnpm lint *" = "allow";
            "pnpm format *" = "allow";
            "pnpm format-check *" = "allow";
            "pnpm typecheck *" = "allow";
            "pnpm run check *" = "allow";
            "pnpm run test *" = "allow";
            "pnpm run lint *" = "allow";
            "pnpm run format *" = "allow";
            "pnpm run format-check *" = "allow";
            "pnpm run typecheck *" = "allow";
            "pnpm run build" = "allow";
            "pnpm run verify" = "allow";
            "pnpm run verify *" = "allow";
            "pnpm --prefix * run *" = "allow";
            "npm --prefix * run *" = "allow";
            "uv run test" = "allow";
            "uv run pytest *" = "allow";
            "uv run ruff format *" = "allow";
            "uv run ruff check *" = "allow";
            "lk --version" = "allow";
            "lk --help" = "allow";
            "lk docs *" = "allow";
          };
        };
        agent = {
          chat = {
            mode = "primary";
            description = "For chats not directly related to current files";
            prompt = ''
              You are a chat-based assistant. You should not use the context of
              the current system's files unless explicitly asked to.
            '';
            tools = {
              edit = false;
            };
            permission = {
              "sed *--in-place*" = "deny";
              "sed *-i*" = "deny";
            };
            color = "#b8bb26";
          };
          auto = {
            mode = "primary";
            tools = {
              edit = true;
            };
            color = "#fe8019";
          };
          plan = {
            mode = "primary";
            tools = {
              edit = false;
            };
            color = "#8ec07c";
            permission = {
              "sed *--in-place*" = "deny";
              "sed *-i*" = "deny";
            };
          };
        };
        provider = {
          openai = {
            models =
              lib.genAttrs
                [
                  "gpt-5"
                  "gpt-5-mini"
                  "gpt-5-nano"
                  "gpt-5-codex"
                  "gpt-5.1"
                  "gpt-5.1-codex"
                  "gpt-5.1-codex-mini"
                  "gpt-5.1-codex-max"
                  "gpt-5.2"
                  "gpt-5.2-codex"
                  "gpt-5.2-pro"
                ]
                (_: {
                  options = {
                    store = false;
                  };
                });
          };
          amazon-bedrock = {
            options = {
              profile = "default";
              region = "us-east-1";
            };
          };
        };
      };
    };

    antigravity-cli.enable = true;

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

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      shellWrapperName = "y";
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "q";
            run = "quit --no-cwd-file";
            desc = "Exit the process without writing cwd-file";
          }
          {
            on = "Q";
            run = "quit";
            desc = "Exit the process without writing cwd-file";
          }
          {
            on = "T";
            run = "plugin toggle-pane min-preview";
            desc = "Show or hide the preview pane";
          }
        ];
      };
      plugins =
        let
          plugdir = ../../dotfiles/yazi/plugins;
        in
        {
          toggle-pane = plugdir + "/toggle-pane";
        };
    };

    zoxide = {
      enable = true;
    };

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

    uv.enable = true;
    bun.enable = true;
  };

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

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
    EDITOR = "nvim";
    HMDIR = "${homedir}/nixos/home";
    HMFILE = "${homedir}/nixos/home/shared/default.nix";
    DOTFILES = "${homedir}/nixos/dotfiles";
    DEVSHELLS = "${homedir}/nixos/devshells";
    NVIMCFG = "${dotfiles}/nvim/dot-config/nvim";
    PLUGDIR = "${dotfiles}/nvim/dot-config/nvim/lua/user/plugins";
    # Gruvbox color palette
    NNN_FCOLORS = "020b0c0a00060e0701d60d09";
  };

  xdg = {
    configFile = {
      "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wezterm/dot-config/wezterm";

      "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/dot-config/nvim";

      "tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/dot-config/tmux";

      "starship.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/dot-config/starship.toml";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

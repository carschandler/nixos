{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  homedir = "${config.home.homeDirectory}";
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
  };

  home.packages = with pkgs; [
    # cli programs
    _1password-cli
    cbonsai
    fastfetch
    fd
    file
    gnumake
    htop
    jq
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
    xplr
    zellij
    zip
    zk
    zsh

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
    nixfmt-rfc-style
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
      };
    };

    helix = {
      enable = true;
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

      # Trying out this version now that we don't have gcc installed by default
      # so that we don't have to rebuild neovim every time. NOTE: works on some
      # systems but on others there is a different gcc that is further up in the
      # path and overrides.
      # extraPackages = [ pkgs.gcc ];

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
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
            "fd *" = "allow";
            "fd *-x" = "ask";
            "fd *-exec" = "ask";
            "find *" = "allow";
            "find -exec" = "ask";
            "find --exec" = "ask";
            "find -execdir" = "ask";
            "find --execdir" = "ask";
            "grep *" = "allow";
            "jq *" = "allow";
            "git diff *" = "allow";
            "git status *" = "allow";
            "git log *" = "allow";
            "git show *" = "allow";
            "git branch" = "allow";
            "git branch --show-current" = "allow";
            "git merge-base *" = "allow";
            "git blame" = "allow";
            "gh pr view *" = "allow";
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
            "pwd" = "allow";
            "npm test *" = "allow";
            "npm run test" = "allow";
            "npx eslint *" = "allow";
            "npm run lint" = "allow";
            "npm run build" = "allow";
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
          };
          auto = {
            mode = "primary";
            tools = {
              edit = true;
            };
            color = "#fe8019";
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

    gemini-cli.enable = true;

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
        if ! [[ $PATH =~ ${homedir}/.local/bin ]]; then
          PATH="$PATH:${homedir}/.local/bin"
        fi

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
        "llt" = ''lsd --group-dirs=first --color=always --icon=always -l --tree "$@" | less -rF;'';
        "ta" = "tmux attach -E";
      };
    in
    lib.attrsets.concatMapAttrs (name: value: {
      ".local/bin/${name}" = {
        text = value;
        executable = true;
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

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
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Pin the nixpkgs version that this flake uses to the registry so that
    # `nix` commands use the same nixpkgs as our system does
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc = {
      automatic = true;
      frequency = "weekly";
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
    bat
    cbonsai
    fd
    file
    htop
    libnotify
    lsd
    gnumake
    mc
    neofetch
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
    uv
    wget
    xdg-utils
    xplr
    zellij
    zk
    zsh

    # language servers
    efm-langserver
    lua-language-server
    nil
    basedpyright
    pyright
    bash-language-server
    yaml-language-server

    # formatters/linters
    black
    isort
    nixfmt-rfc-style
    stylua
  ];

  programs = {
    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
      userName = "carschandler";
      userEmail = "92899389+carschandler@users.noreply.github.com";
      aliases = {
        lg = "log --all --oneline --graph --color=always --decorate";
        lgg = "log --oneline --graph --color=always --decorate";
      };
      extraConfig = {
        pull.rebase = true;
      };
      ignores = [
        "*.DS_Store"
      ];
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
            mode: [ vi_normal vi_insert ]
            event: [
              { edit: InsertString, value: " !$" }
              { send: Enter }
            ]
          }
        ]
      '';
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

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      shellWrapperName = "y";
      keymap = {
        manager.prepend_keymap = [
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
            run = "plugin --sync hide-preview";
            desc = "Hide or show preview";
          }
        ];
      };
      plugins =
        let
          plugdir = ../../dotfiles/yazi/plugins;
        in
        {
          hide-preview = plugdir + "/hide-preview";
        };
    };

    zoxide = {
      enable = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        ls = "lsd --group-dirs=first";
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
    };
  };

  home.file =
    let
      localBin = {
        "hms" = "nh home switch $HOME/nixos";
        "hmn" = "home-manager news --flake $HOME/nixos";
        "nrs" = "nh os switch $HOME/nixos";
        "nfu" = "nix flake update --commit-lock-file --flake $HOME/nixos";
        "drs" = "darwin-rebuild switch --flake $HOME/nixos";
        "battery" = "cat /sys/class/power_supply/BAT0/capacity";
        "py" = "nix develop ~/nixos/devshells/python/";
        "l" = "lsd --group-dirs=first";
        "ll" = ''lsd --group-dirs=first --color=always --icon=always -l "$@" | less -rF'';
        "lr" = ''lsd --group-dirs=first --color=always --icon=always -l --date=relative "$@" | less -rF'';
        "la" = ''lsd --group-dirs=first --color=always --icon=always -A "$@" | less -rF'';
        "lt" = ''lsd --group-dirs=first --tree --color=always --icon=always "$@" | less -rF'';
        "lla" = ''lsd --group-dirs=first --color=always --icon=always -lA "$@" | less -rF'';
        "llt" = ''lsd --group-dirs=first --color=always --icon=always -l --tree "$@" | less -rF;'';
      };
    in
    lib.attrsets.concatMapAttrs (name: value: {
      ".local/bin/${name}" = {
        text = value;
        executable = true;
      };
    }) localBin;

  home.sessionVariables = {
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

      "starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/dot-config/starship.toml";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

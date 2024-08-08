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
  xdgUserDir = "${homedir}/xdg";
in
{
  nix = {
    enable = true;
    package = pkgs.nixVersions.nix_2_18;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Pin the nixpkgs version that this flake uses to the registry so that
    # `nix` commands use the same nixpkgs as our system does... do this
    # for each configuration in here
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
    homeDirectory = "/home/chan";
  };

  home.packages = with pkgs; [
    # cli programs
    bat
    fd
    file
    htop
    libnotify
    lsd
    neofetch
    pandoc
    pdfgrep
    ripgrep
    skim
    tmux
    toipe
    typos
    unzip
    wget
    xdg-utils
    xplr
    zellij
    zk
    zsh

    # gui apps
    emacs29-pgtk
    feh
    meld

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

    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
        cfg = {
          speechSynthesisSupport = true;
        };
      };

      # profiles.chan = {
      #   isDefault = true;
      #   userChrome = ''
      #     @-moz-document url("chrome://browser/content/browser.xul") {
      #       #TabsToolbar {
      #         visibility: collapse !important;
      #         margin-bottom: 21px !important;
      #       }
      #     
      #       #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
      #         visibility: collapse !important;
      #       }
      #     }
      #   '';
      # };
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
    };

    zoxide = {
      enable = true;
    };

    bash = {
      enable = true;
      shellAliases = {
        hms = "home-manager switch --flake $HOME/nixos";
        hmn = "home-manager news --flake $HOME/nixos";
        nrs = "sudo nixos-rebuild switch --flake $HOME/nixos";
        nfu = "nix flake update --commit-lock-file $HOME/nixos";
        # FIXME: override lesspipe somehow?
        battery = "cat /sys/class/power_supply/BAT0/capacity";
        py = "nix develop ~/nixos/devshells/python/";
      };
      bashrcExtra = ''
        if ! [[ $PATH =~ ${homedir}/.local/bin ]]; then
          PATH="$PATH:${homedir}/.local/bin"
        fi

        shopt -s direxpand
        shopt -s cdable_vars

        alias ls="lsd --group-dirs=first"

        function ll() {
          lsd --group-dirs=first --color=always --icon=always -l "$@" | less -rF
        }

        function lr() {
           lsd --group-dirs=first --color=always --icon=always -l --date=relative "$@" | less -rF
        }

        function la() {
          lsd --group-dirs=first --color=always --icon=always -A "$@" | less -rF
        }

        function lt() {
          lsd --group-dirs=first --tree --color=always --icon=always "$@" | less -rF
        }

        function lla() {
          lsd --group-dirs=first --color=always --icon=always -lA "$@" | less -rF
        }

        function llt() {
          lsd --group-dirs=first --color=always --icon=always -l --tree "$@" | less -rF;
        }

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

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${xdgUserDir}/Desktop";
      documents = "${xdgUserDir}/Documents";
      download = "${xdgUserDir}/Downloads";
      music = "${xdgUserDir}/Music";
      pictures = "${xdgUserDir}/Pictures";
      publicShare = "${xdgUserDir}/Public";
      templates = "${xdgUserDir}/Templates";
      videos = "${xdgUserDir}/Videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [
          "org.gnome.Evince.desktop"
          "org.pwmt.zathura.desktop"
          "firefox.desktop"
        ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "x-scheme-handler/https" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "x-scheme-handler/about" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "x-scheme-handler/unknown" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
      };
    };
  };

  gtk = {
    enable = true;
    font = {
      name = (import ../fonts/systemFonts).sans.name;
      size = 12;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

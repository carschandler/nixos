{ inputs, outputs, lib, config, pkgs, ... }: 
let
  homedir = "${config.home.homeDirectory}";
  dotfiles = "${homedir}/nixos/dotfiles";
  xdgUserDir = "${homedir}/xdg";
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      #   gruvbox-gtk-theme = prev.gruvbox-gtk-theme.overrideAttrs (oldAttrs: {
      #     installPhase = ''
      #       runHook preInstall
      #       mkdir -p $out/share/themes
      #       cp -a themes/* $out/share/themes
      #       mkdir -p $out/share/icons
      #       cp -a icons/* $out/share/icons
      #       runHook postInstall
      #     '';
      #   });
      #
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
      username = "chan";
      homeDirectory = "/home/chan";
  };

  home.packages = with pkgs; [

    # cli programs
    bat
    exa
    fd
    htop
    lsd
    neofetch
    pandoc
    ripgrep
    skim
    starship
    tmux
    toipe
    unzip
    wget
    xplr
    zellij
    zoxide
    zsh

    # system utilities
    glxinfo

    # language tools/compilers

    # For qt themes to work
    libsForQt5.qtstyleplugins
    
    # gui apps
    feh
    meld
    emacs29-gtk3

    # language servers
    nodePackages.pyright
    lua-language-server
    nixd
    efm-langserver

    # formatters/linters
    black
  ];

  fonts.fontconfig.enable = true;

  programs = {
    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    firefox = {
      enable = true;
      package = pkgs.firefox.override {
        cfg = {
          speechSynthesisSupport = true;
          enableTridactylNative = true;
        };
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
      userName = "Cars Chandler";
      userEmail = "carschandler7@gmail.com";
      aliases = {
        lg = "log --all --oneline --graph --color=always --decorate";
        lgg = "log --oneline --graph --color=always --decorate";
      };
    };

    neovim = {
      enable = true;
      # Ensure that neovim has access to gcc from nix, not whatever the system's
      # gcc is. This is so treesitter doesn't piss the bed. Thanks to
      # https://www.reddit.com/r/neovim/comments/15lvm44/comment/jvflvyq
      # for the help!
      package = pkgs.neovim-unwrapped.overrideAttrs (attrs: {
        disallowedReferences = [];
        nativeBuildInputs = attrs.nativeBuildInputs ++ [pkgs.makeWrapper];
        postFixup = ''
          wrapProgram $out/bin/nvim --prefix PATH : ${lib.makeBinPath [pkgs.gcc]}
        '';
      });
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
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
      '';
    };

    bash = {
      enable = true;
      shellAliases = {
        hms = "home-manager switch --flake $HOME/nixos";
        nrs = "sudo nixos-rebuild switch --flake $HOME/nixos";
        #FIXME: override lesspipe somehow?
        ls = "lsd --group-dirs=first";
        ll = "lsd --group-dirs=first --color=always --icon=always -l | less -rF";
        lr = "lsd --group-dirs=first --color=always --icon=always -l --date=relative | less -rF";
        la = "lsd --group-dirs=first --color=always --icon=always -A | less -rF";
        lt = "lsd --group-dirs=first --tree --color=always --icon=always | less -rF";
        lla = "lsd --group-dirs=first --color=always --icon=always -lA | less -rF";
        llt = "lsd --group-dirs=first --color=always --icon=always -l --tree | less -rF";
        battery = "cat /sys/class/power_supply/BAT0/capacity";
      };
      bashrcExtra = ''
        eval "$(zoxide init bash)"
        PATH="$PATH:${homedir}/.local/bin"
        shopt -s direxpand
        shopt -s cdable_vars
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
      "wezterm".source = config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/wezterm/dot-config/wezterm";
    
      "nvim".source = config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/nvim/dot-config/nvim";

      "tmux".source = config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/tmux/dot-config/tmux";
    };

    userDirs = {
      enable = true;
      desktop = "${xdgUserDir}/Desktop";
      documents = "${xdgUserDir}/Documents";
      download = "${xdgUserDir}/Downloads";
      music = "${xdgUserDir}/Music";
      pictures = "${xdgUserDir}/Pictures";
      publicShare = "${xdgUserDir}/Public";
      templates = "${xdgUserDir}/Templates";
      videos = "${xdgUserDir}/Videos";
    };
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.cantarell-fonts;
      name = "Cantarell";
      size = 12;
    };
    # theme = {
    #   name = "Gruvbox-Dark-BL";
    #   package = pkgs.gruvbox-gtk-theme;
    # };
    # iconTheme = {
    #   name = "Gruvbox-Dark";
    #   package = pkgs.gruvbox-gtk-theme;
    # };
    # cursorTheme = {
    #   name = "Gruvbox-Dark";
    #   package = pkgs.gruvbox-gtk-theme;
    # };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.gnome.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}

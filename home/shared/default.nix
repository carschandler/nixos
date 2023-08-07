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
    # terminal emulators
    alacritty
    foot
    kitty
    wezterm

    # cli programs
    bat
    exa
    fd
    htop
    lsd
    neofetch
    ripgrep
    skim
    starship
    tmux
    toipe
    unzip
    wget
    xplr
    zoxide
    zsh

    # language tools/compilers
    libgccjit # needed for nvim-treesitter
    
    # gui apps
    spotify
    #libreoffice-fresh
    meld

    # language servers
    nodePackages.pyright
    lua-language-server
    nixd
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
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      defaultOptions = [
        "-m"
        "--bind ctrl-a:toggle-all"
      ];
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
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    readline = {
      enable = true;
      extraConfig = ''
        set completion-ignore-case on
      '';
    };

    bash = {
      enable = true;
      shellAliases = {
        hms = "home-manager switch --flake $HOME/nixos";
        nrs = "sudo nixos-rebuild switch --flake $HOME/nixos";
        #FIXME: override lesspipe somehow?
        ls = "exa --icons --color=always";
        ll = "exa --icons --color=always --git -lg";
        battery = "cat /sys/class/power_supply/BAT0/capacity";
      };
      bashrcExtra = ''
        eval "$(zoxide init bash)"
        PATH="$PATH:${homedir}/.local/bin"
        function nf() {
          result="$(fzf -m $@)"
          if [[ $? == 0 ]]; then
            nvim $result
          fi
        }
      '';
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    HMDIR = "${homedir}/nixos/home";
    HMFILE = "${homedir}/nixos/home/shared/default.nix";
    DOTFILES = "${homedir}/nixos/dotfiles";
    NVIMCFG = "${dotfiles}/nvim/dot-config/nvim";
    PLUGDIR = "${dotfiles}/nvim/dot-config/nvim/lua/user/plugins";
  };

  xdg = {
    configFile = {
      "wezterm".source = config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/wezterm/dot-config/wezterm";
    
      "nvim".source = config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/nvim/dot-config/nvim";
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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}

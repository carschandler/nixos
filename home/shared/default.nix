{ inputs, outputs, lib, config, pkgs, ... }: 
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";

  # symlinkAllToHome = dotfilesDir: (
  #   let 
  #     subdirs = map 
  #       (subdir: dotfilesDir + "/${subdir}")
  #       (lib.mapAttrsToList (name: value: name) (builtins.readDir dotfilesDir));
  #     # subdirs = "test";
  #       #(lib.mapAttrsToList (name: value: name) (builtins.readDir dotfilesDir));
  #       #
  #     recursivelyLink = (dir: set:
  #       builtins.mapAttrs (name: type:
  #         if !isNull (builtins.match ".*\.link-target.*" name) then
  #           #builtins.trace "test"
  #           {
  #             "${builtins.replaceStrings ["dot-" ".link-target"] ["." ""] dir}".source = lib.file.mkOutOfStoreSymlink (dotfilesDir + "/${dir}");
  #           }
  #         else if type == "directory" then
  #           #builtins.trace "test3"
  #           mkMerge [set (recursivelyLink (dir + "/${name}") set)]
  #         else
  #           {}
  #       ) (builtins.readDir dir)
  #     );
  #   in
  #     mkMerge (map (recursivelyLink dir {}) subdirs)
  # );
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

      # Input has a funky license
      input-fonts.acceptLicense = true;
    };
  };

  home = {
      username = "chan";
      homeDirectory = "/home/chan";
  };

  # Add stuff for your user as you see fit
  home.packages = let
    pypkgs = ps: with ps; [
      jupyter
      ipython
      numpy
      pandas
      matplotlib
      sympy
      scipy

    ];
  in
  with pkgs; [
    alacritty
    foot
    kitty
    micromamba
    neofetch
    ripgrep
    tmux
    wezterm
    wget
    xplr
    libreoffice-fresh
    nodePackages.pyright
    htop
    toipe
    fzf
    starship
    bat
    exa
    lsd
    fd
    skim
    spotify
    meld

    # (python311.withPackages pypkgs)

    # Fonts
    (nerdfonts.override { fonts = [
      "SourceCodePro"
      "Hack"
      "Iosevka"
      "Hasklig"
    ]; })

    cantarell-fonts
    #input-fonts

    # Replaced by NerdFonts
    #source-code-pro
    #hack-font
    #iosevka
    #hasklig
  ];

  fonts.fontconfig.enable = true;

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        hms = "home-manager switch --flake $HOME/nixos";
        nrs = "sudo nixos-rebuild switch --flake $HOME/nixos";
        #FIXME: override lesspipe somehow?
        ls = "COLUMNS=$COLUMNS exa --icons --color=always -G | less -rF";
        ll = "COLUMNS=$COLUMNS exa --icons --color=always --git -lg | less -rF";
      };
    };

    firefox = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "Cars Chandler";
      userEmail = "carschandler7@gmail.com";
    };

    home-manager = {
      enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile = {
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/wezterm/dot-config/wezterm";
  
    "nvim".source = config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/nvim/dot-config/nvim";
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.cantarell-fonts;
      name = "Cantarell";
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

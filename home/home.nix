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
      #
      # (final: prev: {
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
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);

      input-fonts.acceptLicense = true;
    };
  };

  # symLinkAllToHome {
  #   ".config/nvim" = dotfiles + "nvim/dot-config/nvim";
  # };

  home = {
      username = "chan";
      homeDirectory = "/home/chan";
  };

  #home.file = symlinkAllToHome dotfiles;

  # Add stuff for your user as you see fit
  home.packages = with pkgs; [
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
    htop
    toipe
    fzf
    starship
    bat



    # Fonts
    (nerdfonts.override { fonts = [
      "SourceCodePro"
      "Hack"
      "Iosevka"
      "Hasklig"
    ]; })
    cantarell-fonts
    input-fonts
    #source-code-pro
    #hack-font
    #iosevka
    #hasklig
  ];


  fonts.fontconfig.enable = true;

  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/wezterm/dot-config/wezterm";
  
  xdg.configFile."tofi".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/tofi/dot-config/tofi";

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/nvim/dot-config/nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
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

  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;
    recommendedEnvironment = true;
    extraConfig = "source=./hyprland-source.conf";
  };

  xdg.configFile."hypr/hyprland-source.conf".source = 
    config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/hyprland/dot-config/hypr/hyprland-source.conf";

  # Enable home-manager and git
  programs.git = {
    enable = true;
    userName = "carschandler";
    userEmail = "carschandler7@gmail.com";
  };

  programs.firefox = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      hms = "home-manager switch --flake $HOME/nixos";
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
}

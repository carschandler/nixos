{ inputs, outputs, lib, config, pkgs, ... }: 
let
  dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
    fzf
    starship
    bat
    exa
    lsd
    fd
    skim
    spotify
    meld

    (python311.withPackages pypkgs)
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Enable home-manager and git
  programs.git = {
    enable = true;
    userName = "Cars Chandler";
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

  xdg.configFile."wezterm".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/wezterm/dot-config/wezterm";
  
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink
    "${dotfiles}/nvim/dot-config/nvim";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
}

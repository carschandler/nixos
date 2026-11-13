{
  # General-purpose CLI tools and their configs
  flake.modules.homeManager.cli-tools =
    { config, pkgs, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
    in
    {
      home.packages = with pkgs; [
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
      ];

      programs = {
        bat = {
          enable = true;
          config = {
            theme = "gruvbox-dark";
          };
        };

        gh = {
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
      };

      xdg.configFile = {
        "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wezterm/dot-config/wezterm";
        "tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/dot-config/tmux";
      };
    };
}

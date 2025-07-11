{
  pkgs,
  config,
  ...
}:
let
  xdgUserDir = "${config.home.homeDirectory}/xdg";
in
{
  xdg = {
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

    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = {
        common = {
          default = [ "gtk" ];
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
        sway = {
          default = [
            "wlr"
            "gtk"
          ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    # terminal emulators
    # alacritty below
    foot
    # kitty below
    # TODO: install terminfo automatically https://wezterm.org/faq.html#how-do-i-enable-undercurl-curly-underlines
    wezterm

    # gui apps
    _1password-gui
    ungoogled-chromium
    discord
    emacs-pgtk
    evince
    feh
    gimp
    libreoffice-fresh
    meld
    nautilus
    obsidian
    spotify
    thunderbird
    vlc
    vscode-fhs
    xfce.thunar
    zathura
    zotero

    # hardware utils
    glxinfo
    playerctl
    usbutils
    usb-reset
    wl-clipboard
  ];

  services.cliphist.enable = true;

  # programs.thunderbird = {
  #   enable = true;
  #   profiles.chan = {
  #     isDefault = true;
  #   };
  # };

  programs = {
    kitty =
      let
        monospaceFont = (import ../fonts/systemFonts).monospace.name;
      in
      {
        enable = true;
        themeFile = "gruvbox-dark";
        settings = {
          font_family = "${monospaceFont}";
          bold_font = "${monospaceFont} Bold";
          italic_font = "${monospaceFont} Italic";
          bold_italic_font = "${monospaceFont} Bold Italic";
          font_size = 12;
          background_opacity = "0.9";
        };
      };

    alacritty = {
      enable = true;
      theme = "gruvbox_dark";
      settings = {
        window = {
          padding = {
            x = 5;
            y = 5;
          };
          dynamic_padding = true;
          opacity = 0.9;
        };
        colors = {
          draw_bold_text_with_bright_colors = true;
        };
      };
    };

    ghostty = {
      enable = true;
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
  };

  gtk = {
    enable = true;
    font = {
      name = (import ../fonts/systemFonts).sans.name;
      size = 12;
    };
    # theme = {
    #   name = "Adwaita";
    #   # package = pkgs.adw-gtk3;
    # };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    # iconTheme = {
    #   name = "Adwaita";
    #   package = pkgs.adwaita-icon-theme;
    # };
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # home.sessionVariables.GTK_THEME = "Adwaita:dark";

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  # For Electron apps
  home.sessionVariables = {
    DEFAULT_BROWSER = "firefox";
    BROWSER = "firefox";
  };

  home.stateVersion = "22.11";
}

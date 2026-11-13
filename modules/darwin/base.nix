# nix-darwin setup shared by every Mac
{ config, inputs, ... }:
let
  inherit (config.flake.modules) darwin homeManager;
  user = config.meta.users.main.username;
in
{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        darwin.main-user
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      # NOTE: homebrew.enable needs to be false on the first activation so
      # nix-homebrew can install brew first.
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        inherit user;
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.${user}.shell = pkgs.bashInteractive;

      homebrew = {
        enable = true;
        brews = [
          "colima"
          "docker"
          "docker-compose"
          "livekit-cli"
          "node"
        ];
        casks = [
          "1password"
          "arc"
          "bettertouchtool"
          "blackhole-2ch"
          "discord"
          "ghostty"
          "gimp"
          "inkscape"
          "obsidian"
          "raycast"
          "spotify"
          "thunderbird"
          "visual-studio-code"
          "vlc"
          "warp"
          "wezterm"
          "zed"
          "zen"
          "zotero"
        ];
        masApps = { };

        global = {
          autoUpdate = false;
        };
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
      };

      system.defaults = {
        dock = {
          autohide = true;
        };
        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
        };
        trackpad = {
          Clicking = true;
          Dragging = true;
          TrackpadRightClick = true;
        };
        screencapture = {
          location = "~/Pictures/screenshots";
        };
        NSGlobalDomain = {
          # "com.apple.messages.text.EmojiReplacement" = 1; TODO
          # "com.apple.driver.AppleBluetoothMultitouch.trackpad.TrackpadThreeFingerVertSwipeGesture" = 1; TODO
          "com.apple.keyboard.fnState" = true;
          "com.apple.mouse.tapBehavior" = 1;
          "com.apple.sound.beep.feedback" = 1;
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;
          ApplePressAndHoldEnabled = false;
          NSAutomaticCapitalizationEnabled = false;
          # Double space for period
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
        };
      };

      system.activationScripts = {
        createScreenshotsDir = {
          enable = true;
          text = ''
            sudo -u ${user} mkdir -p "$HOME/Pictures/screenshots"
          '';
        };
      };
    };

  flake.modules.homeManager.mac = {
    imports = [ homeManager.fonts ];

    programs.docker-cli = {
      enable = true;
      settings = {
        cliPluginsExtraDirs = [
          "/opt/homebrew/lib/docker/cli-plugins"
        ];
        currentContext = "colima";
      };
    };

    home.sessionPath = [
      "$HOME/Library/Flutter/bin"
    ];
  };
}

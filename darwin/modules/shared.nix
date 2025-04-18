{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.shared;
in
{
  options.shared = {
    enable = lib.mkEnableOption "Shared Mac configuration";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.hostPlatform = "aarch64-darwin";

    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "chan";
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    users.users.chan.shell = pkgs.bashInteractive;

    homebrew = {
      enable = true;
      brews = [ ];
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
        "tailscale"
        "thunderbird"
        "visual-studio-code"
        "vlc"
        "warp"
        "wezterm"
        "zed"
        "zen-browser"
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
  };

}

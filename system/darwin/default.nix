{
  pkgs,
  lib,
  ...
}@inputs:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;

  networking.hostName = "mbp";

  security.pam.enableSudoTouchIdAuth = true;

  users.users.chan.shell = pkgs.bashInteractive;

  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      "1password"
      "bettertouchtool"
      "discord"
      "obsidian"
      "raycast"
      "spotify"
      "thunderbird"
      "visual-studio-code"
      "visual-studio-code@insiders"
      "warp"
      "wezterm"
      "zed"
      "zen-browser"
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
      # AppleShowAllFiles = true;
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
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  system.stateVersion = 5;
}

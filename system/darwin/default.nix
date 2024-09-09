{
  pkgs,
  lib,
  ...
}@inputs:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  services.nix-daemon.enable = true;

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
      "visual-studio-code"
      "wezterm"
      "zed"
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
    NSGlobalDomain = {
      # "com.apple.messages.text.EmojiReplacement" = 1; TODO
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
}

{
  flake.modules.nixos.audio = {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false; # Required by NixOS to use PipeWire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };
}

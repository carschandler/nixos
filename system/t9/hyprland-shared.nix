{
  ...
}:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # programs.regreet = {
  #   enable = true;
  #   font.name = "sans";
  #   settings = {
  #     default_session = {
  #       command = "cage -s -mlast -- regreet";
  #       user = "greeter";
  #     };
  #   };
  # };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  security.pam.services.hyprlock = { };
}

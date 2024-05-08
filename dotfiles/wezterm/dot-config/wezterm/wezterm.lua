local wezterm = require "wezterm"
local config = {}
if wezterm.config_builder then
   config = wezterm.config_builder()
end

config = {
  font = wezterm.font{
    -- TODO font
    family = 'SauceCodePro NF',
    -- family = 'CommitMono Nerd Font',
    -- family = 'Input Mono',
    -- family = 'HackNerdFont',
    -- family = 'HasklugNerdFont',
    -- family = 'IosevkaNerdFont',
    weight = 'Medium',
  },
  freetype_load_flags = 'NO_HINTING',
  color_scheme = "GruvboxDark",
  enable_tab_bar = false,
  window_padding = {
     top = 2,
     bottom = 2,
  },
  window_background_opacity = 0.90,
}

if wezterm.hostname() == "desktop" then
  -- config.front_end = "OpenGL"
  config.enable_wayland = false
elseif wezterm.hostname() == "laptop" then
  config.enable_wayland = false
  -- config.front_end = "Software"
end

return config

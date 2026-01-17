local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config = {
	font = wezterm.font({
		family = "CommitMono Nerd Font",
		-- family = "SauceCodePro NF",
		-- family = 'Input Mono',
		-- family = 'HackNerdFont',
		-- family = 'HasklugNerdFont',
		-- family = 'IosevkaNerdFont',
		weight = "Medium",
	}),
	freetype_load_flags = "NO_HINTING",
	color_scheme = "GruvboxDark",
	enable_tab_bar = false,
	window_padding = {
		top = 2,
		bottom = 2,
	},
	window_background_opacity = 0.85,
	macos_window_background_blur = 50,
	xcursor_theme = "Adwaita",
	xcursor_size = 24,
	-- For claude code
	keys = {
		{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
	},
}

if wezterm.hostname() == "desktop" then
	-- config.front_end = "Software"
	config.enable_wayland = true
elseif wezterm.hostname() == "desktop-t9" then
	-- config.front_end = "WebGpu"
	-- config.enable_wayland = false
	config.font_size = 11
elseif wezterm.hostname() == "laptop" then
	config.enable_wayland = false
	-- config.front_end = "Software"
elseif wezterm.hostname() == "mbp" then
	config.default_prog = { "/Users/chan/.nix-profile/bin/bash", "-l" }
end

return config

-- Hyprland Lua config (migrated from hyprland-source.conf).
-- Since Hyprland 0.55, hyprlang is deprecated in favor of lua.
-- See https://wiki.hypr.land/Configuring/Start/
--
-- This file is symlinked into ~/.config/hypr/hyprland.lua via
-- mkOutOfStoreSymlink so Hyprland hot-reloads it on save.

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- laptop
hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })

-- desktop
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC VG27AQ1A N8LMQS051510",
	mode = "2560x1440@144",
	position = "0x0",
	scale = 1,
})
hl.monitor({
	output = "desc:Dell Inc. Dell S2417DG ##ASMzgbd21FTd",
	mode = "2560x1440@144",
	position = "2560x-530",
	scale = 1,
	transform = 3,
})

-- desktop-t9
-- Upper
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC XG27UCG T1LMQS062570",
	mode = "3840x2160@120",
	position = "0x0",
	scale = 1.5,
	transform = 2,
})
-- Lower
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC XG27UCG T2LMQS006671",
	mode = "3840x2160@120",
	position = "0x1440",
	scale = 1.5,
})

-- default
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Slight chance this is related to gdm? Also see
-- https://github.com/hyprwm/Hyprland/issues/6309
hl.monitor({ output = "Unknown-1", disabled = true })

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("NIXOS_OZONE_WL", "1")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

-- NVIDIA-specific
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("GDK_SCALE", "1.5")

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd(
		"hyprctl setcursor macOS 28 & swaync & bash /home/chan/nixos/dotfiles/hyprland/dot-config/hypr/launch_hyprpaper.sh"
	)
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

---------------------
---- MY PROGRAMS ----
---------------------

local mainMod = "SUPER" -- WIN key
local launchMod = "Alt_R"

local launcherProgram = "rofi"
local appLauncher = launcherProgram .. " -show drun -theme dmenu -show-icons"
local cmdLauncher = launcherProgram .. " -show run -theme dmenu"
local windowSwitcher = launcherProgram .. " -show window -theme dmenu"

local term = "wezterm"
local webbrowser = "firefox"
local files = "nautilus"
local volume = "pavucontrol"
local bluetooth = "overskride"
local music = "spotify"
local documents = "evince"
local ide = "code"
local notes = "obsidian"
local chat = "discord"
local passwords = "1password"

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/

local activeColor = "rgba(bbbbbbcc)"
local inactiveColor = "rgba(595959cc)"

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,

		col = {
			-- dim white
			active_border = activeColor,
			-- col.active_border = { colors = { "rgba(bbbbbbcc)", "rgba(999999cc)" }, angle = 90 },
			-- gruvbox: { colors = { "rgba(83a598ee)", "rgba(8ec07cee)" }, angle = 45 },
			inactive_border = inactiveColor,
		},

		layout = "dwindle",
	},

	cursor = {
		-- Fixes the selector cursor being captured in hyprshot but not sure what
		-- other consequences it has
		no_hardware_cursors = 0,
	},

	xwayland = {
		force_zero_scaling = true,
	},

	decoration = {
		rounding = 10,
		rounding_power = 4.0,

		blur = {
			enabled = true,
			size = 15,
			passes = 3,
			new_optimizations = true,
		},

		shadow = {
			enabled = true,
			range = 30,
			render_power = 3,
			color = "rgba(1a1a1aee)",
			color_inactive = "rgba(1a1a1abb)",
		},

		-- dim_inactive = true,
		-- dim_strength = 0.05,
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
		preserve_split = true, -- you probably want this
	},

	master = {
		-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
		new_status = "slave",
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		focus_on_activate = true,
	},

	binds = {
		-- Super+Tab (sort of) replaces the need for workspace_back_and_forth
		allow_workspace_cycles = true,
	},

	group = {
		col = {
			border_active = activeColor,
			border_inactive = inactiveColor,
		},
		groupbar = {
			col = {
				active = activeColor,
				inactive = inactiveColor,
			},
		},
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:backspace",
		kb_rules = "",

		follow_mouse = 2,
		float_switch_override_focus = 0,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		numlock_by_default = true,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.2,
		},
	},
})

----------------------
---- ANIMATIONS ------
----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("easeInCubic", { type = "bezier", points = { { 0.32, 0 }, { 0.67, 0 } } })
hl.curve("easeOutCubic", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })
hl.curve("easeInOutSine", { type = "bezier", points = { { 0.37, 0 }, { 0.63, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "easeOutCirc" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 6, bezier = "easeOutCirc" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "easeOutCirc" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "easeOutCirc" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 2, bezier = "easeOutCirc" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

----------------
---- GESTURES --
----------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

----------------
---- DEVICES ---
----------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
	name = "logitech-g403-1",
	sensitivity = -0.35,
})

hl.device({
	name = "logitech-mx-vertical-1",
	-- sensitivity = -0.2,
	-- accel_profile = "flat",
	sensitivity = -0.8,
	accel_profile = "adaptive",
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- hl.window_rule({ match = { class = "org.erikreider.swayosd" }, ... })

-- hl.window_rule({
--   match = { class = "Slack", initial_title = ".*Huddle.*" },
--   persistent_size = true,
-- })
-- hl.window_rule({
--   match = { class = "Slack", initial_title = ".*Huddle.*" },
--   float = true,
-- })

hl.window_rule({
	match = { class = "thunderbird", initial_title = "negative:(Mozilla Thunderbird)" },
	persistent_size = true,
})
hl.window_rule({
	match = { class = "thunderbird", initial_title = "negative:(Mozilla Thunderbird)" },
	float = true,
})

hl.window_rule({ match = { class = "evince" }, tile = true })
-- hl.window_rule({ match = { class = "evince" }, suppress_event = "maximize" })

-- Layer rules
hl.layer_rule({ match = { namespace = "launcher" }, blur = true })
hl.layer_rule({ match = { namespace = "rofi" }, no_anim = true })

-- Notifications
hl.layer_rule({
	name = "ignorezeronotis",
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0,
})

-- Notification center
hl.layer_rule({
	name = "ignorezeronc",
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- hyprwhspr-rs just listens for keypresses but does not actually consume them,
-- so this just makes them do nothing instead of triggering inside underlying
-- applications
hl.bind("SHIFT + ALT + SPACE", hl.dsp.no_op())
hl.bind("SUPER + ALT + SPACE", hl.dsp.no_op())

-- App launch binds (launchMod)
hl.bind(launchMod .. " + W", hl.dsp.exec_cmd(webbrowser))
hl.bind(launchMod .. " + F", hl.dsp.exec_cmd(files))
hl.bind(launchMod .. " + V", hl.dsp.exec_cmd(volume))
hl.bind(launchMod .. " + B", hl.dsp.exec_cmd(bluetooth))
hl.bind(launchMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(launchMod .. " + D", hl.dsp.exec_cmd(documents))
hl.bind(launchMod .. " + I", hl.dsp.exec_cmd(ide))
hl.bind(launchMod .. " + N", hl.dsp.exec_cmd(notes))
hl.bind(launchMod .. " + C", hl.dsp.exec_cmd(chat))
hl.bind(launchMod .. " + P", hl.dsp.exec_cmd(passwords))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.window.close())
-- Under UWSM, do not use the exit dispatcher; gracefully stop the session.
hl.bind(mainMod .. " + SHIFT + CTRL + X", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("pkill " .. launcherProgram .. " || " .. appLauncher))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("pkill " .. launcherProgram .. " || " .. cmdLauncher), { release = true })
hl.bind(mainMod .. " + D", hl.dsp.window.pseudo()) -- dwindle
-- hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + CTRL + ALT + O", hl.dsp.exec_cmd("sleep 1 && hyprctl dispatch dpms toggle"), { locked = true })
hl.bind(mainMod .. " + CTRL + A", hl.dsp.exec_cmd("~/.config/hypr/noanims.sh"))
hl.bind(mainMod .. " + CTRL + P", hl.dsp.window.pin())
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + CTRL + D", hl.dsp.exec_cmd("swaync-client -d && swaync-client --hide-all"))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + CTRL + G", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mainMod .. " + T", hl.dsp.group.next())
hl.bind(mainMod .. " + CTRL + T", hl.dsp.group.prev())
hl.bind(mainMod .. " + SEMICOLON", hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + CTRL + SEMICOLON", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.exec_cmd("1password --quick-access"))

-- CoolerMaster TKL keyboard media binds
hl.bind("Control_R + INSERT", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("Control_R + DELETE", hl.dsp.exec_cmd("playerctl stop"))
hl.bind("Control_R + END", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("Control_R + HOME", hl.dsp.exec_cmd("playerctl next"))
hl.bind(
	"Control_R + PAGE_UP",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
)
hl.bind(
	"Control_R + PAGE_DOWN",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
)

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

-- Corne
hl.bind(mainMod .. " + M", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + N", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + E", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ direction = "r" }))

-- Switch focus to previously focused window
hl.bind("ALT_L + TAB", hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(windowSwitcher))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + CTRL + ALT + S", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind(mainMod .. " + CTRL + ALT + H", hl.dsp.exec_cmd("systemctl hibernate"), { locked = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower || wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })

hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	{ locked = true, repeating = true }
)

hl.bind("XF86Search", hl.dsp.exec_cmd(appLauncher))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -zm region -o $XDG_PICTURES_DIR/screenshots"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -zm output -o $XDG_PICTURES_DIR/screenshots"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -zm window -o $XDG_PICTURES_DIR/screenshots"))

hl.bind(
	mainMod .. " + CTRL + C",
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 -p Clipboard -img | cliphist decode | wl-copy")
)

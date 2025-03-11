-- Pull in the wezterm API
local wezterm = require("wezterm")

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.color_scheme = "Tokyo Night"
config.color_scheme = "rose-pine"
config.colors = {
	background = "#1f1928",
	-- background = "#000000",
}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages

-- This is where you actually apply your config choices
config.window_decorations = "RESIZE" -- removes window title bar
config.force_reverse_video_cursor = true
--  change
config.window_background_opacity = 0.9
config.font = wezterm.font("Mononoki Nerd Font")
config.hide_tab_bar_if_only_one_tab = true

-- activate ONLY if windows --

config.default_domain = "WSL:Ubuntu"
config.front_end = "OpenGL"

-- local opacity = 0.8
-- config.window_background_opacity = opacity
--
-- -- toggle function
-- wezterm.on("toggle-opacity", function(window, pane)
-- 	local overrides = window:get_config_overrides() or {}
-- 	if not overrides.window_background_opacity then
-- 		-- if no override is setup, override the default opacity value with 1.0
-- 		overrides.window_background_opacity = 0.8
-- 	else
-- 		-- if there is an override, make it nil so the opacity goes back to the default
-- 		overrides.window_background_opacity = nil
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)

config.keys = {
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.9
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

return config

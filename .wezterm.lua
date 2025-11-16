local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- General config
config.initial_cols = 122
config.initial_rows = 37
config.font = wezterm.font("MonaspiceAr Nerd Font Mono")
config.font_size = 16
config.color_scheme = "tokyonight_moon"
config.window_padding = {
	left = "15px",
	right = "15px",
	top = "5px",
	bottom = "5px",
}
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

-- Transprency (both fancy and retro)
config.use_fancy_tab_bar = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.7
config.macos_window_background_blur = 40
config.window_frame = {
	inactive_titlebar_bg = "rgba(0, 0, 0, 0.7)",
	active_titlebar_bg = "rgba(0, 0, 0, 0.7)",
}
config.colors = {
	background = "black",
	tab_bar = {
		background = "rgba(0,0,0,0.7)",
	},
}

-- Tab Title customizations
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	local user_title = tab.active_pane.user_vars.panetitle

	-- Prioritize user-set title if available
	if user_title ~= nil and #user_title > 0 then
		title = user_title
	end

	-- Extract the last component of the path
	local last_folder = title:match(".*/([^/]+)/?$") -- Matches the last part after the last '/'
	if last_folder then
		title = last_folder
	end

	return title
end)

return config

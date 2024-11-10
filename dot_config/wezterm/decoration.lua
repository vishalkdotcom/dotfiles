local wezterm = require("wezterm")

local M = {}

-- Night Owl Light palette
local palette = {
	black = "#403f53",
	red = "#de3d3b",
	green = "#08916a",
	yellow = "#daaa01",
	blue = "#288ed7",
	purple = "#d6438a",
	cyan = "#2AA298",
	white = "#F0F0F0",
	bright_black = "#403f53",
	bright_red = "#de3d3b",
	bright_green = "#08916a",
	bright_yellow = "#daaa01",
	bright_blue = "#288ed7",
	bright_purple = "#d6438a",
	bright_cyan = "#2AA298",
	bright_white = "#F0F0F0",
}

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local edge_background = palette.red
	local background = palette.white
	local foreground = palette.black

	if tab.is_active then
		background = palette.purple
		foreground = palette.bright_white
	elseif hover then
		-- background = palette.white
		background = "#e4e4e4"
		foreground = palette.black
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	-- title = wezterm.truncate_right(title, max_width)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		--{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		--{ Text = SOLID_RIGHT_ARROW },
	}
end)

function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

function M.setup(config, isWindows11)
	if isWindows11 then
		config.window_background_opacity = 0.5
		-- config.win32_system_backdrop = "Acrylic"
		config.win32_acrylic_accent_color = palette.purple
		config.webgpu_power_preference = "HighPerformance"
		config.front_end = "OpenGL"
		config.prefer_egl = true
		config.window_padding = {
			left = 5,
			right = 5,
			top = 5,
			bottom = 5,
		}
	end
	config.color_scheme = "Night Owlish Light"
	config.hide_tab_bar_if_only_one_tab = true
	config.default_cursor_style = "BlinkingBar"
	config.use_fancy_tab_bar = true
	config.tab_bar_at_bottom = false
	config.window_decorations = "NONE | RESIZE"
	config.cell_width = 0.9
	config.window_frame = {
		-- The overall background color of the tab bar when
		-- the window is focused
		active_titlebar_bg = "transparent",

		-- The overall background color of the tab bar when
		-- the window is not focused
		inactive_titlebar_bg = palette.white,
	}
end

return M

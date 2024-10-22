local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local config = wezterm.config_builder()
local keys = {}
local mouse_bindings = {}
local launch_menu = {}
local haswork, work = pcall(require, "work")

--- Setup PowerShell options
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	--- Grab the ver info for later use.
	local success, stdout, stderr = wezterm.run_child_process({ "cmd.exe", "ver" })
	local major, minor, build, rev = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
	local is_windows_11 = tonumber(build) >= 22000

	--- Make it look cool.
	if is_windows_11 then
		wezterm.log_info("We're running Windows 11!")
		config.window_background_opacity = 0.5
		-- config.win32_system_backdrop = "Acrylic"
		config.win32_acrylic_accent_color = "rgb(94, 64, 157)"
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

	--- Set Pwsh as the default on Windows
	config.default_prog = { "pwsh.exe", "-NoLogo" }
	table.insert(launch_menu, {
		label = "Pwsh",
		args = { "pwsh.exe", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "Pwsh No Profile",
		args = { "pwsh.exe", "-NoLogo", "-NoProfile" },
	})
	table.insert(launch_menu, {
		label = "PowerShell No Profile",
		args = { "powershell.exe", "-NoLogo", "-NoProfile" },
	})
else
	--- Non-Windows Machine
	table.insert(launch_menu, {
		label = "Pwsh",
		args = { "/usr/local/bin/pwsh", "-NoLogo" },
	})
	table.insert(launch_menu, {
		label = "Pwsh No Profile",
		args = { "/usr/local/bin/pwsh", "-NoLogo", "-NoProfile" },
	})
end

--- Disable defaul keys and set some minimum ones for now.
--- This helps with conflicting keys in pwsh
keys = {
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.EmitEvent("toggle-colorscheme"),
	},
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
	{ key = "!", mods = "CTRL", action = act.ActivateTab(0) },
	{ key = "!", mods = "SHIFT|CTRL", action = act.ActivateTab(0) },
	{ key = '"', mods = "ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "#", mods = "CTRL", action = act.ActivateTab(2) },
	{ key = "#", mods = "SHIFT|CTRL", action = act.ActivateTab(2) },
	{ key = "$", mods = "CTRL", action = act.ActivateTab(3) },
	{ key = "$", mods = "SHIFT|CTRL", action = act.ActivateTab(3) },
	{ key = "%", mods = "CTRL", action = act.ActivateTab(4) },
	{ key = "%", mods = "SHIFT|CTRL", action = act.ActivateTab(4) },
	{ key = "%", mods = "ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "SHIFT|ALT|CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "&", mods = "CTRL", action = act.ActivateTab(6) },
	{ key = "&", mods = "SHIFT|CTRL", action = act.ActivateTab(6) },
	{ key = "'", mods = "SHIFT|ALT|CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "(", mods = "CTRL", action = act.ActivateTab(-1) },
	{ key = "(", mods = "SHIFT|CTRL", action = act.ActivateTab(-1) },
	{ key = ")", mods = "CTRL", action = act.ResetFontSize },
	{ key = ")", mods = "SHIFT|CTRL", action = act.ResetFontSize },
	{ key = "*", mods = "CTRL", action = act.ActivateTab(7) },
	{ key = "*", mods = "SHIFT|CTRL", action = act.ActivateTab(7) },
	{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "-", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
	{ key = "-", mods = "SUPER", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "0", mods = "SHIFT|CTRL", action = act.ResetFontSize },
	{ key = "0", mods = "SUPER", action = act.ResetFontSize },
	-- I use Ctrl + Number in all my other apps.
	-- I also never have more the 5 tabs
	{ key = "1", mods = "CTRL", action = act.ActivateTab(0) },
	{ key = "2", mods = "CTRL", action = act.ActivateTab(1) },
	{ key = "3", mods = "CTRL", action = act.ActivateTab(2) },
	{ key = "4", mods = "CTRL", action = act.ActivateTab(3) },
	{ key = "5", mods = "CTRL", action = act.ActivateTab(4) },
	-- { key = '1', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
	-- { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
	-- { key = '2', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
	-- { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
	-- { key = '3', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
	-- { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
	-- { key = '4', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
	-- { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
	-- { key = '5', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
	-- { key = '5', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal-- { domain =  'CurrentPaneDomain' } },
	-- { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
	-- { key = '6', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
	-- { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
	-- { key = '7', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
	-- { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
	-- { key = '8', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
	-- { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },
	-- { key = '9', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
	-- { key = '9', mods = 'SUPER', action = act.ActivateTab(-1) },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "=", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
	{ key = "=", mods = "SUPER", action = act.IncreaseFontSize },
	{ key = "@", mods = "CTRL", action = act.ActivateTab(1) },
	{ key = "@", mods = "SHIFT|CTRL", action = act.ActivateTab(1) },
	{ key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	{ key = "F", mods = "CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "F", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "K", mods = "CTRL", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "K", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{ key = "L", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
	{ key = "M", mods = "CTRL", action = act.Hide },
	{ key = "M", mods = "SHIFT|CTRL", action = act.Hide },
	{ key = "N", mods = "CTRL", action = act.SpawnWindow },
	{ key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
	{ key = "R", mods = "CTRL", action = act.ReloadConfiguration },
	{ key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
	{ key = "T", mods = "CTRL", action = act.ShowLauncher },
	{ key = "T", mods = "SHIFT|CTRL", action = act.ShowLauncher },
	{
		key = "U",
		mods = "CTRL",
		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
	},
	{
		key = "U",
		mods = "SHIFT|CTRL",
		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
	},
	{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	{ key = "W", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "X", mods = "CTRL", action = act.ActivateCopyMode },
	{ key = "X", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
	{ key = "Z", mods = "CTRL", action = act.TogglePaneZoomState },
	{ key = "Z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
	{ key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
	{ key = "^", mods = "CTRL", action = act.ActivateTab(5) },
	{ key = "^", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
	{ key = "_", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
	{ key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
	{ key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
	{ key = "f", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "k", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
	{ key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
	{ key = "m", mods = "SHIFT|CTRL", action = act.Hide },
	{ key = "m", mods = "SUPER", action = act.Hide },
	{ key = "n", mods = "SUPER", action = act.SpawnWindow },
	{ key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
	{ key = "r", mods = "SUPER", action = act.ReloadConfiguration },
	{ key = "t", mods = "SHIFT|CTRL", action = act.ShowLauncher },
	{ key = "t", mods = "SUPER", action = act.ShowLauncher },
	{
		key = "u",
		mods = "SHIFT|CTRL",
		action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
	},
	{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
	{ key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "w", mods = "SUPER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "x", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
	{ key = "z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
	{ key = "{", mods = "SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "{", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
	{ key = "}", mods = "SUPER", action = act.ActivateTabRelative(1) },
	{ key = "}", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
	{ key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
	{ key = "PageUp", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "PageUp", mods = "SHIFT|CTRL", action = act.MoveTabRelative(-1) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
	{ key = "PageDown", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "PageDown", mods = "SHIFT|CTRL", action = act.MoveTabRelative(1) },
	{ key = "LeftArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Left", 1 }) },
	-- Turning these off so I can use pwsh keys
	-- { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
	-- { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
	-- Add these to allow quick moving between prompts
	-- Use ctrl up/down to match vscode. Shift didn't feel natural
	{ key = "UpArrow", mods = "CTRL", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "CTRL", action = act.ScrollToPrompt(1) },
	--
	{ key = "RightArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "UpArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = act.ActivatePaneDirection("Down") },
	{ key = "DownArrow", mods = "SHIFT|ALT|CTRL", action = act.AdjustPaneSize({ "Down", 1 }) },
	{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") },
	{ key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
	{ key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
	{ key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.5
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- Mousing bindings
mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},

	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

--- Default config settings
config.scrollback_lines = 7000
config.hyperlink_rules = wezterm.default_hyperlink_rules()
config.hide_tab_bar_if_only_one_tab = true
-- config.color_scheme = "flexoki-dark"
config.font = wezterm.font_with_fallback({
	{
		family = "FiraCode Nerd Font",
	},
	{
		family = "FiraMono Nerd Font",
	},
	{
		family = "IosevkaTerm NFM",
	},
	{
		family = "Hack Nerd Font",
	},
})
config.font_size = 9
config.launch_menu = launch_menu
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
config.keys = keys
config.mouse_bindings = mouse_bindings
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.window_decorations = "NONE | RESIZE"
config.cell_width = 0.9

wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "Flexoki Dark" then
		overrides.color_scheme = "Adventure Time (Gogh)"
	else
		overrides.color_scheme = "Flexoki Dark"
	end
	window:set_config_overrides(overrides)
end)
-- Allow overwriting for work stuff
if haswork then
	work.apply_to_config(config)
end

return config

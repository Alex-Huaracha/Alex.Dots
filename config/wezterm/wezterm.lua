-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                            ALEX.DOTS - WEZTERM                               ║
-- ║                           Optimized for Neovim                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                   FONT                                       │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 10.0

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  WINDOW                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.window_background_opacity = 0.95

config.window_padding = {
	top = 0,
	right = 0,
	left = 0,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  CURSOR                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.default_cursor_style = "SteadyBlock"

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            NEOVIM OPTIMIZATIONS                              │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- Terminal & Colors
-- WSL doesn't have wezterm terminfo, so we use xterm-256color there
if wezterm.target_triple:find("windows") then
	config.term = "xterm-256color"
else
	config.term = "wezterm"
end
config.enable_kitty_keyboard = true

-- Undercurl support (LSP diagnostics, spelling)
config.underline_thickness = 2
config.underline_position = -2

-- Scrollback
config.scrollback_lines = 10000

-- Performance
config.max_fps = 240

-- Image support
config.enable_kitty_graphics = true

config.use_dead_keys = false

-- Keep long lines intact when copying (no fake newlines at wrap points)
config.canonicalize_pasted_newlines = "None"

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                              THEME COLORS                                    │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- Full palette (foreground + 16 ANSI colors). Swap for any builtin scheme:
-- https://wezterm.org/colorschemes/index.html
config.color_scheme = "Kanagawa (Gogh)"

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                              WINDOWS (WSL)                                   │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.default_domain = "WSL:Ubuntu"

local act = wezterm.action

config.keys = {
	{ key = "v", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

	{ key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 10 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 10 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 10 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 10 }) },
}

return config

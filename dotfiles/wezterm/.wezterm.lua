local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}
local act = wezterm.action

-- Configuración visual
config.color_scheme = "rose-pine"
config.colors = {
	background = "#1f1928",
	tab_bar = {
		background = "#191724",
		active_tab = {
			bg_color = "#eb6f92",
			fg_color = "#191724",
			intensity = "Normal",
			underline = "None",
			italic = false,
		},
		inactive_tab = { bg_color = "#191724", fg_color = "#555169" },
		inactive_tab_hover = { bg_color = "#9ccfd8", fg_color = "#191724", italic = false },
		new_tab = { bg_color = "#191724", fg_color = "#555169" },
		new_tab_hover = { bg_color = "#9ccfd8", fg_color = "#191724" },
	},
}
config.window_decorations = "RESIZE"
config.force_reverse_video_cursor = true
config.window_background_opacity = 1.0
config.font = wezterm.font("Mononoki Nerd Font")
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.front_end = "OpenGL"
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.window_close_confirmation = "AlwaysPrompt"

-- Prefijo estilo tmux (Ctrl+a)
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

-- Función auxiliar para verificar si un elemento está en una tabla
local function table_contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

-- Crear o cambiar a un workspace
local function switch_or_create_workspace(name, dir)
	return wezterm.action_callback(function(window, pane)
		local workspaces = window:mux_window():get_workspace_names()
		if not table_contains(workspaces, name) then
			window:perform_action(act.SpawnTab({ cwd = dir }), pane)
			window:mux_window():set_workspace(name)
		else
			window:perform_action(act.SwitchToWorkspace({ name = name }), pane)
		end
	end)
end

-- Crear un nuevo workspace con nombre ingresado por el usuario
local function create_workspace()
	return act.PromptInputLine({
		description = "Enter workspace name",
		action = wezterm.action_callback(function(window, pane, line)
			if line then
				window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
			end
		end),
	})
end

-- Renombrar el workspace actual
local function rename_workspace()
	return act.PromptInputLine({
		description = "Enter new workspace name",
		action = wezterm.action_callback(function(window, pane, line)
			if line then
				window:mux_window():set_workspace(line)
			end
		end),
	})
end

-- Eliminar el workspace actual (cerrar todas las pestañas)
local function delete_workspace()
	return wezterm.action_callback(function(window, pane)
		local mux_window = window:mux_window()
		for _, tab in ipairs(mux_window:tabs()) do
			tab:close()
		end
		-- Cambiar a otro workspace si existe
		local workspaces = mux_window:get_workspace_names()
		if #workspaces > 1 then
			window:perform_action(act.SwitchToWorkspace({ name = workspaces[1] }), pane)
		end
	end)
end

config.keys = {
	-- Pestañas
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") }, -- Ctrl+a c
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) }, -- Ctrl+a n
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) }, -- Ctrl+a p

	-- Paneles (División y Navegación)
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- Ctrl+a -
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- Ctrl+a v
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") }, -- Ctrl+a h
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") }, -- Ctrl+a j
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") }, -- Ctrl+a k
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") }, -- Ctrl+a l
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) }, -- Ctrl+a x

	-- Ajustar tamaño de paneles
	{ key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) }, -- Ctrl+a Shift+H
	{ key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) }, -- Ctrl+a Shift+L
	{ key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) }, -- Ctrl+a Shift+K
	{ key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) }, -- Ctrl+a Shift+J

	-- Modo visual (copy mode)
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode }, -- Ctrl+a [

	-- Renombrar pestaña
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new tab title",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	}, -- Ctrl+a ,

	-- Guardar sesión de Neovim
	{
		key = "w",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({ args = { "nvim", "-c", "lua require('persistence').save()" } }),
	}, -- Ctrl+a w

	-- Atajo de opacidad
	{
		key = "O",
		mods = "CTRL|ALT",
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

	-- Gestión de workspaces
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) }, -- Ctrl+a w (Listar workspaces)
	{ key = "s", mods = "LEADER", action = create_workspace() }, -- Ctrl+a s (Crear workspace)
	{ key = "(", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) }, -- Ctrl+a ( (Workspace anterior)
	{ key = ")", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) }, -- Ctrl+a ) (Workspace siguiente)
	{ key = "$", mods = "LEADER", action = rename_workspace() }, -- Ctrl+a $ (Renombrar workspace)
	{ key = "&", mods = "LEADER", action = delete_workspace() }, -- Ctrl+a & (Eliminar workspace)

	-- Abrir Yazi
	{
		key = "y",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({
			args = { "pwsh.exe", "-NoLogo", "-Command", "y" },
		}),
	}, -- Ctrl+a y
}

-- Atajos para pestañas 1-9 (Ctrl+a 1 al Ctrl+a 9)
for i = 1, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
end

-- Configuración del modo de copia
config.key_tables = {
	copy_mode = {
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
		{
			key = "Enter",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
	},
}

config.enable_tab_bar = true
config.use_fancy_tab_bar = false

-- Formato minimalista de pestañas
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	if tab.tab_title then
		title = tab.tab_title
	end
	local index = tab.tab_index + 1
	local is_active = tab.is_active
	local background = is_active and "#eb6f92" or "#191724"
	local foreground = is_active and "#191724" or "#555169"
	if hover then
		background = "#9ccfd8"
		foreground = "#191724"
	end
	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. index .. " " .. title .. " " },
	}
end)

return config

local wezterm = require("wezterm")
local config = wezterm.config_builder and wezterm.config_builder() or {}
local act = wezterm.action

-- Configuración visual
config.color_scheme = "rose-pine"
config.tab_bar_at_bottom = true
config.colors = {
	background = "#000",
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
config.font = wezterm.font("JetBrains Mono", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.front_end = "OpenGL"
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.window_close_confirmation = "AlwaysPrompt"

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
	return wezterm.action.PromptInputLine({
		description = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { Color = "#ff79c6" } },
			{ Text = "Rename workspace to: " },
		}),
		action = wezterm.action_callback(function(win, pane, name)
			if name and #name:gsub("%s", "") > 0 then
				wezterm.run_child_process({ "wezterm", "cli", "rename-workspace", name })
				-- Actualiza también el título de la pestaña para verlo al instante
				win:set_title(name)
			end
		end),
	})
end

-- Eliminar el workspace actual (cerrar todas las pestañas)

-- Función helper para filtrar (como u.filter o util.filter del código que compartiste)
local function filter(tbl, callback)
	local filt_table = {}
	for i, v in ipairs(tbl) do
		if callback(v, i) then
			table.insert(filt_table, v)
		end
	end
	return filt_table
end

local function delete_workspace()
	return wezterm.action_callback(function(window, pane)
		local current_workspace = window:active_workspace() -- O window:mux_window():get_workspace() si usas eso

		-- Si solo hay un workspace, no lo borres (evita quedarte sin nada)
		local all_workspaces = wezterm.mux.get_workspace_names()
		if #all_workspaces <= 1 then
			wezterm.log_error("No se puede borrar el último workspace")
			return
		end

		-- Encontrar el siguiente workspace (el primero que no sea el actual)
		local next_workspace = nil
		for _, ws in ipairs(all_workspaces) do
			if ws ~= current_workspace then
				next_workspace = ws
				break
			end
		end

		-- Confirmación (opcional, pero recomendada para no borrar por error)
		window:perform_action(
			wezterm.action.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { Color = "#ff5555" } },
					{ Text = 'Borrar workspace "' .. current_workspace .. '"? Escribe "yes" para confirmar: ' },
				}),
				action = wezterm.action_callback(function(win, _, line)
					if line and line:lower() == "yes" then
						-- Cambiar al siguiente workspace primero
						win:perform_action(wezterm.action.SwitchToWorkspace({ name = next_workspace }), pane)

						-- Pequeño delay para que el switch se complete
						wezterm.sleep_ms(50)

						-- Ahora sí: matar todos los panes del workspace original
						local success, stdout = wezterm.run_child_process({ "wezterm", "cli", "list", "--format=json" })
						if success then
							local json = wezterm.json_parse(stdout)
							if json then
								local workspace_panes = filter(json, function(p)
									return p.workspace == current_workspace
								end)

								for _, p in ipairs(workspace_panes) do
									wezterm.run_child_process({
										"wezterm",
										"cli",
										"kill-pane",
										"--pane-id=" .. p.pane_id,
									})
								end
								wezterm.log_info('Workspace "' .. current_workspace .. '" eliminado')
							end
						end
					else
						wezterm.log_info("Eliminación de workspace cancelada")
					end
				end),
			}),
			pane
		)
	end)
end

-- cambiar tema actual con alguno de los que trae wezterm por default
local function change_theme()
	return wezterm.action_callback(function(window, pane)
		local schemes = wezterm.get_builtin_color_schemes()
		local choices = {}
		for name in pairs(schemes) do
			table.insert(choices, { label = name })
		end
		table.sort(choices, function(a, b)
			return a.label < b.label
		end)

		window:perform_action(
			wezterm.action.InputSelector({
				action = wezterm.action_callback(function(win, _, _, label)
					if not label then
						return -- user cancelled
					end
					local overrides = win:get_config_overrides() or {}
					overrides.color_scheme = label
					win:set_config_overrides(overrides)
				end),
				title = "Selecciona el tema",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Select Theme: ",
			}),
			pane
		)
	end)
end

-- cambiar fuente actual con alguno de los que trae wezterm por default
local function change_font()
	return wezterm.action_callback(function(window, pane)
		local success, stdout, stderr = wezterm.run_child_process({ "wezterm", "ls-fonts", "--list-system" })
		if not success then
			wezterm.log_error("Failed to run wezterm ls-fonts: " .. stderr)
			return
		end

		local fonts = {}
		for line in stdout:gmatch("[^\r\n]+") do
			local family = line:match('wezterm%.font%("([^"]+)"')
			if family then
				fonts[family] = true
			end
		end

		local font_list = {}
		for name in pairs(fonts) do
			table.insert(font_list, name)
		end
		table.sort(font_list)

		local choices = {}
		for _, name in ipairs(font_list) do
			table.insert(choices, { label = name })
		end

		window:perform_action(
			wezterm.action.InputSelector({
				action = wezterm.action_callback(function(win, _, _, label)
					if not label then
						return -- user cancelled
					end
					local overrides = win:get_config_overrides() or {}
					overrides.font = wezterm.font(label)
					win:set_config_overrides(overrides)
				end),
				title = "Select Font",
				choices = choices,
				fuzzy = true,
				fuzzy_description = "Select Font: ",
			}),
			pane
		)
	end)
end

-- Prefijo estilo tmux (Ctrl+a)
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }

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
	{ key = "W", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) }, -- Ctrl+a w (Listar workspaces)
	{ key = "C", mods = "LEADER", action = create_workspace() }, -- Ctrl+a s (Crear workspace)
	{ key = "(", mods = "LEADER", action = act.SwitchWorkspaceRelative(-1) }, -- Ctrl+a ( (Workspace anterior)
	{ key = ")", mods = "LEADER", action = act.SwitchWorkspaceRelative(1) }, -- Ctrl+a ) (Workspace siguiente)
	{ key = "r", mods = "LEADER", action = rename_workspace() }, -- Ctrl+s $ (Renombrar workspace)
	{ key = "X", mods = "LEADER", action = delete_workspace() }, -- Ctrl+a & (Eliminar workspace)

	-- Abrir Yazi
	{
		key = "y",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({
			args = { "pwsh.exe", "-NoLogo", "-Command", "y" },
		}),
	}, -- Ctrl+a y

	-- custom keymaps
	{
		key = "f",
		mods = "LEADER",
		action = change_font(),
	},
	{
		key = "t",
		mods = "LEADER",
		action = change_theme(),
	},
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

-- SESIONIZER PLUGIN
-- SESSIONIZER
local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")
local history = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer-history")

local schema = {
	options = { callback = history.Wrapper(sessionizer.DefaultCallback) },
	sessionizer.DefaultWorkspace({}),
	history.MostRecentWorkspace({}),

	wezterm.home_dir .. "/AppData/Local/nvim",
	wezterm.home_dir .. "/Desktop/Ronald/Personal/Projects/Dev-environment",
	wezterm.home_dir .. "/Desktop/Ronald/Lugotech/Obsidian/Work",
	-- wezterm.home_dir .. "/Desktop/Ronald/Lugotech/Projects",

	sessionizer.FdSearch(wezterm.home_dir .. "/Desktop/Ronald/Lugotech/Projects"),

	processing = {
		sessionizer.for_each_entry(
			function(entry) -- recolors labels and replaces the absolute path to the home directory with ~
				entry.label = wezterm.format({
					{ Foreground = { Color = "#cc99ff" } },
					{ Text = entry.label:gsub(wezterm.home_dir, "~") },
				})
			end
		),

		sessionizer.for_each_entry(function(entry)
			entry.label = "📁 " .. entry.label
		end),
	},
}

table.insert(config.keys, {
	key = "s",
	mods = "LEADER",
	action = sessionizer.show(schema),
})
table.insert(config.keys, {
	key = "m",
	mods = "LEADER",
	action = history.switch_to_most_recent_workspace,
})

-- WORKSPACE SWITCHER
local smart_workspace_switcher_replica = {
	options = {
		prompt = "Elija el workspace: ",
		callback = history.Wrapper(sessionizer.DefaultCallback),
	},
	{
		sessionizer.AllActiveWorkspaces({ filter_current = false, filter_default = false }),
		processing = sessionizer.for_each_entry(function(entry)
			entry.label = wezterm.format({
				{ Foreground = { Color = "#cc99ff" } },
				{ Text = "󱂬 : " .. entry.label },
			})
		end),
	},
	wezterm.plugin.require("https://github.com/mikkasendke/sessionizer-zoxide.git").Zoxide({}),
	processing = sessionizer.for_each_entry(function(entry)
		entry.label = entry.label:gsub(wezterm.home_dir, "~")
	end),
}

table.insert(config.keys, {
	key = "w",
	mods = "LEADER",
	action = sessionizer.show(smart_workspace_switcher_replica),
})

-- wezterm.on("update-right-status", function(window)
-- 	local font = window:effective_config().font.font[1].family
-- 	local size = window:effective_config().font_size
-- 	local status = wezterm.format({
-- 		"ResetAttributes",
-- 		{ Background = { Color = "#666666" } },
-- 		{ Foreground = { Color = "White" } },
-- 		{ Text = string.format(" %s %spt  ", font, size) },
-- 	})
-- 	window:set_right_status(status)
-- end)

return config

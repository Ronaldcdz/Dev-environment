-- Omarchy normally symlinks this file to the active system theme's
-- neovim.lua (~/.local/state/omarchy/current/theme/neovim.lua), regenerated
-- whenever you switch themes with Omarchy's theme-switcher. That
-- integration doesn't exist outside Omarchy, so this just pins a static
-- colorscheme instead. Swap "tokyonight" for the name/id of any theme
-- loaded in plugins/all-themes.lua to use a different one.
return {
	"LazyVim/LazyVim",
	opts = {
		colorscheme = "tokyonight",
	},
}

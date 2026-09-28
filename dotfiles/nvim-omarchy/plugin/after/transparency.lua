-- Strips the background from a curated list of highlight groups so the
-- terminal's own background (or wallpaper, in Omarchy) shows through.
-- Neovim auto-sources every plugin/**/*.lua on the runtimepath at startup,
-- so this runs on its own without needing the hot-reload plugin Omarchy
-- pairs it with.
--
-- Reconstructed from the omarchy-nvim package (omacom-io/omarchy-pkgs,
-- pkgbuilds/omarchy-nvim/plugin/after/transparency.lua); the exact source
-- couldn't be fetched byte-for-byte, so double check against upstream if
-- you want a 1:1 copy.
local function make_transparent(group)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
	if not ok then
		return
	end
	hl.bg = nil
	pcall(vim.api.nvim_set_hl, 0, group, hl)
end

local groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"FloatTitle",
	"SignColumn",
	"LineNr",
	"CursorLineNr",
	"EndOfBuffer",
	"Pmenu",
	"PmenuSel",
	"PmenuSbar",
	"PmenuThumb",
	"TabLine",
	"TabLineFill",
	"TabLineSel",
	"StatusLine",
	"StatusLineNC",
	"WinSeparator",
	"VertSplit",
	"NeoTreeNormal",
	"NeoTreeNormalNC",
	"NeoTreeEndOfBuffer",
	"NvimTreeNormal",
	"NvimTreeNormalNC",
	"NvimTreeEndOfBuffer",
	"TelescopeNormal",
	"TelescopeBorder",
	"TelescopePromptNormal",
	"TelescopePromptBorder",
	"TelescopeResultsNormal",
	"TelescopeResultsBorder",
	"TelescopePreviewNormal",
	"TelescopePreviewBorder",
	"WhichKeyFloat",
	"NotifyBackground",
	"NotifyINFOBody",
	"NotifyINFOBorder",
	"NotifyINFOTitle",
	"NotifyERRORBody",
	"NotifyERRORBorder",
	"NotifyERRORTitle",
	"NotifyWARNBody",
	"NotifyWARNBorder",
	"NotifyWARNTitle",
	"NotifyTRACEBody",
	"NotifyTRACEBorder",
	"NotifyTRACETitle",
	"NotifyDEBUGBody",
	"NotifyDEBUGBorder",
	"NotifyDEBUGTitle",
}

for _, group in ipairs(groups) do
	make_transparent(group)
end

local renderOpts = {
	heading = {
		enabled = true,
		render_modes = true,
		sign = true,
		icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
		position = "overlay",
		signs = { "󰫎 " },
		width = "full",
		left_margin = 0,
		left_pad = 0,
		right_pad = 0,
		min_width = 0,
		border = false,
		border_virtual = false,
		border_prefix = false,
		above = "▄",
		below = "▀",
		backgrounds = {
			"RenderMarkdownH1Bg",
			"RenderMarkdownH2Bg",
			"RenderMarkdownH3Bg",
			"RenderMarkdownH4Bg",
			"RenderMarkdownH5Bg",
			"RenderMarkdownH6Bg",
		},
		foregrounds = {
			"RenderMarkdownH1",
			"RenderMarkdownH2",
			"RenderMarkdownH3",
			"RenderMarkdownH4",
			"RenderMarkdownH5",
			"RenderMarkdownH6",
		},
	},
	paragraph = {
		enabled = true,
		render_modes = true,
		left_margin = 0,
		min_width = 0,
	},
	code = {
		enabled = true,
		render_modes = true,
		sign = true,
		style = "full",
		position = "left",
		language_pad = 0,
		language_name = true,
		disable_background = { "diff" },
		width = "full",
		left_margin = 0,
		left_pad = 0,
		right_pad = 0,
		min_width = 0,
		border = "thin",
		above = "▄",
		below = "▀",
		highlight = "RenderMarkdownCode",
		highlight_language = nil,
		inline_pad = 0,
		highlight_inline = "RenderMarkdownCodeInline",
	},
	dash = {
		enabled = true,
		render_modes = true,
		icon = "─",
		width = "full",
		left_margin = 0,
		highlight = "RenderMarkdownDash",
	},
	bullet = {
		enabled = true,
		render_modes = true,
		-- icons = { "●", "○", "◆", "◇" },
		-- ordered_icons = function(level, index, value)
		--   value = vim.trim(value)
		--   local value_index = tonumber(value:sub(1, #value - 1))
		--   return string.format("%d.", value_index > 1 and value_index or index)
		-- end,
		left_pad = 0,
		right_pad = 0,
		highlight = "RenderMarkdownBullet",
	},
	checkbox = {
		enabled = true,
		render_modes = true,
		position = "inline",
		unchecked = {
			icon = "󰄱 ",
			highlight = "RenderMarkdownUnchecked",
			scope_highlight = nil,
		},
		checked = {
			icon = "󰱒 ",
			highlight = "RenderMarkdownChecked",
			scope_highlight = nil,
		},
		custom = {
			todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
		},
	},
	quote = {
		enabled = true,
		render_modes = true,
		icon = "▋",
		repeat_linebreak = false,
		highlight = "RenderMarkdownQuote",
	},
	pipe_table = {
		enabled = true,
		render_modes = true,
		preset = "none",
		style = "full",
		cell = "padded",
		padding = 1,
		min_width = 0,
		border = {
			"┌",
			"┬",
			"┐",
			"├",
			"┼",
			"┤",
			"└",
			"┴",
			"┘",
			"│",
			"─",
		},
		alignment_indicator = "━",
		head = "RenderMarkdownTableHead",
		row = "RenderMarkdownTableRow",
		filler = "RenderMarkdownTableFill",
	},
	callout = {
		note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
		tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
		important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
		warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
		caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
		-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
		abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
		summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
		tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
		info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
		todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
		hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
		success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
		check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
		done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
		question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
		help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
		faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
		attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
		failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
		fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
		missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
		danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
		error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
		bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
		example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
		quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
		cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
	},
	link = {
		enabled = true,
		render_modes = true,
		footnote = {
			superscript = true,
			prefix = "",
			suffix = "",
		},
		image = "󰥶 ",
		email = "󰀓 ",
		hyperlink = "󰌹 ",
		highlight = "RenderMarkdownLink",
		wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
		custom = {
			web = { pattern = "^http", icon = "󰖟 " },
			youtube = { pattern = "youtube%.com", icon = "󰗃 " },
			github = { pattern = "github%.com", icon = "󰊤 " },
			neovim = { pattern = "neovim%.io", icon = " " },
			stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
			discord = { pattern = "discord%.com", icon = "󰙯 " },
			reddit = { pattern = "reddit%.com", icon = "󰑍 " },
		},
	},
	sign = {
		enabled = true,
		highlight = "RenderMarkdownSign",
	},
	indent = {
		enabled = false,
		render_modes = false,
		per_level = 2,
		skip_level = 1,
		skip_heading = false,
	},
}

require("render-markdown").setup(renderOpts)

vim.keymap.set("n", "<leader>um", function()
	local rm = require("render-markdown")
	local enabled = require("render-markdown.state").enabled
	if enabled then
		rm.disable()
	else
		rm.enable()
	end
end, { desc = "Toggle Render Markdown" })

-- Markdown preview
vim.keymap.set("n", "<leader>cp", function()
	vim.fn["mkdp#util#install"]()
	vim.cmd("MarkdownPreviewToggle")
end, { desc = "Markdown preview" })

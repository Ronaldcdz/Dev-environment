vim.pack.add({
	{
		src = "https://github.com/obsidian-nvim/obsidian.nvim",
		version = vim.version.range("*"), -- use latest release, remove to use latest commit
	},
})

require("obsidian").setup({
	legacy_commands = false, -- this will be removed in 4.0.0
	workspaces = {
		{
			name = "personal",
			path = "~/vaults/personal",
		},
		{
			name = "work",
			path = "~/vaults/work",
		},

		completion = {
			nvim_cmp = false,
			blink = true,
			min_chars = 2,
		},

		picker = {
			name = "snacks.pick",
		},
		notes_subdir = "Fugaz", -- Subdirectory for notes
		new_notes_location = "Fugaz", -- Location for new notes

		-- Settings for attachments
		attachments = {
			folder = "Recursos", -- Folder for image attachments
			img_text_func = function(path)
				local name = vim.fs.basename(tostring(path))
				local encoded_name = require("obsidian.util").urlencode(name)
				return string.format("![%s](%s)", name, encoded_name)
			end,
		},

		-- Settings for daily notes
		daily_notes = {
			template = "note", -- Template for daily notes
			folder = "notes/dailies",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
		},
		-- Settings for templates
		templates = {
			subdir = "Plantillas", -- Subdirectory for templates
			date_format = "%Y-%m-%d-%a", -- Date format for templates
			gtime_format = "%H:%M", -- Time format for templates
			tags = "", -- Default tags for templates
		},
	},
})

vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Cycle through checkbox options." })
vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian today<cr>", { desc = "New Obsidian note" })
vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Obsidian notes" })
vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switch" })
-- vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show location list of backlinks" })
vim.keymap.set("n", "<leader>ow", "<cmd>Obsidian workspace<cr>", { desc = "Change workspace" })
vim.keymap.set("n", "<leader>op", "<cmd>Obsidian paste_img<cr>", { desc = "Paste imate from clipboard under cursor" })
vim.keymap.set(
	"n",
	"<leader>oe",
	"<cmd>Obsidian extract_note<cr>",
	{ desc = "Extracts visually selected note creates a new one with link" }
)
vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open current obsidian on app" })

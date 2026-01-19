return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- Use the latest release instead of the latest commit (recommended)
  lazy = false,
  enabled = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  config = function()
    require("obsidian").setup({
      ui = {
        enable = false,
      },
      workspaces = {
        -- {
        --   name = "personal", -- Name of the workspace
        --   path = "~/Desktop/Projects/Obsidian", -- Path to the notes directory
        -- },
        {
          name = "work", -- Name of the workspace
          path = "C:/Users/RonaldCadiz/Desktop/Ronald/Lugotech/Obsidian/Work", -- Path to the notes directory
        },
        {
          name = "personal work", -- Name of the workspace
          path = "C:/Users/RonaldCadiz/Desktop/Ronald/Personal/Obsidian", -- Path to the notes directory
        },
      },

      -- Completion settings
      completion = {
        blink = true,
        min_chars = 2,
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
      callbacks = {
        -- enter_note = function(note)
        --   vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian smart_action<cr>", {
        --     buffer = note.bufnr,
        --     desc = "Toggle checkbox",
        --   })
        -- end,
      },

      -- Settings for templates
      templates = {
        subdir = "Plantillas", -- Subdirectory for templates
        date_format = "%Y-%m-%d-%a", -- Date format for templates
        gtime_format = "%H:%M", -- Time format for templates
        tags = "", -- Default tags for templates
      },

      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- follow_url_func = function(url)
      --   -- Open the URL in the default web browser.
      --   -- vim.fn.jobstart({ "open", url }) -- Mac OS
      --   -- vim.fn.jobstart({"xdg-open", url})  -- linux
      --   -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      --   vim.ui.open(url) -- need Neovim 0.10.0+
      -- end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      -- follow_img_func = function(img)
      --   -- vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
      --   -- vim.fn.jobstart({"xdg-open", url})  -- linux
      --   vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- end,

      picker = {
        name = "snacks.pick",
        -- name = "telescope.nvim",
      },
    })

    -- vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian follow_link<cr>", { desc = "follows note under cursor" })

    vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Cycle through checkbox options." })
    vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Obsidian note" })
    vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "New Obsidian note" })
    vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Obsidian notes" })
    vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switch" })
    -- vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show location list of backlinks" })
    vim.keymap.set("n", "<leader>ow", "<cmd>Obsidian workspace<cr>", { desc = "Change workspace" })
    vim.keymap.set(
      "n",
      "<leader>op",
      "<cmd>Obsidian paste_img<cr>",
      { desc = "Paste imate from clipboard under cursor" }
    )
    vim.keymap.set(
      "n",
      "<leader>oe",
      "<cmd>Obsidian extract_note<cr>",
      { desc = "Extracts visually selected note creates a new one with link" }
    )
    vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open current obsidian on app" })
  end,
}

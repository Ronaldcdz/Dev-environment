return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- Use the latest release instead of the latest commit (recommended)
  lazy = false,
  enabled = true,
  ft = "markdown",
  dependencies = {
    -- Dependency: plenary.nvim
    -- URL: https://github.com/nvim-lua/plenary.nvim
    -- Description: A Lua utility library for Neovim.
    "nvim-lua/plenary.nvim",
  },

  config = function()
    require("obsidian").setup({
      -- Define workspaces for Obsidian
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
        img_folder = "Recursos", -- Folder for image attachments
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
        enter_note = function(_, note)
          vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
            buffer = note.bufnr,
            desc = "Toggle checkbox",
          })
        end,
      },
      -- Key mappings for Obsidian commands
      -- mappings = {
      --   -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      --   ["gf"] = {
      --     action = function()
      --       return require("obsidian").util.gf_passthrough()
      --     end,
      --     opts = { noremap = false, expr = true, buffer = true },
      --   },
      --   -- Toggle check-boxes.
      --   ["<leader>ch"] = {
      --     action = function()
      --       return require("obsidian").util.toggle_checkbox()
      --     end,
      --     opts = { buffer = true },
      --     desc = "Toggle checkbox",
      --   },
      --   -- Smart action depending on context, either follow link or toggle checkbox.
      --   ["<cr>"] = {
      --     action = function()
      --       return require("obsidian").util.smart_action()
      --     end,
      --     opts = { buffer = true, expr = true },
      --   },
      -- },
      -- Function to generate frontmatter for notes
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Function to generate note IDs
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

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

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        -- vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      end,

      picker = {
        name = "snacks.pick",
        -- name = "telescope.nvim",
      },
      sort_by = "modified",
      sort_reversed = true,
    })

    vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian follow_link<cr>", { desc = "follows note under cursor" })

    vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Cycle through checkbox options." })
    vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Obsidian note" })
    vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "New Obsidian note" })
    vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Obsidian notes" })
    vim.keymap.set("n", "<leader>of", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switch" })
    vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Show location list of backlinks" })
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

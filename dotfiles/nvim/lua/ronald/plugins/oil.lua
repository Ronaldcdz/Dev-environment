return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<Tab>"] = "actions.select",
      -- ["<C-l>"] = function() -- <-- Nueva keymap añadida aquí
      --   local oil = require("oil")
      --   local entry = oil.get_cursor_entry()
      --   local dir
      --
      --   -- Determinar el directorio objetivo
      --   if entry and entry.entry_type == "directory" then
      --     dir = oil.get_current_dir() .. entry.name
      --   else
      --     dir = oil.get_current_dir()
      --   end
      --
      --   require("easy-dotnet").create_new_item(dir)
      -- end,
      ["<C-h>"] = false,
      ["<C-r>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["<S-Tab>"] = "actions.parent",
    },
    use_default_keymaps = false,
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

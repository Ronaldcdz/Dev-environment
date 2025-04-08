return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = true, -- Carga solo cuando abres un archivo Dart
  ft = "dart", -- Se activa con archivos Dart
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope.nvim", -- Asegúrate de tener Telescope
  },
  config = function()
    require("flutter-tools").setup({
      widget_guides = { enabled = true },
      dev_tools = { autostart = true },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = true, -- highlight the background
          background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = true, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
        settings = {
          renameFilesWithClasses = "always",
          analysisExcludedFolders = {
            ".dart_tool",
            "/Users/ts/.pub-cache/",
            "/Users/ts/fvm/",
          },
          completeFunctionCalls = true,
          experimentalRefactors = true,
          allowOpenUri = true,
        },
      },
    })
    -- Carga la extensión de Telescope para Flutter
    require("telescope").load_extension("flutter")
    vim.api.nvim_create_user_command("Flutter", function()
      require("telescope").extensions.flutter.commands()
    end, {})
  end,
}

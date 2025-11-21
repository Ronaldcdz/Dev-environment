return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false, -- ¡IMPORTANTE! Se carga inmediatamente al inicio
    priority = 1000, -- Máxima prioridad de carga (Packer/LazyVim)
    config = function()
      -- Lógica de configuración de Rose Pine
      require("rose-pine").setup({
        variant = "dawn", -- auto, main, moon, or dawn
        dark_variant = "moon", -- Ajustado a 'moon' para una mejor visibilidad por defecto
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },
        styles = {
          transparency = true,
        },
      })

      -- 2. Establecer el Colorscheme
      -- Este comando se ejecuta inmediatamente después de la configuración del plugin
      vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    -- Default options:
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = "wave", -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      })

      -- setup must be called before loading
      -- vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
      -- custom options here
      transparent_background = true,
    },
    config = function(_, opts)
      require("tokyodark").setup(opts) -- calling setup is optional
      -- vim.cmd([[colorscheme tokyodark]])
    end,
  },
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "navarasu/onedark.nvim",
    -- priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "darker",
      })
      -- Enable theme
      -- require("onedark").load()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    -- priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    -- priority = 1000,
  },
  {
    "olimorris/onedarkpro.nvim",
    -- priority = 1000, -- Ensure it loads first
  },
}

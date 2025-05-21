return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   -- Default options:
  --   config = function()
  --     require("kanagawa").setup({
  --       compile = false, -- enable compiling the colorscheme
  --       undercurl = true, -- enable undercurls
  --       commentStyle = { italic = true },
  --       functionStyle = {},
  --       keywordStyle = { italic = true },
  --       statementStyle = { bold = true },
  --       typeStyle = {},
  --       transparent = false, -- do not set background color
  --       dimInactive = false, -- dim inactive window `:h hl-NormalNC`
  --       terminalColors = true, -- define vim.g.terminal_color_{0,17}
  --       colors = { -- add/modify theme and palette colors
  --         palette = {},
  --         theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  --       },
  --       overrides = function(colors) -- add/modify highlights
  --         return {}
  --       end,
  --       theme = "wave", -- Load "wave" theme
  --       background = { -- map the value of 'background' option to a theme
  --         dark = "wave", -- try "dragon" !
  --         light = "lotus",
  --       },
  --     })
  --
  --     -- setup must be called before loading
  --     vim.cmd("colorscheme kanagawa")
  --   end,
  -- },
  -- {
  --   "tiagovla/tokyodark.nvim",
  --   opts = {
  --     -- custom options here
  --   },
  --   config = function(_, opts)
  --     require("tokyodark").setup(opts) -- calling setup is optional
  --     vim.cmd([[colorscheme tokyodark]])
  --   end,
  -- },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "auto", -- auto, main, moon, or dawn
        dark_variant = "dawn", -- main, moon, or dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },

        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },

        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",

          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",

          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",

          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },

        palette = {
          -- Override the builtin palette per variant
          -- moon = {
          --     base = '#18191a',
          --     overlay = '#363738',
          -- },
        },

        MatchParen = { fg = "#f6c177", bg = "none", bold = true, inherit = false },
        -- CursorLine = { fg = "gold", bg = "none", bold = true, inherit = false },
        -- highlight_groups = {
        --   -- Comment = { fg = "foam" },
        --   -- VertSplit = { fg = "muted", bg = "muted" },
        --   ["@keyword.operator"] = { fg = "love" },
        --   ["@punctuation.bracket"] = { fg = "gold" },
        --   CursorLineNr = { fg = "gold" },
        -- },

        before_highlight = function(group, highlight, palette)
          -- Disable all undercurls
          -- if highlight.undercurl then
          --     highlight.undercurl = false
          -- end
          --
          -- Change palette colour
          -- if highlight.fg == palette.pine then
          --     highlight.fg = palette.foam
          -- end
        end,
      })

      vim.cmd("colorscheme rose-pine")
      -- vim.cmd("colorscheme rose-pine-main")
      -- vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine-dawn")up({
      --   disable_background = true,
      -- })
      --
      -- function ColorMyPencils(color)
      --   color = color or "rose-pine"
      --   vim.cmd.colorscheme(color)
      --
      --   vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      --   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      -- end
      --
      -- ColorMyPencils()
      -- -- vim.cmd.colorscheme("rose-pine")
    end,
  },
}

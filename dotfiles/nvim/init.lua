vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.fn.has("win32") == 1 then
  vim.env.CC = "gcc"
end

-- lua/plugins/init.lua

-- ============================================
--  1. Lista única de plugins
--     name  → nombre exacto del repositorio (usado en packadd)
--     src   → URL de GitHub
--     version → rama, tag, o commit (opcional, si no se pone usa la rama por defecto)
-- ============================================
local plugins = {
  -- Temas
  { name = "plenary.nvim",       src = "https://github.com/nvim-lua/plenary.nvim" },
  { name = "neovim",             src = "https://github.com/rose-pine/neovim" },
  { name = "kanagawa.nvim",      src = "https://github.com/rebelot/kanagawa.nvim" },
  { name = "tokyodark.nvim",     src = "https://github.com/tiagovla/tokyodark.nvim" },
  { name = "catppuccin",         src = "https://github.com/catppuccin/nvim" },
  { name = "onedark.nvim",       src = "https://github.com/navarasu/onedark.nvim" },
  { name = "tokyonight.nvim",    src = "https://github.com/folke/tokyonight.nvim" },
  { name = "cyberdream.nvim",    src = "https://github.com/scottmckendry/cyberdream.nvim" },
  { name = "onedarkpro.nvim",    src = "https://github.com/olimorris/onedarkpro.nvim" },

  -- LSP
  { name = "nvim-lspconfig",     src = "https://github.com/neovim/nvim-lspconfig" },
  { name = "mason.nvim",         src = "https://github.com/mason-org/mason.nvim" },
  { name = "mason-lspconfig.nvim", src = "https://github.com/mason-org/mason-lspconfig.nvim" },

  -- oil
  { name = "oil.nvim",           src = "https://github.com/stevearc/oil.nvim" },
  { name = "oil-git.nvim",       src = "https://github.com/malewicz1337/oil-git.nvim" },

  -- blink.cmp con versión
  {
    name = "blink.cmp",
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("^1"),
  },

  -- conform
  { name = "conform.nvim",       src = "https://github.com/stevearc/conform.nvim" },

  -- git
  { name = "gitsigns.nvim",      src = "https://github.com/lewis6991/gitsigns.nvim" },
  { name = "lazygit.nvim",       src = "https://github.com/kdheepak/lazygit.nvim" },

  -- markdown
  { name = "render-markdown.nvim", src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { name = "markdown-preview.nvim", src = "https://github.com/iamcco/markdown-preview.nvim" },

  -- snacks + devicons
  { name = "snacks.nvim",        src = "https://github.com/folke/snacks.nvim" },
  { name = "nvim-web-devicons",  src = "https://github.com/nvim-tree/nvim-web-devicons" },

  -- treesitter (con versiones explícitas)
  {
    name = "nvim-treesitter",
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
  },
  {
    name = "nvim-treesitter-textobjects",
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
  {
    name = "nvim-treesitter-context",
    src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
  },

  -- utilidades
  { name = "which-key.nvim",     src = "https://github.com/folke/which-key.nvim" },
  { name = "Comment.nvim",       src = "https://github.com/numToStr/Comment.nvim" },
  { name = "nvim-autopairs",     src = "https://github.com/windwp/nvim-autopairs" },
  { name = "LuaSnip",            src = "https://github.com/L3MON4D3/LuaSnip" },

  -- harpoon
  {
    name = "harpoon",
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },

  -- obsidian (última release)
  {
    name = "obsidian.nvim",
    src = "https://github.com/obsidian-nvim/obsidian.nvim",
    version = vim.version.range("*"),
  },

  -- smear-cursor
  { name = "smear-cursor.nvim",  src = "https://github.com/sphamba/smear-cursor.nvim" },

  -- nvim-surround (versión 4.x)
  {
    name = "nvim-surround",
    src = "https://github.com/kylechui/nvim-surround",
    version = vim.version.range("4.x"),
  },

  -- todo-comments y trouble
  { name = "todo-comments.nvim", src = "https://github.com/folke/todo-comments.nvim" },
  { name = "trouble.nvim",       src = "https://github.com/folke/trouble.nvim" },
}

-- ============================================
--  2. Instalar todos en opt/ DE UNA SOLA VEZ
-- ============================================
local all_specs = {}  -- acumulamos los specs aquí
for _, plugin in ipairs(plugins) do
  local spec = { src = plugin.src }
  if plugin.version then
    spec.version = plugin.version
  end
  table.insert(all_specs, spec)
end

-- Una sola llamada → un solo prompt de confirmación
vim.pack.add(all_specs)

-- ============================================
--  3. Cargar desde opt/
-- ============================================
local loaded_any = false
for _, plugin in ipairs(plugins) do
  local ok, err = pcall(vim.cmd, "packadd " .. plugin.name)
  if ok then
    loaded_any = true
  else
    vim.notify("Plugin no encontrado aún: " .. plugin.name, vim.log.levels.WARN)
  end
end

if not loaded_any then
  vim.notify("Parece que los plugins aún se están instalando. Reinicia Neovim cuando termine.", vim.log.levels.WARN)
end


require("config")
require("plugins")

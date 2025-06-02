-- This file contains the configuration for integrating GitHub Copilot and Copilot Chat plugins in Neovim.

-- Define prompts for Copilot
-- This table contains various prompts that can be used to interact with Copilot.
local prompts = {
  Explain = "Please explain how the following code works.", -- Prompt to explain code
  Review = "Please review the following code and provide suggestions for improvement.", -- Prompt to review code
  Tests = "Please explain how the selected code works, then generate unit tests for it.", -- Prompt to generate unit tests
  Refactor = "Please refactor the following code to improve its clarity and readability.", -- Prompt to refactor code
  FixCode = "Please fix the following code to make it work as intended.", -- Prompt to fix code
  FixError = "Please explain the error in the following text and provide a solution.", -- Prompt to fix errors
  BetterNamings = "Please provide better names for the following variables and functions.", -- Prompt to suggest better names
  Documentation = "Please provide documentation for the following code.", -- Prompt to generate documentation
  JsDocs = "Please provide JsDocs for the following code.", -- Prompt to generate JsDocs
  DocumentationForGithub = "Please provide documentation for the following code ready for GitHub using markdown.", -- Prompt to generate GitHub documentation
  CreateAPost = "Please provide documentation for the following code to post it in social media, like Linkedin, it has be deep, well explained and easy to understand. Also do it in a fun and engaging way.", -- Prompt to create a social media post
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.", -- Prompt to generate Swagger API docs
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.", -- Prompt to generate Swagger JsDocs
  Summarize = "Please summarize the following text.", -- Prompt to summarize text
  Spelling = "Please correct any grammar and spelling errors in the following text.", -- Prompt to correct spelling and grammar
  Wording = "Please improve the grammar and wording of the following text.", -- Prompt to improve wording
  Concise = "Please rewrite the following text to make it more concise.", -- Prompt to make text concise
}

-- Plugin configuration
-- This table contains the configuration for various plugins used in Neovim.
return {
  -- Copilot Chat plugin configuration
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  enabled = false,
  cmd = "CopilotChat",
  dependencies = {
    { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
    { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    { "nvim-telescope/telescope.nvim" },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "copilot-chat" },
      },
      ft = { "markdown", "copilot-chat" },
    },
    {
      "saghen/blink.cmp",
      optional = true,
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        sources = {
          providers = {
            path = {
              -- Path sources triggered by "/" interfere with CopilotChat commands
              enabled = function()
                return vim.bo.filetype ~= "copilot-chat"
              end,
            },
          },
        },
      },
    },
  },
  event = "VeryLazy",
  opts = {
    tiktoken = {
      library_path = vim.fn.expand("C:/Users/RonaldCadiz/AppData/Local/nvim/lua/ronald/plugins/tiktoken_core.so"),
    },
    prompts = prompts,
    system_prompt = "Este GPT es un clon del usuario, un arquitecto líder frontend especializado en Angular y React, con experiencia en arquitectura limpia, arquitectura hexagonal y separación de lógica en aplicaciones escalables. Tiene un enfoque técnico pero práctico, con explicaciones claras y aplicables, siempre con ejemplos útiles para desarrolladores con conocimientos intermedios y avanzados.\n\nHabla con un tono profesional pero cercano, relajado y con un toque de humor inteligente. Evita formalidades excesivas y usa un lenguaje directo, técnico cuando es necesario, pero accesible. Su estilo es argentino, sin caer en clichés, y utiliza expresiones como “buenas acá estamos” o “dale que va” según el contexto.\n\nSus principales áreas de conocimiento incluyen:\n- Desarrollo frontend con Angular, React y gestión de estado avanzada (Redux, Signals, State Managers propios como Gentleman State Manager y GPX-Store).\n- Arquitectura de software con enfoque en Clean Architecture, Hexagonal Architecure y Scream Architecture.\n- Implementación de buenas prácticas en TypeScript, testing unitario y end-to-end.\n- Loco por la modularización, atomic design y el patrón contenedor presentacional \n- Herramientas de productividad como LazyVim, Tmux, Zellij, OBS y Stream Deck.\n- Mentoría y enseñanza de conceptos avanzados de forma clara y efectiva.\n- Liderazgo de comunidades y creación de contenido en YouTube, Twitch y Discord.\n\nA la hora de explicar un concepto técnico:\n1. Explica el problema que el usuario enfrenta.\n2. Propone una solución clara y directa, con ejemplos si aplica.\n3. Menciona herramientas o recursos que pueden ayudar.\n\nSi el tema es complejo, usa analogías prácticas, especialmente relacionadas con construcción y arquitectura. Si menciona una herramienta o concepto, explica su utilidad y cómo aplicarlo sin redundancias.\n\nAdemás, tiene experiencia en charlas técnicas y generación de contenido. Puede hablar sobre la importancia de la introspección, cómo balancear liderazgo y comunidad, y cómo mantenerse actualizado en tecnología mientras se experimenta con nuevas herramientas. Su estilo de comunicación es directo, pragmático y sin rodeos, pero siempre accesible y ameno.\n\nEsta es una transcripción de uno de sus vídeos para que veas como habla:\n\nLe estaba contando la otra vez que tenía una condición Que es de adulto altamente calificado no sé si lo conocen pero no es bueno el oto lo está hablando con mi mujer y y a mí cuando yo era chico mi mamá me lo dijo en su momento que a mí me habían encontrado una condición Que ti un iq muy elevado cuando era muy chico eh pero muy elevado a nivel de que estaba 5 años o 6 años por delante de un niño",
    model = "gemini-2.5-pro",
    answer_header = "󱗞  The Gentleman 󱗞  ",
    auto_insert_mode = true,
    window = {
      layout = "horizontal",
    },
    mappings = {
      complete = {
        insert = "<Tab>",
      },
      close = {
        normal = "q",
        insert = "<C-c>",
      },
      reset = {
        normal = "<C-l>",
        insert = "<C-l>",
      },
      submit_prompt = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      toggle_sticky = {
        normal = "grr",
      },
      clear_stickies = {
        normal = "grx",
      },
      accept_diff = {
        normal = "<C-y>",
        insert = "<C-y>",
      },
      jump_to_diff = {
        normal = "gj",
      },
      quickfix_answers = {
        normal = "gqa",
      },
      quickfix_diffs = {
        normal = "gqd",
      },
      yank_diff = {
        normal = "gy",
        register = '"', -- Default register to use for yanking
      },
      show_diff = {
        normal = "gd",
        full_diff = false, -- Show full diff instead of unified diff when showing diff window
      },
      show_info = {
        normal = "gi",
      },
      show_context = {
        normal = "gc",
      },
      show_help = {
        normal = "gh",
      },
    },
    keys = {
      --- Nuevos Keymaps de CopilotChat
      ---

      -- Main chat
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat" },
      { "<leader>aA", "<cmd>CopilotChatReset<cr>", mode = "n", desc = "Reset Chat Session" },

      -- Actions on selected code (visual mode)
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain code" },
      { "<leader>ar", "<cmd>CopilotChatRefactor<cr>", mode = "v", desc = "Refactor code" },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Fix code" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "Generate tests" },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", mode = "v", desc = "Generate documentation" },

      -- File-wide actions
      { "<leader>aE", "<cmd>CopilotChatExplainFile<cr>", mode = "n", desc = "Explain entire file" },
      { "<leader>aT", "<cmd>CopilotChatTestsFile<cr>", mode = "n", desc = "Generate tests for file" },

      -- Chat layouts
      { "<leader>av", "<cmd>CopilotChatVsplit<cr>", mode = "n", desc = "Vertical split chat" },
      { "<leader>ah", "<cmd>CopilotChatSplit<cr>", mode = "n", desc = "Horizontal split chat" },
      { "<leader>ao", "<cmd>CopilotChatFloat<cr>", mode = "n", desc = "Floating chat window" }, -- 'o' for overlay

      -- Debug tools
      { "<leader>aD", "<cmd>CopilotChatDebugInfo<cr>", mode = "n", desc = "Show debug info" },
      { "<leader>ax", "<cmd>CopilotChatStop<cr>", mode = "v", desc = "Stop current action" },

      -- Prompt management
      { "<leader>ap", "<cmd>CopilotChatPrompt<cr>", mode = "n", desc = "Custom prompt" },
      { "<leader>as", "<cmd>CopilotChatSavePrompt<cr>", mode = "n", desc = "Save current prompt" }, -- 's' for save

      -- Token management
      { "<leader>ak", "<cmd>CopilotChatTokens<cr>", mode = "n", desc = "Show token count" }, -- 'k' for tokens
    },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    chat.setup(opts)

    local select = require("CopilotChat.select")

    vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
      chat.ask(args.args, { selection = select.visual })
    end, { nargs = "*", range = true })

    vim.api.nvim_create_user_command("CopilotChatInline", function(args)
      chat.ask(args.args, {
        selection = select.visual,
        window = {
          layout = "float",
          relative = "cursor",
          width = 1,
          height = 0.4,
          row = 1,
        },
      })
    end, { nargs = "*", range = true })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-*",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = false
        vim.bo.filetype = "markdown" -- ¡Esencial para renderizado!
      end,
    })

    -- -- Main chat
    -- vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CopilotChatToggle<cr>", { desc = "Toggle AI Chat" })
    -- vim.keymap.set("n", "<leader>aA", "<cmd>CopilotChatReset<cr>", { desc = "Reset Chat Session" })
    --
    -- -- Actions on selected code (visual mode)
    -- vim.keymap.set("v", "<leader>ae", "<cmd>CopilotChatExplain<cr>", { desc = "Explain code" })
    -- vim.keymap.set("v", "<leader>ar", "<cmd>CopilotChatRefactor<cr>", { desc = "Refactor code" })
    -- vim.keymap.set("v", "<leader>af", "<cmd>CopilotChatFix<cr>", { desc = "Fix code" })
    -- vim.keymap.set("v", "<leader>at", "<cmd>CopilotChatTests<cr>", { desc = "Generate tests" })
    -- vim.keymap.set("v", "<leader>ad", "<cmd>CopilotChatDocs<cr>", { desc = "Generate documentation" })
    --
    -- -- File-wide actions
    -- vim.keymap.set("n", "<leader>aE", "<cmd>CopilotChatExplainFile<cr>", { desc = "Explain entire file" })
    -- vim.keymap.set("n", "<leader>aT", "<cmd>CopilotChatTestsFile<cr>", { desc = "Generate tests for file" })
    --
    -- -- Chat layouts
    -- vim.keymap.set("n", "<leader>av", "<cmd>CopilotChatVsplit<cr>", { desc = "Vertical split chat" })
    -- vim.keymap.set("n", "<leader>ah", "<cmd>CopilotChatSplit<cr>", { desc = "Horizontal split chat" })
    -- vim.keymap.set("n", "<leader>ao", "<cmd>CopilotChatFloat<cr>", { desc = "Floating chat window" }) -- 'o' for overlay
    --
    -- -- Debug tools
    -- vim.keymap.set("n", "<leader>aD", "<cmd>CopilotChatDebugInfo<cr>", { desc = "Show debug info" })
    -- vim.keymap.set("v", "<leader>ax", "<cmd>CopilotChatStop<cr>", { desc = "Stop current action" })
    --
    -- -- Prompt management
    -- vim.keymap.set("n", "<leader>ap", "<cmd>CopilotChatPrompt<cr>", { desc = "Custom prompt" })
    -- vim.keymap.set("n", "<leader>as", "<cmd>CopilotChatSavePrompt<cr>", { desc = "Save current prompt" }) -- 's' for save
    --
    -- -- Token management
    -- vim.keymap.set("n", "<leader>ak", "<cmd>CopilotChatTokens<cr>", { desc = "Show token count" }) -- 'k' for tokens

    -- Autocommand for chat buffer enhancements
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = false

        -- Chat-specific keybindings
        vim.keymap.set("i", "<C-s>", function()
          require("CopilotChat").accept()
        end, { buffer = true, desc = "Send message" })
        vim.keymap.set("n", "<C-s>", function()
          require("CopilotChat").accept()
        end, { buffer = true, desc = "Send message" })
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, desc = "Close window" })
      end,
    })
  end,
}

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
    "ravitemer/codecompanion-history.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
    },
    {
      "echasnovski/mini.diff",
      config = function()
        local diff = require("mini.diff")
        diff.setup({
          -- Disabled by default
          source = diff.gen_source.none(),
        })
      end,
    },
    {
      "HakonHarnes/img-clip.nvim",
      opts = {
        filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
      },
    },
  },

  opts = {
    extensions = {
      history = {
        enabled = true,
        opts = {
          keymap = "gh",
          save_chat_keymap = "sc",
          auto_save = false,
          auto_generate_title = true,
          continue_last_chat = false,
          delete_on_clearing_chat = false,
          picker = "snacks",
          enable_logging = false,
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        },
      },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    sources = {
      per_filetype = {
        codecompanion = { "codecompanion" },
      },
    },
    strategies = {
      chat = {
        adapter = "copilot",
        keymaps = {
          send = {
            modes = {
              i = { "<C-CR>", "<C-s>" },
            },
          },
          completion = {
            modes = {
              i = "<C-x>",
            },
          },
        },
        slash_commands = {
          ["buffer"] = {
            keymaps = {
              modes = {
                i = "<C-b>",
              },
            },
          },
          ["fetch"] = {
            keymaps = {
              modes = {
                i = "<C-f>",
              },
            },
          },
          ["help"] = {
            opts = {
              max_lines = 1000,
            },
          },
          ["image"] = {
            keymaps = {
              modes = {
                i = "<C-i>",
              },
            },
            opts = {
              dirs = { "~/Documents/Screenshots" },
            },
          },
        },
        tools = {
          opts = {
            auto_submit_success = false,
            auto_submit_errors = false,
          },
        },
      },
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "copilot",
      },
    },
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = "cmd: bw get item 'Athropic API Key' | jq -r '.notes'",
          },
        })
      end,
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "gemini-2.5-pro",
            },
          },
        })
      end,
      deepseek = function()
        return require("codecompanion.adapters").extend("deepseek", {
          env = {
            api_key = "cmd: bw get item 'Deepseek API Key' | jq -r '.notes'",
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd: bw get item 'Gemini API Key' | jq -r '.notes'",
          },
        })
      end,
      mistral = function()
        return require("codecompanion.adapters").extend("mistral", {
          env = {
            api_key = "cmd: bw get item 'Mistral API Key' | jq -r '.notes'",
          },
        })
      end,
      novita = function()
        return require("codecompanion.adapters").extend("novita", {
          env = {
            api_key = "cmd: bw get item 'Novita API Key' | jq -r '.notes'",
          },
          schema = {
            model = {
              default = function()
                return "meta-llama/llama-3.1-8b-instruct"
              end,
            },
          },
        })
      end,
      ollama = function()
        return require("codecompanion.adapters").extend("ollama", {
          schema = {
            model = {
              default = "llama3.1:latest",
            },
            num_ctx = {
              default = 20000,
            },
          },
        })
      end,
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          opts = {
            stream = true,
          },
          env = {
            api_key = "cmd: bw get item 'OpenAI API Key' | jq -r '.notes'",
          },
          schema = {
            model = {
              default = function()
                return "gpt-4.1"
              end,
            },
          },
        })
      end,
    },
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_default_actions = true, -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },
      diff = {
        provider = "mini_diff",
      },
      chat = {
        intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
        show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
        separator = "─", -- The separator between the different messages in the chat buffer
        show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
        show_settings = false, -- Show LLM settings at the top of the chat buffer?
        show_token_count = true, -- Show the token count for each response?
        start_in_insert_mode = false, -- Open the chat buffer in insert mode?
      },
    },
    prompt_library = {},

    system_prompt = function(opts)
      return [[
Eres un asistente de programación de IA llamado "CodeCompanion". Actualmente estás conectado al editor de texto Neovim en la máquina de un usuario.

Tus tareas principales incluyen:
- Responder preguntas generales de programación.
- Explicar cómo funciona el código en un buffer de Neovim.
- Revisar el código seleccionado en un buffer de Neovim.
- Generar pruebas unitarias para el código seleccionado.
- Proponer soluciones para problemas en el código seleccionado.
- Generar código base para un nuevo espacio de trabajo (scaffolding).
- Encontrar código relevante para la consulta del usuario.
- Proponer soluciones para fallos en las pruebas.
- Responder preguntas sobre Neovim.
- Optimizar código.
- Refactorizar código.
- Explicar errores y excepciones.
- Asistir con la configuración del entorno.
- Ejecutar herramientas.

Debes:
- Seguir los requisitos del usuario cuidadosa y literalmente.
- Mantener tus respuestas concisas, pero con un tono amigable para ahorrar tokens.
- Minimizar otra prosa.
- Usar formato Markdown en tus respuestas.
- Incluir el nombre del lenguaje de programación al inicio de los bloques de código Markdown.
- Evitar incluir números de línea en los bloques de código.
- Evitar envolver toda la respuesta en tres comillas invertidas.
- Devolver solo el código que sea relevante para la tarea en cuestión. Puede que no necesites devolver todo el código que el usuario ha compartido.
- Usar saltos de línea reales en lugar de '\n' en tu respuesta para iniciar nuevas líneas.
- Usar '\n' solo cuando quieras una barra invertida literal seguida del carácter 'n'.
- Todas las respuestas que no sean código deben estar en español.

Cuando se te asigne una tarea:
1. Piensa paso a paso y describe tu plan para lo que vas a construir en pseudocódigo, escrito con gran detalle, a menos que se te pida no hacerlo.
2. Genera el código en un único bloque de código, asegurándote de devolver solo el código relevante.
3. Siempre debes generar sugerencias cortas para las siguientes interacciones del usuario que sean relevantes para la conversación.
4. Solo puedes dar una respuesta por cada turno de conversación.
      ]]
    end,
  },
  config = function()
    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set(
      { "n", "v" },
      "<LocalLeader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      { noremap = true, silent = true }
    )
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
  end,
}

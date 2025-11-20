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
  init = function()
    -- vim.cmd([[cab cc CodeCompanion]])
    -- require("plugins.code-companion-notifier"):init()
    -- require("../../../utils/code-companion-notifier"):init()

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionInlineFinished",
      group = group,
      callback = function(request)
        vim.lsp.buf.format({ bufnr = request.buf })
      end,
    })
  end,
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Toggle [C]hat" },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI [N]ew Chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI [A]ction" },
    { "ga", "<cmd>CodeCompanionChat Add<CR>", mode = { "v" }, desc = "AI [A]dd to Chat" },
    -- prompts
    { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = { "v" }, desc = "AI [E]xplain" },
    { "<leader>an", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "AI [N]ew Chat" },
    { "ga", "<cmd>CodeCompanionChat Add<CR>", mode = { "v" }, desc = "AI [A]dd to Chat" },
    -- prompts
    { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = { "v" }, desc = "AI [E]xplain" },
  },
  config = true,
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
      adapter = "copilot",
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "copilot",
      },
    },
    adapters = {
      http = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd: bw get item 'Athropic API Key' | jq -r '.notes'",
            },
          })
        end,
        -- copilot = function()
        --   return require("codecompanion.adapters").extend("copilot", {
        --     schema = {
        --       model = {
        --         default = "deepseek",
        --       },
        --     },
        --     env = {
        --       api_key = "cmd: bw get item 'COPILOT API Key' | jq -r '.notes'",
        --     },
        --   })
        -- end,
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
        show_settings = true, -- Show LLM settings at the top of the chat buffer?
        show_token_count = true, -- Show the token count for each response?
        start_in_insert_mode = true, -- Open the chat buffer in insert mode?
      },
    },
    prompt_library = {
      ["Arreglar Bloque de Código"] = {
        strategy = "chat",
        description = "Analiza el bloque de código seleccionado, corrige errores sintácticos o lógicos, y sugiere refactorizaciones.",
        prompts = {
          {
            role = "system",
            content = [[
                    Eres un Arquitecto de Software y Debugger de clase mundial.
                    
                    Cuando se te pida arreglar código, sigue estos pasos:

                    1. **Identifica los Problemas**: Lee cuidadosamente el código proporcionado e identifica cualquier problema o mejora potencial.
                    2. **Planifica la Corrección**: Describe el plan para arreglar el código en pseudocódigo, detallando cada paso.
                    3. **Implementa la Corrección**: Escribe el código corregido en un único bloque de código.
                    4. **Explica la Corrección**: Explica brevemente qué cambios se hicieron y por qué.

                    Asegúrate de que el código corregido:

                    - Incluya las importaciones necesarias.
                    - Maneje posibles errores.
                    - Siga las mejores prácticas de legibilidad y mantenibilidad.
                    - Esté formateado correctamente.

                    Utiliza formato Markdown e incluye el nombre del lenguaje de programación al inicio del bloque de código.
                ]],
          },
          {
            role = "user",
            content = "Arregla el siguiente código:",
          },
        },
      },
      ["Crear mensaje de commit"] = {
        strategy = "chat",
        description = "Genera un mensaje de commit (siguiendo Conventional Commits) basado en los archivos en stage.",
        prompts = {
          {
            role = "system",
            content = [[
                    Eres un experto en la especificación de Conventional Commits.
                    Tu objetivo es generar un único y conciso mensaje de commit a partir de un 'git diff' proporcionado.

                    Formato de salida obligatorio:
                    1. Debe seguir el formato 'type(scope): subject' (ej: feat(config): añadir autocomandos para temas).
                    2. Si es necesario, incluye un cuerpo explicando el cambio.
                    3. Si el cambio es BREAKING, debe incluir 'BREAKING CHANGE: <descripcion>' en el cuerpo.
                    4. El resultado DEBE ser solo el mensaje de commit, sin explicaciones ni bloques de código Markdown.
                ]],
          },
          {
            role = "user",
            content = function()
              -- Ejecuta 'git diff --staged' para obtener los cambios listos para commit
              local diff = vim.system({ "git", "diff", "--no-ext-diff", "--staged" }, { text = true }):wait()

              if diff.code ~= 0 then
                -- En caso de error (ej: no es un repositorio git)
                return "Error al obtener el 'git diff --staged'. Código de salida: " .. diff.code
              end

              if #diff.stdout == 0 then
                -- No hay archivos añadidos al stage
                return "No hay cambios en stage ('git diff --staged' está vacío). Por favor, realiza 'git add' primero para agregar archivos."
              end

              -- Devuelve el prompt para la IA con el diff inyectado
              return string.format(
                [[Basado en el siguiente 'git diff --staged', por favor, genera el mensaje de commit usando el formato Conventional Commit.
                        
````diff
%s
````
]],
                diff.stdout
              )
            end,
            opts = {
              contains_code = true,
            },
          },
        },
      },
    },

    system_prompt = function(opts)
      return [[

Eres CodeCompanion, asistente experto en programación conectado a Neovim. Tu misión es ser conciso, preciso y útil, priorizando la respuesta directa y el ahorro de tokens.

Tareas:

    Código/Debugging: Explicar, revisar, proponer soluciones, optimizar, refactorizar, generar tests, explicar errores.
    Desarrollo: Generar scaffolding o código relevante.
    General: Responder preguntas de programación, asistir con configuración y Neovim.

Reglas de Output:

    Idioma: Español (excepto código).
    Tono: Amigable, pero estrictamente conciso. Cero prosa o preámbulos.
    Formato: Usar Markdown.
        Código: Incluir siempre el nombre del lenguaje (```lenguaje).
        No usar números de línea. Devolver solo el código relevante.
        Usar saltos de línea reales. Usar \n solo para la cadena literal ‘\n’.

Proceso Estándar:

    [OUTPUT] Generar la respuesta (código/explicación) directamente.
    [SIGUIENTE] Finalizar con una sugerencia corta y relevante para la siguiente interacción.
    Respuesta Única: Un solo turno de conversación.

      ]]
    end,
  },
}

-- AI, wired to the opencode go API key (OPENCODE_GO_API_KEY in ~/.hermes/.env).
--
-- minuet  -> inline ghost-text completions while typing
-- codecompanion -> chat, inline edits, prompt library, and the opencode CLI agent
local MODEL = "deepseek-v4.1-flash"

-- The key lives in ~/.hermes/.env, which is not sourced by every shell.
-- Prefer the environment, fall back to reading that file directly so Neovim
-- works the same whether it was started from a shell, a launcher or a GUI.
local function go_key()
  local key = os.getenv("OPENCODE_GO_API_KEY")
  if key and key ~= "" then
    return key
  end
  local f = io.open(vim.fn.expand("~/.hermes/.env"), "r")
  if not f then
    return ""
  end
  for line in f:lines() do
    local value = line:match("^OPENCODE_GO_API_KEY=(.+)$")
    if value then
      f:close()
      return (value:gsub("^[\"']", ""):gsub("[\"']%s*$", ""))
    end
  end
  f:close()
  return ""
end

-- OpenCode Go routes on the x-opencode-session header and rejects requests
-- without it (HTTP 400 MissingSessionID). One stable value per editor run keeps
-- a session pinned to one backend, so its prompt cache stays warm.
local SESSION_ID = "nvim-" .. vim.fn.sha256(tostring(vim.uv.hrtime()) .. vim.fn.getpid()):sub(1, 16)

local MODELS = {
  "deepseek-v4.1-flash", -- default: fastest/cheapest, good enough for most turns
  "deepseek-v4-pro", -- deep reasoning, slower
  "glm-5.3",
  "claude-haiku-5-5",
  "gemini-4-argon",
  "gpt-5.6-luna",
  "gpt-6-luna",
  "kimi-k3",
  "kimi-k2.7-code",
  "qwen4-max",
}

local function opencode_adapter()
  return require("codecompanion.adapters").extend("openai_compatible", {
    formatted_name = "opencode go",
    env = {
      -- no /v1 here: the adapter appends /v1/chat/completions itself
      url = "https://opencode.ai/zen/go",
      api_key = go_key,
    },
    headers = {
      ["x-opencode-session"] = SESSION_ID,
    },
    schema = {
      model = {
        default = MODEL,
        choices = MODELS,
      },
    },
  })
end

return {
  -- ~ Inline completions ~
  {
    "milanglacier/minuet-ai.nvim",
    event = { "InsertEnter" },
    cmd = { "Minuet" },
    keys = {
      { "<leader>aT", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle inline completions" },
    },
    config = function()
      require("minuet").setup({
        provider = "openai_compatible",
        request_timeout = 3,
        throttle = 1200, -- at most one request per 1.2s
        debounce = 350,
        n_completions = 1,
        context_window = 16000,
        notify = "warn",
        provider_options = {
          openai_compatible = {
            api_key = go_key,
            end_point = "https://opencode.ai/zen/go/v1/chat/completions",
            model = MODEL,
            name = "opencode-go",
            transform = {
              function(data)
                data.headers["x-opencode-session"] = SESSION_ID
                return data
              end,
            },
            optional = {
              max_tokens = 160,
              top_p = 0.9,
              -- the go endpoint understands this and skips the thinking phase,
              -- which is what makes the ghost text feel instant
              thinking = { type = "disabled" },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = {
            "lua",
            "python",
            "rust",
            "typescript",
            "typescriptreact",
            "javascript",
            "javascriptreact",
            "bash",
            "sh",
            "gdscript",
            "c",
            "cpp",
            "css",
            "html",
            "json",
            "yaml",
            "toml",
            "sql",
            "markdown",
          },
          -- never ask for completions in buffers where they are noise
          auto_trigger_ignore_ft = {
            "gitcommit",
            "gitrebase",
            "help",
            "lazy",
            "mason",
            "checkhealth",
            "neo-tree",
            "snacks_picker_input",
            "TelescopePrompt",
            "text",
          },
          keymap = {
            accept = "<a-l>", -- accept the whole suggestion
            accept_line = "<a-h>", -- accept a single line, keep going
            accept_n_lines = "<a-k>", -- accept N lines
            prev = "<a-[>",
            next = "<a-]>",
            dismiss = "<a-e>",
          },
          show_on_completion_menu = false,
        },
      })
    end,
  },

  -- ~ Chat, inline edits and review ~
  {
    "olimorris/codecompanion.nvim",
    version = "^20",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
      "CodeCompanionCLI",
      "CodeCompanionCodeReview",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Actions palette" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle chat" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "New chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline edit" },
      { "<leader>a.", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to chat" },
      { "<leader>ar", "<cmd>CodeCompanionCodeReview<cr>", desc = "Review working tree" },
      { "<leader>aR", "<cmd>CodeCompanionCodeReview Branch<cr>", desc = "Review branch" },
      { "<leader>aC", "<cmd>CodeCompanionCLI agent=opencode<cr>", desc = "opencode CLI agent" },
    },
    opts = {
      adapters = {
        http = {
          opencode_go = opencode_adapter,
        },
      },
      interactions = {
        chat = {
          adapter = { name = "opencode_go", model = MODEL },
          tools = {
            opts = {
              default_tools = { "grep_search", "read_file", "edit_file", "run_command" },
              max_output_tokens = 30000,
            },
            ["run_command"] = {
              opts = {
                -- still ask before anything that is not obviously read-only
                require_cmd_approval = true,
                safe_commands = {
                  "git status",
                  "git diff",
                  "git log",
                  "ls",
                  "cat",
                  "rg",
                  "fd",
                  "pwd",
                },
              },
            },
          },
        },
        inline = { adapter = { name = "opencode_go", model = MODEL } },
        cmd = { adapter = { name = "opencode_go", model = MODEL } },
        background = { adapter = { name = "opencode_go", model = MODEL } },
        cli = {
          agent = "opencode",
          agents = {
            opencode = {
              cmd = "opencode",
              args = {},
              description = "OpenCode CLI (opencode go)",
            },
          },
        },
      },
      prompt_library = {
        markdown = {
          dirs = { "~/.config/nvim/prompts" },
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.4,
            opts = { list = false },
          },
        },
      },
      opts = {
        log_level = "ERROR",
        language = "English",
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}

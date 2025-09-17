return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    },
    config = function()
      print("Telescope config loaded")
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.DS_Store",
            "%.pyc",
            "__pycache__/",
            "%.o",
            "%.so",
            "%.a",
            "build/",
            "dist/",
            "target/",
          },
          hidden = true, -- Show hidden files by default
        },
        pickers = {
          find_files = { 
            theme = "ivy",
            hidden = true, -- Show hidden files in find_files
            no_ignore = false, -- Respect .gitignore but show hidden files
            follow = true, -- Follow symlinks
          },
          live_grep = {
            theme = "ivy",
            additional_args = function() 
              return { 
                "--case-sensitive",
                "--hidden", -- Search in hidden files
                "--glob", "!.git/*", -- Exclude .git directory
              } 
            end
          },
          grep_string = {
            theme = "ivy",
            additional_args = function() 
              return { 
                "--hidden", -- Search in hidden files
                "--glob", "!.git/*", -- Exclude .git directory
              } 
            end
          },
          oldfiles = {
            theme = "ivy",
            include_current_session = true,
          },
          buffers = {
            theme = "ivy",
            show_all_buffers = true,
            sort_mru = true,
          },
        }
      }
      -- vim.keymap.set("n", "<space>tlg", require('telescope.builtin').live_grep(require('telescope.themes').get_ivy))
      local opts = require('telescope.themes').get_ivy({})
      require('telescope.builtin').live_grep(opts)
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = true,
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            accept_word = "<C-Right>",
            accept_line = "<C-l>",
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<C-e>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
          c = true,
          cpp = true,
          lua = true,
          python = true,
          javascript = true,
          typescript = true,
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
    },
    config = function()
      local chat = require("CopilotChat")
      chat.setup({
        debug = false,
        show_help = true,
        question_header = "## User ",
        answer_header = "## Copilot ",
        error_header = "## Error ",
        separator = " ", -- Separator to use in chat
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
          },
          Review = {
            prompt = "/COPILOT_REVIEW Review the selected code.",
          },
          Fix = {
            prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
          },
          Optimize = {
            prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
          },
          Docs = {
            prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
          },
          Tests = {
            prompt = "/COPILOT_GENERATE Please generate tests for my code.",
          },
        },
        auto_follow_cursor = true, -- Don't follow the cursor after getting response
        show_folds = true, -- Shows folds for sections in chat
        chat_autocomplete = true, -- Enable chat autocompletion
        mappings = {
          complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
          },
          close = {
            normal = "q",
            insert = "<C-c>"
          },
          escape = {
            normal = "<Esc>",
            insert = "<Esc>"
          },
          reset = {
            normal = "<C-r>",
            insert = "<C-r>"
          },
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-s>"
          },
          accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>"
          },
          yank_diff = {
            normal = "gy",
            register = '"',
          },
          show_diff = {
            normal = "gd"
          },
          show_system_prompt = {
            normal = "gp"
          },
          show_user_selection = {
            normal = "gs"
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript"
      },
    },
  },
}

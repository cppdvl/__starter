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
            "%.DS_Store",
            "%.pyc",
            "__pycache__/",
            "%.o",
            "%.so",
            "%.a",
          },
          hidden = true, -- Show hidden files by default
        },
        pickers = {
          find_files = { 
            theme = "ivy",
            hidden = true, -- Show hidden files in find_files
            no_ignore = true, -- Also list files ignored by .gitignore
            follow = true, -- Follow symlinks
          },
          live_grep = {
            theme = "ivy",
            additional_args = function() 
              return { 
                "--case-sensitive",
                "--hidden", -- Search in hidden files
                "--no-ignore", -- Search in .gitignore'd files too
                "--glob", "!.git/*", -- Exclude .git directory
              } 
            end
          },
          grep_string = {
            theme = "ivy",
            additional_args = function() 
              return { 
                "--hidden", -- Search in hidden files
                "--no-ignore", -- Search in .gitignore'd files too
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
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript",
        "go", "gomod", "gosum", "gowork",
        "c", "cpp", "python", "typescript", "tsx"
      },
    },
  },
  {
    "codex.nvim",
    dir = "~/.local/share/nvim/lazy/codex.nvim",
    event = "VeryLazy",
    config = function()
      require("codex").setup()
    end,
  },
}

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
        pickers = {
          find_files = { theme = "ivy" },
          live_grep = {
            theme = "ivy",
            additional_args = function() return { "--case-sensitive"} end
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
    enabled = false,
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        enabled = not vim.g.ai_cmp,
        auto_trigger = true,
        hide_during_completion = vim.g.ai_cmp,
        keymap = {
          accept = "<M-\\>",
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      vim.g.codeium.enable = true
      require("codeium").setup({
      })
    end
  },
  -- {
  --  "nvim-treesitter/nvim-treesitter",
  --  opts = {
  --    ensure_installed = {
  --      "vim", "lua", "vimdoc",
  --      "html", "css", "javascript"
  --    },
  --  },
  --},
}

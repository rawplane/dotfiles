return {
  -- Formatting with conform.nvim
  {
    "stevearc/conform.nvim",
    -- Uncomment for format on save
    -- event = 'BufWritePre',
    opts = require "configs.conform",
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Tmux Navigation
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right" },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate Previous" },
    },
  },

  -- LazyGit Integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
  },

  -- Optional Treesitter Configuration (Commented Out)
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = {
  --     ensure_installed = {
  --       "vim", "lua", "vimdoc",
  --       "html", "css"
  --     },
  --   },
  -- },
}

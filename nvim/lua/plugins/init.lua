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

  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Firefox Debug Adapter
      dap.adapters.firefox = {
        type = "executable",
        command = "node",
        args = {
          os.getenv("HOME") .. "/.local/share/nvim/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js",
        },
      }

      -- Configurations for JavaScript and TypeScript
      dap.configurations.javascript = {
        {
          name = "Launch Firefox and Debug Current File",
          type = "firefox",
          request = "launch",
          reAttach = true,
          url = "http://localhost:3000", -- Change to your dev server URL
          webRoot = "${workspaceFolder}",
          firefoxExecutable = "/usr/bin/firefox", -- Adjust this path if needed
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
    end,
  },  

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()

      -- Automatically open/close UI on DAP events
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue Debugging" },
      { "<leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
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

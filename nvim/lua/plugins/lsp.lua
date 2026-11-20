return {
  -- Java extra from LazyVim (rekomendasi standar LazyVim untuk nvim-jdtls, dap, lint, dll)
  { import = "lazyvim.plugins.extras.lang.java" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {},
        cssls = {},
        emmet_language_server = {},
      },
    },
  },
}

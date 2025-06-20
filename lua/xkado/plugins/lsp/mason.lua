return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- -- list of servers for mason to install
      ensure_installed = {
        "lua_ls",
        "tailwind-css-language-server",
        "cpptools",
        "clangd",
        "jdtls",
        "java-language-server",
        "emmet-ls"
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",
        "isort",
        "black",
        "eslint_d",
        "pylint",
        "luaformatter"

      },
    })
  end,
}

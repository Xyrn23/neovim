---@diagnostic disable: deprecated
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
    "williamboman/mason.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    -- Configure LSP keybindings
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Keybindings for LSP functionality
        local mappings = {
          { "n",          "gR",         "<cmd>Telescope lsp_references<CR>",       "Show LSP references" },
          { "n",          "gD",         vim.lsp.buf.declaration,                   "Go to declaration" },
          { "n",          "gd",         "<cmd>Telescope lsp_definitions<CR>",      "Show LSP definitions" },
          { "n",          "gi",         "<cmd>Telescope lsp_implementations<CR>",  "Show LSP implementations" },
          { "n",          "gt",         "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
          { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,                   "See available code actions" },
          { "n",          "<leader>rn", vim.lsp.buf.rename,                        "Smart rename" },
          { "n",          "<leader>D",  "<cmd>Telescope diagnostics bufnr=0<CR>",  "Show buffer diagnostics" },
          { "n",          "<leader>d",  vim.diagnostic.open_float,                 "Show line diagnostics" },
          { "n",          "[d",         vim.diagnostic.goto_prev,                  "Go to previous diagnostic" },
          { "n",          "]d",         vim.diagnostic.goto_next,                  "Go to next diagnostic" },
          { "n",          "K",          vim.lsp.buf.hover,                         "Show documentation for what is under cursor" },
          { "n",          "<leader>rs", ":LspRestart<CR>",                         "Restart LSP" },
        }

        for _, mapping in ipairs(mappings) do
          opts.desc = mapping[4]
          keymap.set(mapping[1], mapping[2], mapping[3], opts)
        end
      end,
    })

    -- Enable autocompletion for LSP
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local util = require("lspconfig.util")
    -- Set custom diagnostic symbols
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Configure LSP servers
    mason_lspconfig.setup_handlers({
      function(server_name)
        if server_name == "jdtls" or server_name == "java_language_server" then
          return
        end
        lspconfig[server_name].setup({ capabilities = capabilities })
      end,

      -- Custom server configurations
      ["jdtls"] = function()
        lspconfig.jdtls.setup({
          capabilities = capabilities,
          cmd = { "jdtls" },
          filetypes = { "java" },
          root_dir = function(fname)
            return util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle")(fname)
          end,
          settings = {},
          init_options = {
            bundles = {},
          },
        })
      end,

      ["java_language_server"] = function()
        lspconfig.java_language_server.setup({
          capabilities = capabilities,
          cmd = { "java-language-server" },
          filetypes = { "java" },
          root_dir = util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
          settings = {},
        })
      end,

      ["emmet_ls"] = function()
        lspconfig.emmet_ls.setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,

      ["tailwindcss"] = function()
        lspconfig.tailwindcss.setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact" },
        })
      end,

      ["clangd"] = function()
        lspconfig.clangd.setup({
          capabilities = capabilities,
          filetypes = { "cpp", "c" },
        })
      end,

      ["cpptools"] = function()
        lspconfig.cpptools.setup({
          capabilities = capabilities,
          filetypes = { "cpp", "c" },
        })
      end,

      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end,
    })
  end,
}

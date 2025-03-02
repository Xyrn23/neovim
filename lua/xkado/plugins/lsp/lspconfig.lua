return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    "williamboman/mason.nvim",
  },
  opts = {
    servers = {
      tailwindcss = {
        filetypes_exclude = { "markdown" },
      },
    },
    setup = {
      tailwindcss = function(_, opts)
        local tw = require("lspconfig.server_configurations.tailwindcss")
        opts.filetypes = opts.filetypes or {}

        -- Extend default filetypes
        vim.list_extend(opts.filetypes, tw.default_config.filetypes)

        -- Filter out excluded filetypes
        opts.filetypes = vim.tbl_filter(function(ft)
          return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
        end, opts.filetypes)

        -- Add include filetypes
        vim.list_extend(opts.filetypes, opts.filetypes_include or {})

        -- Configure TailwindCSS settings
        opts.settings = {
          tailwindCSS = {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
          },
        }
      end,
    },
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
          { "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
          { "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
          { "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
          { "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
          { "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
          { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
          { "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
          { "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
          { "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
          { "n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic" },
          { "n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic" },
          { "n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor" },
          { "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
        }

        for _, mapping in ipairs(mappings) do
          opts.desc = mapping[4]
          keymap.set(mapping[1], mapping[2], mapping[3], opts)
        end
      end,
    })

    -- Enable autocompletion for LSP
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Set custom diagnostic symbols
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Configure LSP servers
    mason_lspconfig.setup_handlers({
      -- Default handler for installed servers
      function(server_name)
        lspconfig[server_name].setup({ capabilities = capabilities })
      end,

      -- Custom server configurations
      ["svelte"] = function()
        lspconfig.svelte.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
              end,
            })
          end,
        })
      end,

      ["graphql"] = function()
        lspconfig.graphql.setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
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

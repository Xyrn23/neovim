return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
        require("flutter-tools").setup {
            widget_guides = {
                enabled = true,
            },
            closing_tags = {
                enabled = false, -- set to true if you want closing tags
            },
        }
    end,
}


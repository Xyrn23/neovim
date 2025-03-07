return {
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true,          -- #RGB hex codes
                RRGGBB = true,       -- #RRGGBB hex codes
                names = true,        -- "Name" codes like Blue or blue
                RRGGBBAA = true,     -- #RRGGBBAA hex codes
                AARRGGBB = true,     -- 0xAARRGGBB hex codes
                rgb_fn = true,       -- CSS rgb() and rgba() functions
                hsl_fn = true,       -- CSS hsl() and hsla() functions
                css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                method = "both",
                -- Available methods are false / true / "normal" / "lsp" / "both"
                tailwind = true, -- Enable tailwind colors
                sass = { enable = false, parsers = { "css" }, },
                virtualtext = "■",
                always_update = false
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        }
    }
  }


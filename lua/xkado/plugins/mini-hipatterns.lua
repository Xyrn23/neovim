
return {
  'echasnovski/mini.hipatterns',
  config = function()
    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
      highlighters = {
        -- Highlight 'Color.fromARGB(255, 66, 165, 245);'
        argb_color = {
          pattern = 'Color%.fromARGB%(%d+,%s*%d+,%s*%d+,%s*%d+%);',
          group = function(_, match)
            local _, r, g, b = match:match('Color%.fromARGB%(%d+,%s*(%d+),%s*(%d+),%s*(%d+)%);')
            local hex = string.format('#%02x%02x%02x', tonumber(r), tonumber(g), tonumber(b))
            return hipatterns.compute_hex_color_group(hex, 'bg')
          end,
        },

        -- Highlight 'Color.fromRGBO(66, 165, 245, 1.0);'
        rgba_color = {
          pattern = 'Color%.fromRGBO%(%d+,%s*%d+,%s*%d+,%s*[%d%.]+%);',
          group = function(_, match)
            local r, g, b, a = match:match('Color%.fromRGBO%((%d+),%s*(%d+),%s*(%d+),%s*([%d%.]+)%);')
            local alpha = tonumber(a)
            if alpha == 0 then
              return nil -- Fully transparent; no highlight
            end
            local hex = string.format('#%02x%02x%02x', tonumber(r), tonumber(g), tonumber(b))
            return hipatterns.compute_hex_color_group(hex, 'bg')
          end,
        },
      },
    })
  end
}


return {
  'echasnovski/mini.hipatterns',
  config = function()
    local hipatterns = require('mini.hipatterns')
    hipatterns.setup({
      highlighters = {

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

        -- Highlight 'Color.fromARGB(255, 66, 165, 245);'
        argb_color = {
          pattern = 'Color%.fromARGB%(%d+,%s*%d+,%s*%d+,%s*%d+%);',
          group = function(_, match)
            local a, r, g, b = match:match('Color%.fromARGB%((%d+),%s*(%d+),%s*(%d+),%s*(%d+)%);')
            local alpha = tonumber(a) / 255.0 -- Normalize alpha to [0, 1]
            if alpha == 0 then
              return nil -- Fully transparent; no highlight
            end
            local hex = string.format('#%02x%02x%02x', tonumber(r), tonumber(g), tonumber(b))
            return hipatterns.compute_hex_color_group(hex, 'bg')
          end,
        },

        -- Highlight 'Color.from(alpha: 1.0, red: 0.2588, green: 0.6471, blue: 0.9608);'
        named_args_color = {
          pattern = 'Color%.from%(%s*alpha:%s*[%d%.]+,%s*red:%s*[%d%.]+,%s*green:%s*[%d%.]+,%s*blue:%s*[%d%.]+%);',
          group = function(_, match)
            local a, r, g, b = match:match('Color%.from%(%s*alpha:%s*([%d%.]+),%s*red:%s*([%d%.]+),%s*green:%s*([%d%.]+),%s*blue:%s*([%d%.]+)%);')
            local alpha = tonumber(a)
            if alpha == 0 then
              return nil -- Fully transparent; no highlight
            end
            -- Convert floating-point RGB values (0-1) to integers (0-255)
            local red = math.floor(tonumber(r) * 255)
            local green = math.floor(tonumber(g) * 255)
            local blue = math.floor(tonumber(b) * 255)
            local hex = string.format('#%02x%02x%02x', red, green, blue)
            return hipatterns.compute_hex_color_group(hex, 'bg')
          end,
        },
      },
    })
  end
}

local types = require("types")

---@type cn.ConfigSchema
local default_config = {
  base_url = "https://carbon.now.sh/",
  open_cmd = "xdg-open",
  options = {
    bg = "gray",
    drop_shadow_blur = "68px",
    drop_shadow = false,
    drop_shadow_offset_y = "20px",
    font_family = "Hack",
    font_size = "18px",
    line_height = "133%",
    line_numbers = true,
    theme = types.cn.Themes.monokai,
    titlebar = "Made with carbon-now.nvim",
    watermark = false,
    width = "680",
    window_theme = types.cn.WindowThemes.sharp,
  },
}

return default_config
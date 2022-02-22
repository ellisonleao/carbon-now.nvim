describe("setup", function()
  it("can be required", function()
    require("carbon-now")
  end)

  it("setup with default configs", function()
    local carbon = require("carbon-now")
    local defaults = {
      base_url = "https://carbon.now.sh/",
      open_cmd = "xdg-open",
      options = {
        theme = "monokai",
        window_theme = "none",
        font_family = "Hack",
        font_size = "18px",
        bg = "gray",
        line_numbers = true,
        line_height = "133%",
        drop_shadow = false,
        drop_shadow_offset_y = "20px",
        drop_shadow_blur = "68px",
        width = "680",
        watermark = false,
      },
    }
    carbon.setup()
    assert(carbon.config, defaults)
  end)

  it("setup with custom configs", function()
    local carbon = require("carbon-now")
    local expected = {
      base_url = "https://carbon.now.sh/",
      open_cmd = "xdg-open",
      options = {
        theme = "nord",
        window_theme = "none",
        font_family = "Hack",
        font_size = "18px",
        bg = "gray",
        line_numbers = true,
        line_height = "133%",
        drop_shadow = false,
        drop_shadow_offset_y = "20px",
        drop_shadow_blur = "68px",
        width = "680",
        watermark = false,
      },
    }
    carbon.setup({ options = { theme = "nord" } })
    assert(carbon.config, expected)
  end)
end)

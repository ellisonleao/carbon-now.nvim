local carbon = require("carbon-now")
local default_config = carbon.config

describe("setup", function()
  it("can be required", function()
    require("carbon-now")
  end)

  it("setup with default configs", function()
    carbon.setup()
    assert(default_config, carbon.config)
  end)

  it("setup with custom configs", function()
    carbon.setup({ options = { theme = "nord" } })
    assert("nord", carbon.config.theme)
  end)
end)

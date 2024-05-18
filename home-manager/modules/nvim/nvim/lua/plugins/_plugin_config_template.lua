local plugins = require'globals'.plugins

table.insert(plugins, {
  name = '',
  setup = function()
  end,
  config = function()
  end,
})

local p = require 'utils'.p

local M = function(use)
  use {
    p '',
  }
end
return M

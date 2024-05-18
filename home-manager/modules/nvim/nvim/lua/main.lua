-- import all the ft config scripts
local utils = require("utils")

local ft_prefix = "ft/ftconfigs/"

local function requireDir(prefix)
	for _, s in pairs(utils.getPluginScripts(prefix)) do
		require(prefix .. s)
	end
end

require("plugins")

requireDir(ft_prefix)

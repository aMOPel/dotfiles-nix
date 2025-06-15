utils = {}

utils.addTable = function(table1, table2)
	for k, v in pairs(table2) do
		if type(k) == "number" then
			table.insert(table1, v)
		else
			table1[k] = v
		end
	end
end

utils.replaceFormatter = function(
	cmdOverride,
	formatterName,
	formatterFiletypes
)
	if type(cmdOverride) ~= "function" then
		vim.notify("cmdOverride has to be a function", vim.log.levels.ERROR)
		return
	end
	if #formatterFiletypes < 1 then
		vim.notify(
			"formatterFiletypes has to be list of strings, with len >= 1",
			vim.log.levels.ERROR
		)
		return
	end
	local formattersByFiletype =
		require("formatter.filetypes")[formatterFiletypes[1]]
	if formattersByFiletype == nil then
		vim.notify(
			"could not resolve first element of formatterFiletypes '"
				.. formatterFiletypes[1],
			vim.log.levels.ERROR
		)
		return
	end
	local formatterConfig = formattersByFiletype[formatterName]
	if formatterConfig == nil then
		vim.notify(
			"could not resolve formatterName '" .. formatterName .. "'",
			vim.log.levels.ERROR
		)
		return
	end

	local formatterConfigFunction = function()
		local formatterConfigTbl = formatterConfig()
		formatterConfigTbl.exe = cmdOverride()
		return formatterConfigTbl
	end

	local t = {}
	for _, value in ipairs(formatterFiletypes) do
		t[value] = { formatterConfigFunction }
	end
	utils.addTable(g.formatter.filetype, t)

	-- need to call the setup again since this will be called from an exrc file,
	-- which is evaluated after the main init.lua
	require("formatter").setup({
		logging = true,
		log_level = vim.log.levels.WARN,
		filetype = g.formatter.filetype,
	})
end

utils.replaceLinter = function(cmdOverride, linterName, linterFiletypes)
	if type(cmdOverride) ~= "function" then
		vim.notify("cmdOverride has to be a function", vim.log.levels.ERROR)
		return
	end
	if #linterFiletypes < 1 then
		vim.notify(
			"linterFiletypes has to be list of strings, with len >= 1",
			vim.log.levels.ERROR
		)
		return
	end
	local lint = require("lint")

	local linterConfig = lint.linters[linterName]
	if linterConfig == nil then
		vim.notify(
			"could not resolve linterName '" .. linterName .. "'",
			vim.log.levels.ERROR
		)
		return
	end

	local customLinterName = linterName .. "Custom"

	lint.linters[linterName .. "Custom"] = linterConfig
	lint.linters[linterName .. "Custom"].cmd = cmdOverride()

	local t = {}
	for _, value in ipairs(linterFiletypes) do
		t[value] = { customLinterName }
	end

	utils.addTable(g.linter.filetype, t)
end

utils.useLocalNodeModulesBiome = function()
	local binaryName = "biome"
	local formatterName = "biome"
	local linterName = "biomejs"
	local filetypes = {
		"typescript",
		"ts",
		"tsx",
		"typescriptreact",
		"javascript",
		"jsx",
		"javascriptreact",
		"css",
		"json",
		"jsonc",
	}
	local function cmdOverride()
		local rootDir = vim.fs.root(0, "node_modules")
		return rootDir .. "/node_modules/.bin/" .. binaryName
	end

	utils.replaceLinter(cmdOverride, linterName, filetypes)
	utils.replaceFormatter(cmdOverride, formatterName, filetypes)
end

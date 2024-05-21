utils = {}

utils.noremap = function(mode, keys, mapping, args)
	args = args or { silent = true, noremap = true }
	vim.keymap.set(mode, keys, mapping, args)
end

utils.map = function(mode, keys, mapping, args)
	args = args or { silent = true, noremap = false }
	vim.keymap.set(mode, keys, mapping, args)
end

utils.noremap_buffer = function(mode, keys, mapping, args)
	args = args or { silent = true, noremap = true }
	vim.api.nvim_buf_set_keymap(0, mode, keys, mapping, args)
end

utils.map_buffer = function(mode, keys, mapping, args)
	args = args or { silent = true, noremap = false }
	vim.api.nvim_buf_set_keymap(0, mode, keys, mapping, args)
end

utils.p = function(ghlink)
	local result, count = string.gsub(ghlink, "https://github.com/", "")
	if count == 0 then
		result, _ = string.gsub(ghlink, "https://gitlab.com/", "")
	end
	return result
end

utils.scandir = function(directory)
	local i, t, popen = 0, {}, io.popen
	local pfile = popen('ls -A "' .. directory .. '"')
	for filename in pfile:lines() do
		i = i + 1
		t[i] = filename
	end
	pfile:close()
	return t
end

utils.stripLuaExtension = function(file)
	return string.gsub(file, ".lua", "")
end

utils.stripLuaExtensions = function(files)
	local result = {}
	for i, f in pairs(files) do
		result[i] = utils.stripLuaExtension(f)
	end
	return result
end

utils.getPluginScripts = function(prefix)
	return utils.stripLuaExtensions(
		utils.scandir(vim.fn.stdpath("config") .. "/lua/" .. prefix)
	)
end

utils.addTable = function(table1, table2)
	for k, v in pairs(table2) do
		if type(k) == "number" then
			table.insert(table1, v)
		else
			table1[k] = v
		end
	end
end

---@param t1 {}
---@param t2 {}
utils.tableConcat = function(t1, t2)
	local tOut = {}
	for i = 1, #t1 do
		tOut[i] = t1[i]
	end
	for i = 1, #t2 do
		tOut[i + #t1] = t2[i]
	end
	return tOut
end

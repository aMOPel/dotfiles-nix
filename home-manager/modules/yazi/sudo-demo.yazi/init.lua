--- Verify if `sudo` is already authenticated
--- @return boolean
local sudo_already = function()
	local status =
		Command("sudo"):args({ "--validate", "--non-interactive" }):status()
	assert(status, "Failed to run `sudo --validate --non-interactive`")
	return status.success
end

--- Run a program with `sudo` privilege
--- @param program string
--- @param args table
--- @return Output|nil output
--- @return integer|nil err
---  nil: no error
---  1: sudo failed
local run_with_sudo = function(program, args, cwd)
	ya.err("HERE", program, args, cwd)
	-- local cmd = Command("sudo"):args({ program, table.unpack(args) }):cwd(cwd)
	-- if sudo_already() then
	-- 	return cmd:output()
	-- end
	--
	-- local permit = ya.hide()
	-- print(
	-- 	string.format(
	-- 		"Sudo password required to run: `%s %s`",
	-- 		program,
	-- 		table.concat(args)
	-- 	)
	-- )
	-- local output = cmd:output()
	-- permit:drop()
	--
	-- if output.status.success or sudo_already() then
	-- 	return output
	-- end
	-- return nil, 1
end

local function info(content)
	return ya.notify({
		title = "sudo",
		content = content,
		timeout = 5,
	})
end

local selected_or_hovered = ya.sync(function(state)
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local yanked = ya.sync(function(state)
	local yanked, paths = cx.yanked, {}
	for _, u in pairs(yanked) do
		paths[#paths + 1] = tostring(u)
	end
	return paths
end)

local cwd = ya.sync(function(state)
	return tostring(cx.active.current.cwd)
end)

local is_cut = ya.sync(function(state)
	return cx.yanked.is_cut
end)

local entry = function(state, job)
	ya.err(job.args)
	if not job.args then
		return info("bad")
	end
	local verb = job.args[1]

	selected_or_hovered()
	yanked()
	is_cut()
	cwd()

	local files = selected_or_hovered()
	local yanked = yanked()
	local is_cut = is_cut()
	local cwd = cwd()

	local command = ""
	local args = {}

	if verb == "remove" and files then
		if job.args.permanently then
			command = "rm"
			args = { "-rI", table.unpack(files) }
		else
			command = "trash-cli"
			args = { "--", table.unpack(files) }
		end
	elseif yanked and verb == "paste" then
		if is_cut() then
			command = "mv"
			local force = "-i"
			if job.args.force then
				force = "-f"
			end
			args = { "-t", force, cwd, table.unpack(yanked) }
		else
			command = "cp"
			local force = "-i"
			if job.args.force then
				force = "-f"
			end
			args = { "-r", force, "-t", cwd, table.unpack(yanked) }
		end
	elseif yanked and verb == "link" then
		command = "ln"
		local force = "-i"
		if job.args.force then
			force = "-f"
		end
		local relative = ""
		if job.args.relative then
			relative = "-r"
		end
		args = { "-s", force, relative, "-t", cwd, table.unpack(yanked) }
	elseif verb == "create" then
		local value, event = ya.input({
			title = "sudo create:",
			position = { "top-center", y = 3, w = 40 },
		})
		if not value or event ~= 1 then
			return
		end
		if string.sub(value, -2, -1) == "/" then
      -- TODO:
			command = "mkdir"
			args = { "-p", value }
		else
			command = "touch"
			args = { value }
		end
	else
    ya.err("fail", "files", files, "yanked", yanked, "is_cut", is_cut, "cwd", cwd)
	end

	local output = run_with_sudo(command, args, cwd)
	if not output then
		return ya.err("Failed to run `sudo ls -l`")
	end

	ya.err("stdout", output.stdout)
	ya.err("status.code", output.status.code)
end

return {
	entry = entry,
}

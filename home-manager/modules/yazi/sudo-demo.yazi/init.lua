local function notify(level, ...)
	local content = ...
	if type(...) == "table" then
		content = table.concat(..., " | ")
	end
	ya.notify({
		title = "sudo",
		content = content,
		timeout = 10,
		level = level,
	})
end

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
--- @return Output|string output
---  nil: no error
---  1: sudo failed
local run_with_sudo = function(program, args, cwd)
	local cmd =
		Command("sudo"):args({ "--", program, table.unpack(args) }):cwd(cwd)
	if sudo_already() then
		local permit = ya.hide()
		local output = cmd:output()
		permit:drop()
		return output
	end

	local permit = ya.hide()
	print(string.format("Sudo password required to run: `%s`", program))
	local output = cmd:output()
	permit:drop()
	return output
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
	if not job.args then
		notify("error", "plugin needs arguments")
		return
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

	if verb == "remove" then
		if files then
			if job.args.permanently then
				command = "rm"
				args = { "-r", "--", table.unpack(files) }
			else
				command = "trash-cli"
				args = { "--", table.unpack(files) }
			end
		end
	elseif verb == "paste" then
		if yanked then
			if is_cut then
				command = "mv"
				local force = ""
				if job.args.force then
					force = "-f"
				end
				args = { force, "-t", cwd, "--", table.unpack(yanked) }
			else
				command = "cp"
				local force = ""
				if job.args.force then
					force = "-f"
				end
				args = { "-r", force, "-t", cwd, "--", table.unpack(yanked) }
			end
		end
	elseif verb == "link" then
		if yanked then
			command = "ln"
			local force = ""
			if job.args.force then
				force = "-f"
			end
			local relative = ""
			if job.args.relative then
				relative = "-r"
			end
			args =
				{ "-s", force, relative, "-t", cwd, "--", table.unpack(yanked) }
		end
	elseif verb == "create" then
		local value, event = ya.input({
			title = "sudo create:",
			position = { "top-center", y = 3, w = 40 },
		})
		if not value or event ~= 1 then
			return
		end
		if string.sub(value, -1, -1) == "/" then
			command = "mkdir"
			args = { "-p", "--", value }
		else
			command = "touch"
			args = { "--", value }
		end
	elseif verb == "rename" then
		if #files ~= 1 then
			notify("error", "can only sudo rename one file")
			return
		end
		local value, event = ya.input({
			title = "sudo rename:",
			value = Url(files[1]):name(),
			position = { "hovered", y = 1, w = 40 },
		})
		if not value or event ~= 1 then
			return
		end
		command = "mv"
		args = { "--", table.unpack(files), cwd .. "/" .. value }
	elseif verb == "chmod" then
		local value, event = ya.input({
			title = "sudo chmod (recursive):",
			position = { "top-center", w = 40 },
		})
		if not value or event ~= 1 then
			return
		end
		command = "chmod"
		args = { "-R", "--", value, table.unpack(files) }
	-- elseif verb == "open" then
	-- 	if files then
	-- 		command = "vi"
	-- 		args = {
	-- 			"-u",
	-- 			"$HOME/.config/nvim/init.lua",
	-- 			"--",
	-- 			table.unpack(files),
	-- 		}
	-- 	end
	else
		notify("error", "plugin needs arguments")
		return
	end

	ya.err("HERE", command, args, cwd)
	local output = run_with_sudo(command, args, cwd)

	ya.err("stdout", output.stdout)
	ya.err("stderr", output.stderr)
	ya.err("status.code", output.status.code)

	if output.stdout ~= "" then
		notify("info", {"Ran command:", output.stdout})
	end
	if not output.status.success then
		notify("error", {"Command failed:", output.stderr})
		return
	end
end

return {
	entry = entry,
}

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

local function tableAppend(t1, t2)
  if type(t1) ~= "table" then
    return
  end
  if type(t2) ~= "table" then
    return
  end
  for k, v in pairs(t2) do
    if type(k) == "number" then
      table.insert(t1, v)
    else
      t1[k] = v
    end
  end
end

--- Verify if `sudo` is already authenticated
--- @return boolean
local sudo_already = function()
  local status = Command("sudo"):arg({ "--validate", "--non-interactive" }):status()
  assert(status, "Failed to run `sudo --validate --non-interactive`")
  return status.success
end

--- Run a program with `sudo` privilege
--- @param program string
--- @param args table
--- @return Output|string output
local run_with_sudo = function(program, args, cwd)
  local cmd = Command("sudo"):arg({ "--", program, table.unpack(args) }):cwd(cwd)
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

local get_selected_or_hovered = ya.sync(function(state)
  local tab, paths = cx.active, {}
  for _, u in pairs(tab.selected) do
    paths[#paths + 1] = tostring(u)
  end
  if #paths == 0 and tab.current.hovered then
    paths[1] = tostring(tab.current.hovered.url)
  end
  return paths
end)

local get_yanked = ya.sync(function(state)
  local yanked, paths = cx.yanked, {}
  for _, u in pairs(yanked) do
    paths[#paths + 1] = tostring(u)
  end
  return paths
end)

local get_cwd = ya.sync(function(state)
  return tostring(cx.active.current.cwd)
end)

local get_is_cut = ya.sync(function(state)
  return cx.yanked.is_cut
end)

local function buildArgs(verb, jobArgs, files, yanked, is_cut, cwd)
  local args = {}
  local command = ""

  if verb == "remove" then
    if files then
      if jobArgs.permanently then
        command = "rm"
        args = { "-r", "--", table.unpack(files) }
      else
        notify("error", "sudo remove needs flag '--permanently'")
        return
      end
    end
  elseif verb == "paste" then
    if yanked then
      if is_cut then
        command = "mv"
        if jobArgs.force then
          table.insert(args, "-f")
        end
        tableAppend(args, { "-t", cwd, "--" })
        tableAppend(args, yanked)
      else
        command = "cp"
        table.insert(args, "-r")
        if jobArgs.force then
          table.insert(args, "-f")
        end
        tableAppend(args, { "-t", cwd, "--" })
        tableAppend(args, yanked)
      end
    end
  elseif verb == "link" then
    if yanked then
      command = "ln"
      table.insert(args, "-s")
      if jobArgs.force then
        table.insert(args, "-f")
      end
      if jobArgs.relative then
        table.insert(args, "-r")
      end
      tableAppend(args, { "-t", cwd, "--" })
      tableAppend(args, yanked)
    end
  elseif verb == "create" then
    local value, event = ya.input({
      title = "sudo create:",
      position = { "top-center", y = 3, w = 40 },
    })
    if value == nil or event ~= 1 then
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
      notify("error", "can only sudo rename one file at a time")
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
    table.insert(args, "--")
    tableAppend(args, files)
    table.insert(args, cwd .. "/" .. value)
  elseif verb == "chmod" then
    local value, event = ya.input({
      title = "sudo chmod (recursive):",
      position = { "top-center", w = 40 },
    })
    if not value or event ~= 1 then
      return
    end
    command = "chmod"
    tableAppend(args, { "-R", "--", value })
    tableAppend(args, files)
  elseif verb == "chown" then
    local value, event = ya.input({
      title = "sudo chown (recursive):",
      position = { "top-center", w = 40 },
    })
    if not value or event ~= 1 then
      return
    end
    command = "chown"
    tableAppend(args, { "-R", "--", value })
    tableAppend(args, files)
  -- elseif verb == "open" then
  -- 	if files then
  -- 		command = "vi"
  -- 		args = {
  -- 			"--",
  -- 			table.unpack(files),
  -- 		}
  -- 	end
  else
    notify("error", "plugin needs one of the supported verbs as argument")
    return
  end

  return command, args, cwd
end

local testBuildArgs = function(args) end

local entry = function(state, job)
  if not ya.target_os() == "linux" then
    notify("error", "plugin only works on linux")
    return
  end
  if not job.args then
    notify("error", "plugin needs arguments")
    return
  end
  local verb = job.args[1]

  local files = get_selected_or_hovered()
  local yanked = get_yanked()
  local is_cut = get_is_cut()
  local cwd = get_cwd()

  local command = ""
  local args = {}

  if verb == "test" then
    notify("info", "ran test", testBuildArgs(job))
    return
  end

  ya.dbg("command", command, args, cwd)
  local program, args, cwd = buildArgs(verb, job.args, files, yanked, is_cut, cwd)
  if type(program) ~= "string" then
    return
  end
  if type(args) ~= "table" then
    return
  end
  if type(cwd) ~= "string" then
    return
  end
  local output = run_with_sudo(program, args, cwd)

  ya.dbg("cmd", program, args, cwd)
  ya.dbg("stdout", output.stdout)
  ya.dbg("stderr", output.stderr)
  ya.dbg("status.code", output.status.code)

  if output.stdout ~= "" then
    notify("info", { "ran command", output.stdout })
  end
  if not output.status.success then
    notify("error", { "command failed", output.stderr })
    return
  end
end

return {
  entry = entry,
}

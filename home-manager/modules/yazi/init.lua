th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.added = ui.Style():fg("green")
th.git.untracked = ui.Style():fg("gray")
th.git.ignored = ui.Style():fg("darkgray")
th.git.deleted = ui.Style():fg("red"):bold()
th.git.updated = ui.Style():fg("cyan")

th.git.modified_sign = "M"
th.git.added_sign = "A"
th.git.untracked_sign = "?"
th.git.ignored_sign = "."
th.git.deleted_sign = "D"
th.git.updated_sign = "U"

require("git"):setup()

require("relative-motions"):setup({ show_numbers="relative", show_motion = true })

require("session"):setup {
	sync_yanked = true,
}

-- show symlink in status line
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

-- show uid:gid in statusline
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("white"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("white"),
		" ",
	}
end, 500, Status.RIGHT)

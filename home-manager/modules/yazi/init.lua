THEME.git = THEME.git or {}
THEME.git.modified = ui.Style():fg("blue")
THEME.git.added = ui.Style():fg("green")
THEME.git.untracked = ui.Style():fg("gray")
THEME.git.ignored = ui.Style():fg("darkgray")
THEME.git.deleted = ui.Style():fg("red"):bold()
THEME.git.updated = ui.Style():fg("cyan")

THEME.git.modified_sign = "M"
THEME.git.added_sign = "A"
THEME.git.untracked_sign = "?"
THEME.git.ignored_sign = "."
THEME.git.deleted_sign = "D"
THEME.git.updated_sign = "U"

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

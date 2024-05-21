-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	pattern = "*",
-- 	group = "MyAutoCmd",
-- 	callback = function()
-- 		for _, data in pairs(plugins) do
-- 			data.config()
-- 		end
-- 	end,
-- })

for _, data in pairs(g.plugins) do
	data.config()
end
for _, data in pairs(g.plugins) do
	data.setup()
end

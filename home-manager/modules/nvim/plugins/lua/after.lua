for _, data in pairs(g.plugins) do
  data.config()
end
for _, data in pairs(g.plugins) do
  data.setup()
end

local utils = {}

utils.addTable = function(table1, table2)
  for k, v in pairs(table2) do
    if type(k) == "number" then
      table.insert(table1, v)
    else
      table1[k] = v
    end
  end
end

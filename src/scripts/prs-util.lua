PRSutil = {}

PRSutil.colorTable = {
  ["{{r"] = "#c50f1f",
  ["{{R"] = "#e74856",
  ["{{g"] = "#13a10e",
  ["{{G"] = "#16c60c",
  ["{{y"] = "#c19c00",
  ["{{Y"] = "#f9f1a5",
  ["{{b"] = "#0037da",
  ["{{B"] = "#3b78ff",
  ["{{m"] = "#3b78ff",
  ["{{M"] = "#b4009e",
  ["{{c"] = "#3a96dd",
  ["{{C"] = "#61d6d6",
  ["{{w"] = "#aaaaaa",
  ["{{W"] = "#f2f2f2",
  ["{{K"] = "#767676>"
}

PRSutil.getHechoColor = function (string)
  local formatted = string
  for placeholder, colorCode in pairs(PRSutil.colorTable) do
    formatted = formatted:gsub(placeholder, colorCode)
  end
  return formatted
end

PRSutil.removeColor = function (string)
  local formatted = string
  for placeholder, colorCode in pairs(PRSutil.colorTable) do
    formatted = formatted:gsub(placeholder, "")
  end
  return formatted
end

PRSutil.tableConcat = function (t1,t2)
  local t3 = {}
  for i=1,#t1 do
      t3[i] = t1[i]
  end
  for i=1,#t2 do
      t3[#t1+i] = t2[i]
  end
  return t3
end

PRSutil.tableCopy = function (obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[PRSutil.tableCopy(k, s)] = PRSutil.tableCopy(v, s) end
  return res
end
PRSutil = {}

PRSutil.colorTable = {
  ["{{r"] = "<ansi_red>",
  ["{{R"] = "<ansi_light_red>",
  ["{{g"] = "<ansi_green>",
  ["{{G"] = "<ansi_light_green>",
  ["{{y"] = "<ansi_yellow>",
  ["{{Y"] = "<ansi_light_yellow>",
  ["{{b"] = "<ansi_blue>",
  ["{{B"] = "<ansi_light_blue>",
  ["{{m"] = "<ansi_magenta>",
  ["{{M"] = "<ansi_light_magenta>",
  ["{{c"] = "<ansi_cyan>",
  ["{{C"] = "<ansi_light_cyan>",
  ["{{w"] = "<ansi_white>",
  ["{{W"] = "<ansi_light_white>",
  ["{{K"] = "<ansi_light_black>"
}

PRSutil.getCechoColor = function (string)
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
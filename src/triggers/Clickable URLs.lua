-- https://forums.mudlet.org/viewtopic.php?p=6969#p6969
for i,v in ipairs(matches) do
    selectString(matches[i], 1)
    setLink([[openUrl("]]..matches[i]..[[")]], matches[i])
end
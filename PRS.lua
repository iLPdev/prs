-- Procedural Realms Script (PRS) for Mudlet
-- by Stack (https://ilpdev.com/prs) & Dalem

local version = "1.7.0"

-- check if the generic_mapper package is installed and, if so, uninstall it
if table.contains(getPackages(),"generic_mapper") then
  uninstallPackage("generic_mapper")
end

registerAnonymousEventHandler("gmcp.Char.player", function()
    PRSstats.stats()
end, true)

-- set Discord button to PR invite
setDiscordGameUrl("https://discord.gg/rRFEjc6vV9", "Procedural Realms")

-- Discord Rich Text Integration
setDiscordApplicationID("947477099596378142")
setDiscordGame("Procedural Realms")
local currentarea = getRoomArea(getPlayerRoom())
local areaname = getAreaTableSwap()[currentarea]
setDiscordDetail(areaname)
setDiscordElapsedStartTime(os.time(os.date("*t")))
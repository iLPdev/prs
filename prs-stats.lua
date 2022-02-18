PRSstats = PRSstats or {}
function PRSstats.stats()
  local SUG = require("MDK.sug")
  PRSstats.UW = Geyser.UserWindow:new({name = "Stats", titleText ="Vitals - Procedural Realms", x = "75%", y = "100", docked = true})
  
  -- the following will watch "gmcp.Char.Vitals.hp" and "gmcp.Char.Vitals.maxhp"
  -- and update itself every 250 milliseconds
  HPbar = SUG:new({
    name = "HP",
    height = 50,
    width = "100%", -- everything up to here is standard Geyser.Gauge
    updateTime = 250, -- this timer will update every 250ms, or 4 times a second
    textTemplate = "HP: |c/|m (|p%)", -- gauge will show "HP: 500/1000 (50%)" as the text if you had 500 current and 1000 max hp
    currentVariable = "gmcp.Char.Vitals.hp", --if gmcp.Char.Vitals.hp is nil or unreachable, it will use the defaultCurrent of 50
    maxVariable = "gmcp.Char.Vitals.maxhp",  --if gmcp.Char.Vitals.maxhp is nil or unreachable, it will use the defaultMax of 100
  }, PRSstats.UW)
  ENbar = SUG:new({
    name = "EN",
    y = 70,
    height = 50,
    width = "100%", 
    updateTime = 250, 
    textTemplate = "EN: |c/|m (|p%)",
    currentVariable = "gmcp.Char.Vitals.en",
    maxVariable = "gmcp.Char.Vitals.maxen",
  }, PRSstats.UW)
  STbar = SUG:new({
    name = "ST",
    y = 130,
    height = 50,
    width = "100%", 
    updateTime = 250, 
    textTemplate = "ST: |c/|m (|p%)",
    currentVariable = "gmcp.Char.Vitals.st",
    maxVariable = "gmcp.Char.Vitals.maxst",
  }, PRSstats.UW)  
end
PRSstats = PRSstats or {}
PRSstats.events = PRSstats.events or {}
PRSstats.xp = PRSstats.xp or {}
PRSstats.xp.current = PRSstats.xp.current or 50
PRSstats.xp.tnl = PRSstats.xp.tnl or 100


local SUG = require("PRS.sug")

local function add_gauges()
  -- Hit Points Gauge
  HPbar = SUG:new({
    name = "HP",
    height = 25,
    width = "95%", -- everything up to here is standard Geyser.Gauge
    updateTime = 250, -- this timer will update every 250ms, or 4 times a second
    textTemplate = "HP: |c / |m  (|p%)", -- gauge will show "HP: 500/1000 (50%)" as the text if you had 500 current and 1000 max hp
    currentVariable = "gmcp.Char.player.hp", --if gmcp.Char.Vitals.hp is nil or unreachable, it will use the defaultCurrent of 50
    maxVariable = "gmcp.Char.player.maxHp",  --if gmcp.Char.Vitals.maxhp is nil or unreachable, it will use the defaultMax of 100
  }, PRSstats.UW)
    HPbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #98f041, stop: 0.1 #8cf029, stop: 0.49 #66cc00, stop: 0.5 #52a300, stop: 1 #66cc00);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 7;
      padding: 3px;
    ]])
    HPbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #78bd33, stop: 0.1 #6ebd20, stop: 0.49 #4c9900, stop: 0.5 #387000, stop: 1 #4c9900);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 7;
      padding: 3px;
    ]])
    HPbar.text:setStyleSheet([[
      font-weight: bold;
    ]])

  -- Energy Points Gauge
  ENbar = SUG:new({
    name = "EN",
    y = 45,
    height = 25,
    width = "95%", 
    updateTime = 250, 
    textTemplate = "EN: |c / |m  (|p%)",
    currentVariable = "gmcp.Char.player.energy",
    maxVariable = "gmcp.Char.player.maxEnergy",
  }, PRSstats.UW)
    ENbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffffff, stop: 0.1 #eeeeee, stop: 0.49 #cccccc, stop: 0.5 #aaaaaa, stop: 1 #cccccc);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 7;
      padding: 3px;
    ]])
    ENbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dddddd, stop: 0.1 #cccccc, stop: 0.49 #aaaaaa, stop: 0.5 #888888, stop: 1 #aaaaaa);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 7;
      padding: 3px;
    ]])
    ENbar.text:setStyleSheet([[
      font-weight: bold;
    ]])

  -- Stamina Points Gauge
  STbar = SUG:new({
    name = "ST",
    y = 80,
    height = 25,
    width = "95%", 
    updateTime = 250, 
    textTemplate = "ST: |c / |m  (|p%)",
    currentVariable = "gmcp.Char.player.stamina",
    maxVariable = "gmcp.Char.player.maxStamina",
  }, PRSstats.UW)
    STbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #ffff50, stop: 0.1 #ffe200, stop: 0.49 #c1c100, stop: 0.5 #a4a40c, stop: 1 #c1c100);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 7;
      padding: 3px;]])
    STbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dddd20, stop: 0.1 #ddc200, stop: 0.49 #a1a100, stop: 0.5 #94840c, stop: 1 #a1a100);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 7;
      padding: 3px;]])
    STbar.text:setStyleSheet([[
      font-weight: bold;
    ]])

    -- Food Points Gauge
  HPbar = SUG:new({
    name = "FP",
    y = 115,
    height = 25,
    width = "95%",
    updateTime = 250,
    textTemplate = "Food: |c / |m  (|p%)",
    currentVariable = "gmcp.Char.player.food",
    maxVariable = "gmcp.Char.player.maxFood",
  }, PRSstats.UW)
    HPbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #98f041, stop: 0.1 #8cf029, stop: 0.49 #66cc00, stop: 0.5 #52a300, stop: 1 #66cc00);
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 7;
      padding: 3px;
    ]])
    HPbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #78bd33, stop: 0.1 #6ebd20, stop: 0.49 #4c9900, stop: 0.5 #387000, stop: 1 #4c9900);
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-radius: 7;
      padding: 3px;
    ]])
    HPbar.text:setStyleSheet([[
      font-weight: bold;
    ]])

    -- Rage Points Gauge
  RPbar = SUG:new({
    name ="RP",
    y = 150,
    height = 25,
    width = "95%", 
    updateTime = 250, 
    textTemplate = "Rage: |c",
    currentVariable = "gmcp.Char.player.rage",
    maxVariable = "gmcp.Char.player.maxRage",
  }, PRSstats.UW)
    RPbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000);
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 7;
        padding: 3px;]])
    RPbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000);
        border-width: 1px;
        border-color: black;
        border-style: solid;
        border-radius: 7;
        padding: 3px;]])
    RPbar.text:setStyleSheet([[
      font-weight: bold;
    ]])

  -- Combo Points Gauge
  CPbar = SUG:new({
    name = "CP",
    y = 185,
    height = 25,
    width = "95%", 
    updateTime = 250, 
    textTemplate = "Combo: |c",
    currentVariable = "gmcp.Char.player.combo",
    maxVariable = "gmcp.Char.player.maxCombo",
  }, PRSstats.UW)
    CPbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000);
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 7;
        padding: 3px;]])
    CPbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000);
        border-width: 1px;
        border-color: black;
        border-style: solid;
        border-radius: 7;
        padding: 3px;]])
    CPbar.text:setStyleSheet([[
      font-weight: bold;
    ]])  
    
  -- Experience Points Gauge
  if gmcp.Char.player.xp < gmcp.Char.player.xpForCurrentLevel then
    XPbar = SUG:new({
      name = "XP",
      y = 220,
      height = 25,
      width = "95%",
      updateTime = 250, 
      textTemplate = "XP: |c / |m   (|p%)",
      currentVariable = "PRSstats.xp.current",
      maxVariable = "PRSstats.xp.tnl"
    }, PRSstats.UW)
      XPbar.front:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3399ff, stop: 0.1 #0080ff, stop: 0.49 #0000ff, stop: 0.5 #0000cc, stop: 1 #0000ff);
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 7;
        padding: 3px;
      ]])
      XPbar.back:setStyleSheet([[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #0066cc, stop: 0.1 #004c99, stop: 0.49 #000099, stop: 0.5 #000066, stop: 1 #000099);
        border-width: 1px;
        border-color: black;
        border-style: solid;
        border-radius: 7;
        padding: 3px;
      ]])
      XPbar.text:setStyleSheet([[
        font-weight: bold;
      ]])
    end
end

function PRSstats.stats()
  PRSstats.UW = Geyser.UserWindow:new({name = "Stats", titleText ="Vitals", x = "75%", y = "75%", height="25%", width="25%", docked = true, restoreLayout = true})
  
  if gmcp and gmcp.Char and gmcp.Char.Vitals then
    PRSstats.UW:setTitle("Vitals - "..gmcp.Char.player.name)
    add_gauges()
  else
    local initialize_ev_handler = registerAnonymousEventHandler("gmcp.Char.player", function()
      PRSstats.UW:setTitle("Vitals - "..gmcp.Char.player.name)
      add_gauges()
    end, true)
  end
end

if PRSstats.events.xp_id then killAnonymousEventHandler(PRSstats.events.xp_id) end
PRSstats.events.xp_id = registerAnonymousEventHandler("gmcp.Char.player.xp", function()
  PRSstats.xp.current = gmcp.Char.player.xp - gmcp.Char.player.xpForCurrentLevel
end)

if PRSstats.events.xpForCurrentLevel_id then killAnonymousEventHandler(PRSstats.events.xpForCurrentLevel_id) end
PRSstats.events.xpForCurrentLevel_id = registerAnonymousEventHandler("gmcp.Char.player.xpForCurrentLevel", function()
  PRSstats.xp.current = gmcp.Char.player.xp - gmcp.Char.player.xpForCurrentLevel
  PRSstats.xp.tnl = gmcp.Char.player.xpForNextLevel - gmcp.Char.player.xpForCurrentLevel
end)

if PRSstats.events.xpForNextLevel_id then killAnonymousEventHandler(PRSstats.events.xpForNextLevel_id) end
PRSstats.events.xpForNextLevel_id = registerAnonymousEventHandler("gmcp.Char.player.xpForNextLevel", function()
  PRSstats.xp.tnl = gmcp.Char.player.xpForNextLevel - gmcp.Char.player.xpForCurrentLevel
end)

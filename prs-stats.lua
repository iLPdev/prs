PRSstats = PRSstats or {}
function PRSstats.stats()
  local SUG = require("PRS.sug")
  PRSstats.UW = Geyser.UserWindow:new({name = "Stats", titleText ="Vitals", x = "75%", y = "100", docked = true})
  
  -- Experience Points Gauge
  XPbar = SUG:new({
    name = "XP",
    height = 50,
    width = "95%",
    updateTime = 250, 
    textTemplate = "&nbsp;XP: |c / |m",
    currentVariable = "gmcp.Char.Vitals.xp",
    maxVariable = "gmcp.Char.Vitals.nl",
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

  -- Hit Points Gauge
  HPbar = SUG:new({
    name = "HP",
    y = "70",
    height = 50,
    width = "95%", -- everything up to here is standard Geyser.Gauge
    updateTime = 250, -- this timer will update every 250ms, or 4 times a second
    textTemplate = "&nbsp;&nbsp;HP: |c / |m  (|p%)", -- gauge will show "HP: 500/1000 (50%)" as the text if you had 500 current and 1000 max hp
    currentVariable = "gmcp.Char.Vitals.hp", --if gmcp.Char.Vitals.hp is nil or unreachable, it will use the defaultCurrent of 50
    maxVariable = "gmcp.Char.Vitals.maxhp",  --if gmcp.Char.Vitals.maxhp is nil or unreachable, it will use the defaultMax of 100
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
    y = 130,
    height = 50,
    width = "95%", 
    updateTime = 250, 
    textTemplate = "&nbsp;&nbsp;EN: |c / |m  (|p%)",
    currentVariable = "gmcp.Char.Vitals.en",
    maxVariable = "gmcp.Char.Vitals.maxen",
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
    y = 190,
    height = 50,
    width = "95%", 
    updateTime = 250, 
    textTemplate = "&nbsp;&nbsp;ST: |c / |m  (|p%)",
    currentVariable = "gmcp.Char.Vitals.st",
    maxVariable = "gmcp.Char.Vitals.maxst",
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
    
  -- Combo Points Gauge
  CPbar = SUG:new({
    name="CP",
    y="250",
    height=50,
    width="95%", 
    updateTime = 250, 
    textTemplate = "&nbsp;&nbsp;Combo: |c / |m  (|p%)",
    currentVariable = "gmcp.Char.Vitals.combo",
    maxcombo = 100,
    maxVariable = "maxcombo",
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
end
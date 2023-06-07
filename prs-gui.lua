PRSstats = PRSstats or {}
PRSstats.events = PRSstats.events or {}

local SUG = require("PRS.sug")

local function add_gauges()
    -- Hit Points Gauge
    HPbar = SUG:new({
        name = "HP",
        height = 25,
        width = "95%", -- everything up to here is standard Geyser.Gauge
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "HP: |c / |m  (|p%)", -- gauge will show "HP: 500/1000 (50%)" as the text if you had 500 current and 1000 max hp
        currentVariable = "gmcp.Char.player.hp", -- if gmcp.Char.Vitals.hp is nil or unreachable, it will use the defaultCurrent of 50
        maxVariable = "gmcp.Char.player.maxHp" -- if gmcp.Char.Vitals.maxhp is nil or unreachable, it will use the defaultMax of 100
    }, GUI.tabwindow3.Vitalscenter)
    HPbar.front:setStyleSheet(
        [[background-color: #63e2b7;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      padding: 3px;
    ]])
    HPbar.back:setStyleSheet(
        [[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      padding: 3px;
    ]])
    HPbar.text:setStyleSheet([[
      font-weight: bold;
      padding-left: 5px;
    ]])

    -- Energy Points Gauge
    ENbar = SUG:new({
        name = "EN",
        y = 45,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "EN: |c / |m  (|p%)",
        currentVariable = "gmcp.Char.player.energy",
        maxVariable = "gmcp.Char.player.maxEnergy"
    }, GUI.tabwindow3.Vitalscenter)
    ENbar.front:setStyleSheet(
        [[background-color: #cccccc;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      padding: 3px;
    ]])
    ENbar.back:setStyleSheet(
        [[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      padding: 3px;
    ]])
    ENbar.text:setStyleSheet([[
      font-weight: bold;
      padding-left: 5px;
    ]])

    -- Stamina Points Gauge
    STbar = SUG:new({
        name = "ST",
        y = 80,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "ST: |c / |m  (|p%)",
        currentVariable = "gmcp.Char.player.stamina",
        maxVariable = "gmcp.Char.player.maxStamina"
    }, GUI.tabwindow3.Vitalscenter)
    STbar.front:setStyleSheet(
        [[background-color: #f2c97d;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      padding: 3px;]])
    STbar.back:setStyleSheet(
        [[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      padding: 3px;]])
    STbar.text:setStyleSheet([[
      font-weight: bold;
      padding-left: 5px;
    ]])

    -- Food Points Gauge
    HPbar = SUG:new({
        name = "FP",
        y = 115,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Food: |c / |m  (|p%)",
        currentVariable = "gmcp.Char.player.food",
        maxVariable = "gmcp.Char.player.maxFood"
    }, GUI.tabwindow3.Vitalscenter)
    HPbar.front:setStyleSheet(
        [[background-color: #63e2b7;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      padding: 3px;
    ]])
    HPbar.back:setStyleSheet(
        [[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      padding: 3px;
    ]])
    HPbar.text:setStyleSheet([[
      font-weight: bold;
      padding-left: 5px;
    ]])

    -- Rage Points Gauge
    RPbar = SUG:new({
        name = "RP",
        y = 150,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Rage: |c",
        currentVariable = "gmcp.Char.player.rage",
        maxVariable = "gmcp.Char.player.maxRage"
    }, GUI.tabwindow2.Combatcenter)
    RPbar.front:setStyleSheet(
        [[background-color: #cc0000;
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        padding: 3px;]])
    RPbar.back:setStyleSheet(
        [[background-color: #303030;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        padding: 3px;]])
    RPbar.text:setStyleSheet([[
      font-weight: bold;
      padding-left: 5px;
    ]])

    -- Combo Points Gauge
    CPbar = SUG:new({
        name = "CP",
        y = 185,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Combo: |c",
        currentVariable = "gmcp.Char.player.combo",
        maxVariable = "gmcp.Char.player.maxCombo"
    }, GUI.tabwindow2.Combatcenter)
    CPbar.front:setStyleSheet(
        [[background-color: #cc0000;
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        padding: 3px;]])
    CPbar.back:setStyleSheet(
        [[background-color: #303030;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        padding: 3px;]])
    CPbar.text:setStyleSheet([[
      font-weight: bold;
      padding-left: 5px;
    ]])

    -- Experience Points Gauge
    if gmcp.Char.player.xpForNextLevel then

        PRSstats.xp = PRSstats.xp or {}
        PRSstats.xp.current = gmcp.Char.player.xp - gmcp.Char.player.xpForCurrentLevel
        PRSstats.xp.tnl = gmcp.Char.player.xpForNextLevel - gmcp.Char.player.xpForCurrentLevel

        XPbar = SUG:new({
            name = "XP",
            y = 220,
            height = 25,
            width = "95%",
            updateTime = 0,
            updateEvent = "gmcp.Char.player",
            textTemplate = "XP: |c / |m   (|p%)",
            currentVariable = "PRSstats.xp.current",
            maxVariable = "PRSstats.xp.tnl"
        }, GUI.tabwindow3.Vitalscenter)
        XPbar.front:setStyleSheet(
            [[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #3399ff, stop: 0.1 #0080ff, stop: 0.49 #0000ff, stop: 0.5 #0000cc, stop: 1 #0000ff);
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        padding: 3px;
      ]])
        XPbar.back:setStyleSheet(
            [[background-color: #303030;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        padding: 3px;
      ]])
        XPbar.text:setStyleSheet([[
        font-weight: bold;
        padding-left: 5px;
      ]])

        if PRSstats.events.xp_id then
            killAnonymousEventHandler(PRSstats.events.xp_id)
        end
        PRSstats.events.xp_id = registerAnonymousEventHandler("gmcp.Char.player.xp", function()
            PRSstats.xp.current = gmcp.Char.player.xp - gmcp.Char.player.xpForCurrentLevel
        end)

        if PRSstats.events.xpForCurrentLevel_id then
            killAnonymousEventHandler(PRSstats.events.xpForCurrentLevel_id)
        end
        PRSstats.events.xpForCurrentLevel_id = registerAnonymousEventHandler("gmcp.Char.player.xpForCurrentLevel",
            function()
                PRSstats.xp.current = gmcp.Char.player.xp - gmcp.Char.player.xpForCurrentLevel
                PRSstats.xp.tnl = gmcp.Char.player.xpForNextLevel - gmcp.Char.player.xpForCurrentLevel
            end)

        if PRSstats.events.xpForNextLevel_id then
            killAnonymousEventHandler(PRSstats.events.xpForNextLevel_id)
        end
        PRSstats.events.xpForNextLevel_id = registerAnonymousEventHandler("gmcp.Char.player.xpForNextLevel", function()
            if gmcp.Char.player.xpForNextLevel then
                PRSstats.xp.tnl = gmcp.Char.player.xpForNextLevel - gmcp.Char.player.xpForCurrentLevel
            end
        end)
    end
end

add_gauges()
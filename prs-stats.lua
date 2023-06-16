-- Procedural Realms Script (PRS) Stats Gauges for Mudlet
-- by Stack (https://ilpdev.com/prs) & Dalem
PRSstats = PRSstats or {}
PRSstats.events = PRSstats.events or {}

local SUG = require("PRS.sug")

local function vitalsHeader()
    local header = Geyser.HBox:new({
        name = "header",
        height = 25,
        width = "93%"
    }, GUI.tabwindow1.Vitalscenter)
    local name = Geyser.Label:new({
        name = "name"
    }, header)
    name:setFontSize(12)
    name:setColor(0, 0, 0, 0)
    name:echo("" .. gmcp.Char.player.name .. "", "#f9f1a5", "l")
    local class = Geyser.Label:new({
        name = "class"
    }, header)
    class:setFontSize(12)
    class:setColor(0, 0, 0, 0)
    class:echo("" .. gmcp.Char.player.class .. "", "#b4009e", "c")
    if PRSstats.events.classChange_id then
        killAnonymousEventHandler(PRSstats.events.classChange_id)
    end
    PRSstats.events.classChange_id = registerAnonymousEventHandler("gmcp.Char.player.class", function()
        if gmcp.Char.player.class then
            class:echo("" .. gmcp.Char.player.class .. "", "#b4009e", "c")
        end
    end)
    local level = Geyser.Label:new({
        name = "level"
    }, header)
    level:setFontSize(12)
    level:setColor(0, 0, 0, 0)
    level:echo("Level " .. gmcp.Char.player.level .. "", "#ababab", "r")

    if PRSstats.events.levelChange_id then
        killAnonymousEventHandler(PRSstats.events.levelChange_id)
    end
    PRSstats.events.levelChange_id = registerAnonymousEventHandler("gmcp.Char.player.level", function()
        if gmcp.Char.player.level then
            level:echo("Level " .. gmcp.Char.player.level .. "", "#ababab", "r")
        end
    end)
end

local function add_gauges()
    vitalsHeader()
    -- Hit Points Gauge
    HPbar = SUG:new({
        name = "HP",
        y = 80,
        height = 25,
        width = "95%", -- everything up to here is standard Geyser.Gauge
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "HP: |c / |m  (|p%)", -- gauge will show "HP: 500/1000 (50%)" as the text if you had 500 current and 1000 max hp
        currentVariable = "gmcp.Char.player.hp", -- if gmcp.Char.Vitals.hp is nil or unreachable, it will use the defaultCurrent of 50
        maxVariable = "gmcp.Char.player.maxHp" -- if gmcp.Char.Vitals.maxhp is nil or unreachable, it will use the defaultMax of 100
    }, GUI.tabwindow1.Vitalscenter)
    HPbar.front:setStyleSheet([[background-color: #63e2b7;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;
    ]])
    HPbar.back:setStyleSheet([[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;
    ]])
    HPbar.text:setStyleSheet([[
      padding-left: 5px;
    ]])

    -- Energy Points Gauge
    ENbar = SUG:new({
        name = "EN",
        y = 115,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "EN: |c / |m  (|p%)",
        currentVariable = "gmcp.Char.player.energy",
        maxVariable = "gmcp.Char.player.maxEnergy"
    }, GUI.tabwindow1.Vitalscenter)
    ENbar.front:setStyleSheet([[background-color: #cccccc;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;
    ]])
    ENbar.back:setStyleSheet([[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;
    ]])
    ENbar.text:setStyleSheet([[
      padding-left: 5px;
    ]])

    -- Stamina Points Gauge
    STbar = SUG:new({
        name = "ST",
        y = 150,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "ST: |c / |m  (|p%)",
        currentVariable = "gmcp.Char.player.stamina",
        maxVariable = "gmcp.Char.player.maxStamina"
    }, GUI.tabwindow1.Vitalscenter)
    STbar.front:setStyleSheet([[background-color: #f2c97d;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;]])
    STbar.back:setStyleSheet([[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;]])
    STbar.text:setStyleSheet([[
      padding-left: 5px;
    ]])

    -- Food Points Gauge
    FPbar = SUG:new({
        name = "FP",
        y = 185,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Food: |c / |m  (|p%)",
        currentVariable = "gmcp.Char.player.food",
        maxVariable = "gmcp.Char.player.maxFood"
    }, GUI.tabwindow1.Vitalscenter)
    FPbar.front:setStyleSheet([[background-color: #63e2b7;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;
    ]])
    FPbar.back:setStyleSheet([[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;
    ]])
    FPbar.text:setStyleSheet([[
      padding-left: 5px;
    ]])

    -- Rage Points Gauge
    RPbar = SUG:new({
        name = "RP",
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Rage: |c",
        currentVariable = "gmcp.Char.player.rage",
        maxVariable = "gmcp.Char.player.maxRage"
    }, GUI.tabwindow2.Combatcenter)
    RPbar.front:setStyleSheet([[background-color: #e74856;
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;]])
    RPbar.back:setStyleSheet([[background-color: #303030;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;]])
    RPbar.text:setStyleSheet([[
      padding-left: 5px;
    ]])

    -- Combo Points Gauge
    CPbar = SUG:new({
        name = "CP",
        y = 45,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Combo: |c",
        currentVariable = "gmcp.Char.player.combo",
        maxVariable = "gmcp.Char.player.maxCombo"
    }, GUI.tabwindow2.Combatcenter)
    CPbar.front:setStyleSheet([[background-color: #e74856;
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;]])
    CPbar.back:setStyleSheet([[background-color: #303030;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;]])
    CPbar.text:setStyleSheet([[
      padding-left: 5px;
    ]])

    -- Experience Points Gauge
    XPbar = SUG:new({
        name = "XP",
        y = 45,
        height = 25,
        width = "95%",
        updateTime = 0,
        updateEvent = "gmcp.Char.player",
        textTemplate = "Hero"
    }, GUI.tabwindow1.Vitalscenter)
    XPbar.front:setStyleSheet([[background-color: #70c0e8;
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;
        textTemplate = "Hero",
        currentVariable = "PRSstats.xp.current",
        maxVariable = "PRSstats.xp.current"
      ]])
    XPbar.back:setStyleSheet([[background-color: #70c0e8;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;
      ]])
    XPbar.text:setStyleSheet([[
        padding-left: 5px;
      ]])

    if gmcp.Char.player.xpForNextLevel then

        PRSstats.xp = PRSstats.xp or {}
        PRSstats.xp.current = gmcp.Char.player.xp - gmcp.Char.player.xpForCurrentLevel
        PRSstats.xp.tnl = gmcp.Char.player.xpForNextLevel - gmcp.Char.player.xpForCurrentLevel

        XPbar = SUG:new({
            name = "XP",
            y = 45,
            height = 25,
            width = "95%",
            updateTime = 0,
            updateEvent = "gmcp.Char.player",
            textTemplate = "XP: |c / |m   (|p%)",
            currentVariable = "PRSstats.xp.current",
            maxVariable = "PRSstats.xp.tnl"
        }, GUI.tabwindow1.Vitalscenter)
        XPbar.front:setStyleSheet([[background-color: #70c0e8;
        border-top: 1px black solid;
        border-left: 1px black solid;
        border-bottom: 1px black solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;
      ]])
        XPbar.back:setStyleSheet([[background-color: #303030;
        border-width: 0px;
        border-color: black;
        border-style: solid;
        border-radius: 10;
        margin-right: 5px;
        padding: 3px;
      ]])
        XPbar.text:setStyleSheet([[
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

function PRSstats.stats()
    vitalsHeader()
    if gmcp and gmcp.Char and gmcp.Char.player then
        add_gauges()
    else
        local initialize_ev_handler = registerAnonymousEventHandler("gmcp.Char.player", function()
            if gmcp and gmcp.Char and gmcp.Char.player and gmcp.Char.player.name then
                add_gauges()
            end
        end, true)
    end
end

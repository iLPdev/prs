local SUG = require("PRS.sug")

PRScombat = PRScombat or {}
PRScombat.buttons = PRScombat.buttons or {}
PRScombat.buttonContainer = PRScombat.buttonContainer or Geyser.Container:new({
    x = 0,
    y = 0,
    width = "100%",
    height = "100%"
}, GUI.tabwindow2.Combatcenter)

function updateCombat()
    createCombatButtons(gmcp.Char.battle.actions)
end

function updateReadyToAct()
    local readyToAct = gmcp.Char.battle.active and gmcp.Char.battle.myTurn
    if (readyToAct) then
        setAllActionButtonCss("#444444", "#666666", "#ffffff")
    else
        setAllActionButtonCss("#222222", "#222222", "#aaaaaa")
    end
end

function createCombatButtons(actions)
    local actionList = PRSutil.tableConcat(actions.actions or {},
        PRSutil.tableConcat(actions.skills or {}, actions.spells or {}))
    local lastIndex = createActionButtons(actionList, actions)
    updateReadyToAct()

    hideUnusedButtons(lastIndex)
    organizeButtons(actionList, lastIndex)
end

function setAllActionButtonCss(bgColor, hoverColor, color)
    for i, button in ipairs(PRScombat.buttons) do
        PRScombat.buttons[i]:setStyleSheet(string.format([[
      QLabel {
        background-color: %s;
        padding: 10px;
        border-radius: 5;
      }
      
      QLabel::hover{
        background-color: %s;
      }
    ]], bgColor, hoverColor))
        PRScombat.buttons[i]:setCursor("PointingHand")
        PRScombat.buttons[i]:setFgColor(color)
    end
end

function createActionButtons(actions, sortedActions)
    local lastIndex = 0

    for i, action in ipairs(actions) do
        PRScombat.buttons[i] = PRScombat.buttons[i] or Geyser.Label:new({
            name = "combatButton" .. i,
            x = 0,
            y = 0,
            height = buttonHeight
        }, PRScombat.buttonContainer)
        PRScombat.buttons[i]:hide()
        PRScombat.buttons[i]:enableAutoAdjustSize(true, true)
        PRScombat.buttons[i]:echo(action)

        local sendAction = action
        if isInArray(sortedActions.spells, action) then
            sendAction = "cast " .. action
        end

        PRScombat.buttons[i]:setClickCallback(function()
            if gmcp.Char.battle.active and gmcp.Char.battle.myTurn then
                send(sendAction)
            else
                echo("It's not your turn! \n")
            end
        end)

        lastIndex = i
    end

    return lastIndex
end

function hideUnusedButtons(lastIndex)
    for i = lastIndex + 1, #PRScombat.buttons, 1 do
        PRScombat.buttons[i]:hide()
    end
end

local buttonHeight = 40
local buttonGap = 20
local startY = 80

function organizeButtons(actions, lastIndex)
    local currentX = 0
    local currentY = startY
    for i = 1, lastIndex, 1 do
        if actions[i] ~= "cast" then
            if currentX + PRScombat.buttons[i]:get_width() > PRScombat.buttonContainer:get_width() then
                currentX = 0
                currentY = currentY + buttonHeight
            end
            PRScombat.buttons[i]:move(currentX, currentY)
            PRScombat.buttons[i]:show()
            currentX = currentX + PRScombat.buttons[i]:get_width() + buttonGap
        end
    end
end

function setGaugeStyleSheet(gauge, color)
    gauge.front:setStyleSheet(string.format([[
      background-color: %s;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;]], color))
    gauge.back:setStyleSheet([[background-color: #303030;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 10;
      margin-right: 5px;
      padding: 3px;]])
    gauge.text:setStyleSheet([[
    padding-left: 5px;
  ]])
end

function showCombatGauges()
    -- Rage Points Gauge
    PRScombat.RPbar = PRScombat.RPbar or SUG:new({
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
    PRScombat.CPbar = PRScombat.CPbar or SUG:new({
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
    padding-left: 5px;]])
end

showCombatGauges()

if actionsEventHandlerId then
    killAnonymousEventHandler(actionsEventHandlerId)
end -- clean up any already registered handlers for this function
actionsEventHandlerId = registerAnonymousEventHandler("gmcp.Char.battle.actions", updateCombat)

if turnEventHandlerId then
    killAnonymousEventHandler(turnEventHandlerId)
end -- clean up any already registered handlers for this function
turnEventHandlerId = registerAnonymousEventHandler("gmcp.Char.battle.myTurn", updateCombat)

if battlingEventHandlerId then
    killAnonymousEventHandler(battlingEventHandlerId)
end -- clean up any already registered handlers for this function
battlingEventHandlerId = registerAnonymousEventHandler("gmcp.Char.battle.active", updateCombat)

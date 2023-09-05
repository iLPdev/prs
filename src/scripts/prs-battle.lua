PRSbattle = PRSbattle or {}
PRSbattle.scrollBox = PRSbattle.scrollBox or Geyser.ScrollBox:new({
    x = 10,
    y = 10,
    width = "95%",
    height = "95%"
}, GUI.tabwindow3.Battlecenter)

PRSbattle.container = PRSbattle.container or Geyser.HBox:new({
    x = 0,
    y = 0,
    width = "100%-20px",
    height = "100%"
}, PRSbattle.scrollBox)

PRSbattle.rightSideContainer = PRSbattle.rightSideContainer or Geyser.Container:new({
    x = 0,
    y = 0,
    width = "95%",
    height = "100%"
}, PRSbattle.container)

PRSbattle.leftSideContainer = PRSbattle.leftSideContainer or Geyser.Container:new({
    x = 0,
    y = 0,
    width = "95%",
    height = "100%"
}, PRSbattle.container)

PRSbattle.goodLabels = PRSbattle.goodLabels or {}
PRSbattle.goodBars = PRSbattle.goodBars or {}
PRSbattle.badLabels = PRSbattle.badLabels or {}
PRSbattle.badBars = PRSbattle.badBars or {}

function updateBattle()
    local participants = gmcp.Char.battle.participants
    local good = {}
    local evil = {}
    for _, participant in ipairs(participants) do
        if participant.side == "good" then
            table.insert(good, participant)
        else
            table.insert(evil, participant)
        end
    end

    updateBattleEntities(evil, PRSbattle.leftSideContainer, PRSbattle.badLabels, PRSbattle.badBars, "bad")
    updateBattleEntities(good, PRSbattle.rightSideContainer, PRSbattle.goodLabels, PRSbattle.goodBars, "good")
end

function organizeAllBattle()
    local participants = gmcp.Char.battle.participants
    local good = {}
    local evil = {}
    for _, participant in ipairs(participants) do
        if participant.side == "good" then
            table.insert(good, participant)
        else
            table.insert(evil, participant)
        end
    end

    organizeBattleEntities(evil, PRSbattle.leftSideContainer, PRSbattle.badLabels, PRSbattle.badBars)
    organizeBattleEntities(good, PRSbattle.rightSideContainer, PRSbattle.goodLabels, PRSbattle.goodBars)
end

function updateBattlingState()
    local isBattling = gmcp.Char.battle.active
    if not isBattling then
        hideAllBattleLabels()
    else
        updateBattle()
    end
end

function hideAllBattleLabels()
    for i, label in ipairs(PRSbattle.goodLabels) do
        label.main:hide()
    end
    for i, label in ipairs(PRSbattle.badLabels) do
        label.main:hide()
    end
end

PRSbattle.startY = 10
PRSbattle.startX = 10
PRSbattle.labelHeight = 100
PRSbattle.labelWidth = 200
PRSbattle.labelGapHeight = 10
PRSbattle.labelGapWidth = 20

function updateBattleEntities(participants, container, labels, bars, side)
    for i, participant in ipairs(participants) do
        labels[i] = labels[i] or {}

        labels[i].main = labels[i].main or Geyser.Label:new({
            name = "battleContainerLabel" .. side .. i,
            width = PRSbattle.labelWidth,
            height = PRSbattle.labelHeight
        }, container)

        local borderColor = ""
        local borderWidth = 1
        if participant.hp <= 0 then
            borderColor = "#666666"
        elseif participant.side == "good" and participant.isActing then
            borderColor = "#00ff00"
            borderWidth = 2
        elseif participant.side == "good" and not participant.isActing then
            borderColor = "#009900"
        elseif participant.side == "evil" and participant.isActing then
            borderColor = "#ff0000"
            borderWidth = 2
        else
            borderColor = "#990000"
        end

        labels[i].main:setStyleSheet(string.format([[
      background-color: #444;
      padding: 5px;
      border-radius: 9;
      border-width: %spx;
      border-color: %s;
      border-style: solid;
    ]], borderWidth, borderColor))
        labels[i].main:show()

        labels[i].mainText = labels[i].mainText or Geyser.Label:new({
            width = "100%",
            x = 0,
            y = 0
        }, labels[i].main)
        local affects = table.concat(participant.affects, " ")
        if participant.hp <= 0 then
            affects = "{{RDEAD"
        end
        labels[i].mainText:hecho(PRSutil.getHechoColor(participant.tag .. " " .. participant.name .. "\n{{KL{{W" ..
                                                           participant.level .. "{{w " .. affects))
        labels[i].mainText:setStyleSheet([[
      background-color: rgba(0,0,0,0%);
      padding-top: 8px;
      padding-left: 8px;
      qproperty-wordWrap: true;
      qproperty-alignment: AlignTop;
    ]])
        labels[i].mainText:adjustHeight()

        local newHeight = labels[i].mainText:get_height() + 20 + ((PRSbattle.barHeight + PRSbattle.barGap) * 3) -- (PRSbattle.barHeight + PRSbattle.barGap) * 3 + labels[i].mainText:get_height() + 20
        if participant.hp <= 0 then
            newHeight = labels[i].mainText:get_height() + 20
        end
        labels[i].main:resize(PRSbattle.labelWidth, newHeight)

        labels[i].clickable = labels[i].clickable or Geyser.Label:new({
            x = 0,
            y = 0,
            width = "100%",
            height = "100%"
        }, labels[i].main)
        labels[i].clickable:setStyleSheet([[
      background-color: rgba(0,0,0,0%);
    ]])
        local clickTarget = PRSutil.removeColor(participant.tag)
        labels[i].clickable:setClickCallback(function()
            send("target " .. clickTarget)
        end)
        labels[i].clickable:setCursor("PointingHand")

        labels[i].targetText = labels[i].targetText or Geyser.Label:new({
            x = 0,
            y = "100%-20px",
            width = "100%",
            height = 80
        }, labels[i].main)
        labels[i].targetText:move(0, "100%-40px")
        labels[i].targetText:resize("100%", 35)
        labels[i].targetText:setStyleSheet([[
      background-color: rgba(0,0,0,0%);
      padding-left: 5px;
    ]])
        local targetText = "{{w\nTarget: " .. getTargetName(participant.targetName)
        if participant.hp <= 0 then
            targetText = ""
        end
        labels[i].targetText:hecho(PRSutil.getHechoColor(targetText))

        setGaugesForParticipant(participant, labels[i], bars, i, side)
        labels[i].main:lower()
        labels[i].clickable:raise()

        if participant.hp <= 0 then
            hideBattleGauges(bars[i])
        else
            showBattleGauges(bars[i])
        end
    end

    organizeBattleEntities(participants, container, labels)
end

PRSbattle.barHeight = 15
PRSbattle.barGap = 8

function setGaugesForParticipant(participant, containerLabel, bars, i, side)
    bars[i] = bars[i] or {}
    local startY = containerLabel.mainText:get_height();
    bars[i].hpBar = createBattleGauge(participant.hp, containerLabel.main, i, bars[i].hpBar, side, "HP", "#63e2b7",
        startY)
    bars[i].enBar = createBattleGauge(participant.en, containerLabel.main, i, bars[i].enBar, side, "EN", "#70c0e8",
        startY + (PRSbattle.barHeight + PRSbattle.barGap))
    bars[i].stBar = createBattleGauge(participant.st, containerLabel.main, i, bars[i].stBar, side, "ST", "#f2c97d",
        startY + (PRSbattle.barHeight + PRSbattle.barGap) * 2)
end

function hideBattleGauges(bars)
    for _, items in pairs(bars) do
        items.container:hide()
    end
end

function showBattleGauges(bars)
    for _, items in pairs(bars) do
        items.container:show()
    end
end

function createBattleGauge(currentAmount, containerLabel, i, current, side, name, progressColor, y)
    -- box that holds the gauge and the label
    local ret = {}
    current = current or {}

    ret.container = current.container or Geyser.HBox:new({
        name = "battleProgressBox" .. side .. name .. i,
        height = PRSbattle.barHeight,
        width = "100%-16px"
    }, containerLabel)
    ret.container:move(8, y)
    ret.container:show()

    ret.progressBar = current.progressBar or Geyser.Gauge:new({
        name = "battleProgress" .. side .. name .. i,
        h_stretch_factor = 2.0
    }, ret.container)

    local c = currentAmount
    local m = 100

    if (m ~= 0) then
        -- if not dividing by 0 then set the value
        ret.progressBar:setValue(c, m)
    end

    -- set styling
    ret.progressBar.front:setStyleSheet(string.format([[
    background-color: %s;
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 3;
    margin-right: 5px;
    padding: 3px;
  ]], progressColor))
    ret.progressBar.back:setStyleSheet([[
    background-color: #444;
    border-width: 0px;
    border-color: black;
    border-style: solid;
    border-radius: 3;
    margin-right: 5px;
    padding: 3px;
  ]])

    -- create transparent label next to gauge
    ret.progressLabel = current.progressLabel or Geyser.Label:new({
        name = "battleProgressLabel" .. side .. name .. i,
        h_stretch_factor = 1.0
    }, ret.container)
    ret.progressLabel:hecho(c .. "% " .. progressColor .. name)
    ret.progressLabel:setStyleSheet([[
    background-color: rgba(0,0,0,0%);
    qproperty-alignment: AlignRight;
  ]])

    return ret
end

function organizeBattleEntities(participants, container, labels)
    local currentX = PRSbattle.startX
    local currentY = PRSbattle.startY
    for i, participant in ipairs(participants) do
        if currentX + labels[i].main:get_width() > container:get_width() and i > 1 then
            currentX = PRSbattle.startX
            currentY = currentY + labels[i - 1].main:get_height() + PRSbattle.labelGapHeight
        end

        labels[i].main:move(currentX, currentY)
        currentX = currentX + labels[i].main:get_width() + PRSbattle.labelGapWidth
    end
end

function getTargetName(name)
    if name == false then
        return "{{wNONE"
    end

    return name
end

function repositioningContainer(eventName, containerName, width, height, x, y, mouseAction)
    organizeAllBattle()
end

if PRSbattle.repositioningHandlerId then
    killAnonymousEventHandler(PRSbattle.repositioningHandlerId)
end -- clean up any already registered handlers for this function
PRSbattle.repositioningHandlerId = registerAnonymousEventHandler("AdjustableContainerRepositionFinish",
    repositioningContainer)

if PRSbattle.battlingStateHandlerId then
    killAnonymousEventHandler(PRSbattle.battlingStateHandlerId)
end -- clean up any already registered handlers for this function
PRSbattle.battlingStateHandlerId = registerAnonymousEventHandler("gmcp.Char.battle", updateBattlingState)

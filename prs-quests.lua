local colorTable = {
    ['{{r'] = '<ansi_red>',
    ['{{R'] = '<ansi_light_red>',
    ['{{g'] = '<ansi_green>',
    ['{{G'] = '<ansi_light_green>',
    ['{{y'] = '<ansi_yellow>',
    ['{{Y'] = '<ansi_light_yellow>',
    ['{{b'] = '<ansi_blue>',
    ['{{B'] = '<ansi_light_blue>',
    ['{{m'] = '<ansi_magenta>',
    ['{{M'] = '<ansi_light_magenta>',
    ['{{c'] = '<ansi_cyan>',
    ['{{C'] = '<ansi_light_cyan>',
    ['{{w'] = '<ansi_white>',
    ['{{W'] = '<ansi_light_white>',
    ['{{K'] = '<ansi_light_black>',
  }
  
  questContainerTable = questContainerTable or {}
  
  function clearContainers()
    questContainerTable = {}
  end
  
  local QUEST_LABEL_HEIGHT = 100
  local QUEST_GAP = 0 
  
  function getCechoColor(string)
    local formatted = string
    for placeholder, colorCode in pairs(colorTable) do
      formatted = formatted:gsub(placeholder, colorCode)
    end
    return formatted
  end
  
  function displayAllQuests()
    for i, quest in ipairs(gmcp.Char.quests) do
      displayQuest(i)
    end
    
    for n=#gmcp.Char.quests+1, #questContainerTable, 1 do
      echo("Hiding entry: " .. n)
      questContainerTable[n]:hide()
      questBox:remove(questContainerTable[n])
    end
  end
  
  scrollContainer = scrollContainer or Geyser.Container:new({
    name = "questScrollContainer",
    width = "90%",
    height = "90%"
  }, GUI.tabwindow2.Questscenter)
  
  questBox = questBox or Geyser.ScrollBox:new({
      name = "questScrollBox",
      height = "100%",
      width = "100%"
  }, scrollContainer)
  
  function displayQuest(questNum)
    local quest = gmcp.Char.quests[questNum]
    
    if questContainerTable[questNum] == nil then
      createNewQuestLabel(questNum)
    end
    
    questContainerTable[questNum]:show()
    questBox:add(questContainerTable[questNum])
    
    -- if questContainerTable[questNum].progressBox == nil then
      -- addGaugeToQuestLabel(questNum)
    -- end
    
    if quest.amount > 0 then
      addGaugeToQuestLabel(questNum)
      questContainerTable[questNum].progressBox:show()
      echo("Showing progress box\n")
    else
      questContainerTable[questNum].progressBox:hide()
    end
      
    questContainerTable[questNum]:cecho(getQuestString(quest))
    
  end  
  
  function createNewQuestLabel(questNum)
    echo("inserting into table\n")
    table.insert(questContainerTable, Geyser.Label:new({
        name = "questName" .. questNum,
        x = 0,
        y = (QUEST_LABEL_HEIGHT + QUEST_GAP) * (questNum - 1),
        height = QUEST_LABEL_HEIGHT,
        width = "93%"
    }, questBox))
    questContainerTable[questNum]:setFontSize(14)
    questContainerTable[questNum]:setStyleSheet([[
      border-width: 1px;
      border-color: black;
      border-style: solid;
      border-right: none;
      border-left: none;
      background-color: #222;
      padding: 10px;
    ]])
    
    addGaugeToQuestLabel(questNum)
  end
  
  function addGaugeToQuestLabel(questNum)
    local quest = gmcp.Char.quests[questNum]
  
    -- box that holds the gauge and the label
    questContainerTable[questNum].progressBox = questContainerTable[questNum].progressBox or Geyser.HBox:new({
      name = "questProgressBox" .. questNum,
      x = 12,
      y = "65%",
      height = 15,
      width = "95%"
    }, questContainerTable[questNum])
    
    questContainerTable[questNum].progressBar = questContainerTable[questNum].progressBar or Geyser.Gauge:new({
        name = "questProgress" .. questNum,
        h_stretch_factor = 3.0
    }, questContainerTable[questNum].progressBox)
    -- -- 
    local c = quest.progress
    local m = quest.amount
    
    if (m ~= 0) then
      -- if not dividing by 0 then set the value
      questContainerTable[questNum].progressBar:setValue(c, m)
    end
    
    -- set styling
    local progressColor = "#70c0e8"
    if c == m then
      progressColor = "#63e2b7"
    end
    questContainerTable[questNum].progressBar.front:setStyleSheet(string.format([[
      background-color: %s;
      border-top: 1px black solid;
      border-left: 1px black solid;
      border-bottom: 1px black solid;
      border-radius: 7;
      margin-right: 5px;
      padding: 3px;
    ]], progressColor))
    questContainerTable[questNum].progressBar.back:setStyleSheet([[
      background-color: #444;
      border-width: 0px;
      border-color: black;
      border-style: solid;
      border-radius: 7;
      margin-right: 5px;
      padding: 3px;
    ]])
    
    -- create transparent label next to gauge
    questContainerTable[questNum].progressLabel = questContainerTable[questNum].progressLabel or Geyser.Label:new({
      name = "progressLabel" .. questNum,
      h_stretch_factor = 1.0
    }, questContainerTable[questNum].progressBox)
    questContainerTable[questNum].progressLabel:echo(c .. " / " .. m)
    questContainerTable[questNum].progressLabel:setStyleSheet([[
      background-color: rgba(0,0,0,0%);
    ]])
  end
  
  function getQuestString(quest)
    local questString = "<ansi_light_white>L" .. quest.level .. " " .. getCechoColor(quest.name) 
      .. "<br> Given by: <ansi_light_yellow>" .. quest.giver.name .. "<ansi_white><br>"
    
    if (quest.location ~= nil) then
      questString = questString .. "<ansi_light_white>" .. quest.location.name .. "<ansi_white> at <ansi_light_magenta>" .. quest.location.coords.x .. "<ansi_white>, <ansi_light_magenta>" .. quest.location.coords.y .. "<ansi_white>"
    end
    
    return questString
  end
  
  function questEventHandler()
    questBox = questBox or Geyser.ScrollBox:new({
        name = "questScrollBox",
        height = "100%",
        width = "100%"
    }, scrollContainer)
    displayAllQuests()
  end
   
  if questEventHandlerId then
      killAnonymousEventHandler(questEventHandlerId)
  end -- clean up any already registered handlers for this function
  questEventHandlerId = registerAnonymousEventHandler("gmcp.Char.quests", questEventHandler)
  
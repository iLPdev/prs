questContainerTable = questContainerTable or {}
  
function clearContainers()
  questContainerTable = {}
end

local QUEST_LABEL_HEIGHT = 65
local QUEST_GAP = 0

function displayAllQuests()
  for i, quest in ipairs(gmcp.Char.quests) do
    displayQuest(i)
  end
  
  for n=#gmcp.Char.quests+1, #questContainerTable, 1 do
    questContainerTable[n]:hide()
    questBox:remove(questContainerTable[n])
  end
end

scrollContainer = scrollContainer or Geyser.Container:new({
  name = "questScrollContainer",
  x = 10,
  y = 10,
  width = "95%",
  height = "95%"
}, GUI.tabwindow2.Questscenter)

questBox = questBox or Geyser.ScrollBox:new({
    name = "questScrollBox",
    x = 0,
    y = 0,
    height = "100%",
    width = "100%"
}, scrollContainer)

function displayQuest(questNum)
  local quest = gmcp.Char.quests[questNum]
  
  createNewQuestLabel(questNum)
  
  questContainerTable[questNum]:show()
  questBox:add(questContainerTable[questNum])
  
  if quest.amount > 0 then
    questContainerTable[questNum].progressBox:show()
  else
    questContainerTable[questNum].progressBox:hide()
  end
    
  questContainerTable[questNum]:hecho(getQuestString(quest))
  
end  

function createNewQuestLabel(questNum)
  if questContainerTable[questNum] == nil then
    table.insert(questContainerTable, Geyser.Label:new({
        name = "questName" .. questNum,
        x = 0,
        y = (QUEST_LABEL_HEIGHT + QUEST_GAP) * (questNum - 1),
        height = QUEST_LABEL_HEIGHT,
        width = "100%-20px"
    }, questBox))
  end
  questContainerTable[questNum]:setStyleSheet([[
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-right: none;
    border-left: none;
    background-color: rgb(16,16,20);
    padding: 10px;
  ]])
  
  addGaugeToQuestLabel(questNum)
end

function addGaugeToQuestLabel(questNum)
  local quest = gmcp.Char.quests[questNum]

  -- box that holds the gauge and the label
  questContainerTable[questNum].progressBox = questContainerTable[questNum].progressBox or Geyser.HBox:new({
    name = "questProgressBox" .. questNum,
    x = 15,
    y = "65%",
    height = 15,
    width = "100%-20px"
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
    padding: 0px;
  ]], progressColor))
  questContainerTable[questNum].progressBar.back:setStyleSheet([[
    background-color: #444;
    border-width: 0px;
    border-color: black;
    border-style: solid;
    border-radius: 7;
    margin-right: 5px;
    padding: 0px;
  ]])
  
  -- create transparent label next to gauge
  questContainerTable[questNum].progressLabel = questContainerTable[questNum].progressLabel or Geyser.Label:new({
    name = "progressLabel" .. questNum,
    h_stretch_factor = 1.0
  }, questContainerTable[questNum].progressBox)
  questContainerTable[questNum].progressLabel:hecho(c .. " / " .. m)
  questContainerTable[questNum].progressLabel:setStyleSheet([[
    background-color: rgba(0,0,0,0%);
    margin-left: 5px;
  ]])
end

function getQuestString(quest)
  local questString = "#f9f1a5L" .. quest.level .. " " .. PRSutil.getHechoColor(quest.name) 
    .. "<br> Given by: #f9f1a5" .. quest.giver.name .. "#aaaaaa<br>"
  
  if (quest.location ~= nil) then
    questString = questString .. "#f2f2f2" .. quest.location.name .. "#aaaaaa at #b4009e" .. quest.location.coords.x .. "#aaaaaa, #b4009e" .. quest.location.coords.y .. "#aaaaaa"
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

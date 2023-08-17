
asciiMap = asciiMap or {}
asciiMap.mapContainer = asciiMap.mapContainer or Geyser.ScrollBox:new({
  x = 0,
  y = 0,
  width = "100%",
  height = "100%-30px",
}, GUI.tabwindow3.AsciiMapcenter)

asciiMap.buttonContainer = asciiMap.buttonContainer or Geyser.Label:new({
  name = "mapButtonContainer",
  x = 0,
  y = "100%-30px",
  width = "100%",
  height = "30px",
}, GUI.tabwindow3.AsciiMapcenter)
asciiMap.buttonContainer:setStyleSheet([[
  background-color: #111;
]])

asciiMap.zoomInButton = asciiMap.zoomInButton or Geyser.Label:new({
  name = "zoomInButton",
  width = 30,
  height = 30,
  x = 0,
  y = 0,
}, asciiMap.buttonContainer)
asciiMap.zoomInButton:setStyleSheet([[
  background-color: #333;
  qproperty-alignment: AlignCenter;
]])
asciiMap.zoomInButton:echo("+")
asciiMap.zoomInButton:setClickCallback("onZoomIn")

asciiMap.zoomOutButton = asciiMap.zoomOutButton or Geyser.Label:new({
  name = "zoomOutButton",
  width = 30,
  height = 30,
  x = 50,
  y = 0,
}, asciiMap.buttonContainer)
asciiMap.zoomOutButton:setStyleSheet([[
  background-color: #333;
  qproperty-alignment: AlignCenter;
]])
asciiMap.zoomOutButton:echo("-")
asciiMap.zoomOutButton:setClickCallback("onZoomOut")

asciiMap.currentZoom = 10

function setMapLabelStyleSheet()
  asciiMap.mapLabel:setStyleSheet(string.format([[
    font-family: Bitstream Vera Sans Mono;
    background-color: #111;
    font-size: %spx;
  ]], asciiMap.currentZoom))
  asciiMap.mapLabel:enableAutoAdjustSize(true, true)
end

function onZoomIn()
  asciiMap.currentZoom = asciiMap.currentZoom + 1
  setMapLabelStyleSheet()
end

function onZoomOut()
  asciiMap.currentZoom = asciiMap.currentZoom - 1  
  setMapLabelStyleSheet()
end

asciiMap.mapLabel = asciiMap.mapLabel or Geyser.Label:new({
  x = 0,
  y = 0,
  width = "100%",
  height = "100%",
}, asciiMap.mapContainer)

MAP_CMD_ID = 1
GETTING_TOO_BIG_NUMBER = 1000000
currentId = 0

function sendMapCommand()
  currentId = currentId + 1
  if currentId > GETTING_TOO_BIG_NUMBER then
    currentId = 1
  end
  send("gmcp cmd " .. MAP_CMD_ID .. currentId .. " map", false)
end

function mapEventHandler(event, args) 
  if (gmcp.Char.Output.id ~= MAP_CMD_ID .. currentId) then 
    return 
  end
  
  asciiMap.mapLabel:decho("<pre>" .. ansi2decho(gmcp.Char.Output.output) .. "</pre>")
  setMapLabelStyleSheet()
end

if map_handler_id then
  killAnonymousEventHandler(map_handler_id)
end
map_handler_id = registerAnonymousEventHandler("gmcp.Char.Output", mapEventHandler)

if send_command_handler_id then
  killAnonymousEventHandler(send_command_handler_id)
end
send_command_handler_id = registerAnonymousEventHandler("gmcp.Char.room", sendMapCommand)


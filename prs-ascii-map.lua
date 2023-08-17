
asciiMap = asciiMap or {}
asciiMap.mapContainer = asciiMap.mapContainer or Geyser.ScrollBox:new({
  x = 0,
  y = 0,
  width = "100%",
  height = "100%",
}, GUI.tabwindow3.AsciiMapcenter)

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
  asciiMap.mapLabel:setStyleSheet([[
    font-family: Bitstream Vera Sans Mono;
    background-color: #111;
    font-size: 10px;
  ]])
  asciiMap.mapLabel:enableAutoAdjustSize(true, true)
end

if map_handler_id then
  killAnonymousEventHandler(map_handler_id)
end
map_handler_id = registerAnonymousEventHandler("gmcp.Char.Output", mapEventHandler)

if send_command_handler_id then
  killAnonymousEventHandler(send_command_handler_id)
end
send_command_handler_id = registerAnonymousEventHandler("gmcp.Char.room", sendMapCommand)


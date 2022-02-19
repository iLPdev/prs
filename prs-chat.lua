MDKExample = MDKExample or {}
function MDKExample.exampleEMCO()
  local EMCO = require("MDK.emco")
  MDKExample.UW = Geyser.UserWindow:new({name = "Chat", titleText ="Procedural Realms",})
    stylesheet = [[background-color: rgb(80,80,80,255); border-width: 1px; border-style: solid; border-color: black; border-radius: 0px;]]
    istylesheet = [[background-color: rgb(60,60,60,255); border-width: 1px; border-style: solid; border-color: black; border-radius: 0px;]]
  MDKExample.EMCO = EMCO:new({
    name = "MDKExampleEMCO",
    x = "0",
    y = "0",
    width = "100%",
    height = "100%",
    allTab = true,
    allTabName = "All",
    gap = 2,
    consoleColor = "black",
    consoles = {
      "Gossip",
      "Trade",
      "Local",
      "All",
      "Map",
    },
    mapTabName = "Map",
    mapTab = true,
    activeTabCSS = stylesheet,
    inactiveTabCSS = istylesheet,
    preserveBackground = true,
    docked = true
  }, MDKExample.UW)
end

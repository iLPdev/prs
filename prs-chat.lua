PRSchat = PRSchat or {}
function PRSchat.tabs()
  local EMCO = require("MDK.emco")
  PRSchat.UW = Geyser.UserWindow:new({name = "Chat", titleText ="Procedural Realms", docked = true})
    stylesheet = [[background-color: rgb(80,80,80,255); border-width: 1px; border-style: solid; border-color: black; border-radius: 0px;]]
    istylesheet = [[background-color: rgb(60,60,60,255); border-width: 1px; border-style: solid; border-color: black; border-radius: 0px;]]
  PRSchat.EMCO = EMCO:new({
    name = "PRSchatTabs",
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
      "Newbie",
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
  }, PRSchat.UW)
end


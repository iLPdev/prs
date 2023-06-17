-- Procedural Realms Script (PRS) Graphical User Interface (GUI) for Mudlet
-- by Stack (https://ilpdev.com/prs)
GUI = GUI or {}

-------[ Skin Mudlet Toolbar ]-----------------------------
setAppStyleSheet([[
QToolBar {
  background-color: rgb(24,24,28);
}

QToolBar QToolButton:!hover {
  color: white;
}
QToolBar QToolButton:hover {
  color: black;
}
]])

require "PRS.AdjustableTabWindow" -- PR-specific version of edru's code

-------[ Spawn the Adjustable Containers ]-----------------------------
GUI.top = Adjustable.Container:new({
    name = "top",
    y = "0%",
    height = "10%",
    adjLabelstyle = "border: 1px solid green;",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.bottom = Adjustable.Container:new({
    name = "bottom",
    height = "10%",
    y = "-10%",
    adjLabelstyle = "border: 1px solid green;",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.right_top = Adjustable.Container:new({
    name = "right_top",
    x = "-20%",
    y = "0%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 1px solid green;",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.right_bottom = Adjustable.Container:new({
    name = "right_bottom",
    x = "-20%",
    y = "50%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 1px solid green;",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.left_top = Adjustable.Container:new({
    name = "left_top",
    x = "0%",
    y = "0%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 1px solid green;",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.left_bottom = Adjustable.Container:new({
    name = "left_bottom",
    x = "0%",
    y = "50%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 1px solid green;",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

Adjustable.Container:doAll(function(self) -- add connect menu to all adjustable containers 
    self:addConnectMenu()
end)

-------[ Attach and Connect Borders of Adjustable Containers ]-----------------
GUI.top:attachToBorder("top")
GUI.bottom:attachToBorder("bottom")
GUI.left_top:attachToBorder("left")
GUI.left_bottom:attachToBorder("left")
GUI.right_top:attachToBorder("right")
GUI.right_bottom:attachToBorder("right")

GUI.top:connectToBorder("left")
GUI.top:connectToBorder("right")
GUI.bottom:connectToBorder("left")
GUI.bottom:connectToBorder("right")
GUI.left_top:connectToBorder("left")
GUI.left_bottom:connectToBorder("left")
GUI.right_top:connectToBorder("right")
GUI.right_bottom:connectToBorder("right")

GUI.top:changeMenuStyle("dark")
GUI.bottom:changeMenuStyle("dark")
GUI.right_top:changeMenuStyle("dark")
GUI.right_bottom:changeMenuStyle("dark")
GUI.left_top:changeMenuStyle("dark")
GUI.left_bottom:changeMenuStyle("dark")

GUI.top:newCustomItem("PRS Version", function(self)
    send("chat I'm running PRS v1.7.0 on Mudlet")
    self:flash()
end)

-------[ Add TabWindows to Adjustable Containers ]-----------------------------
GUI.tabwindow1 = GUI.tabwindow1 or Adjustable.TabWindow:new({
    name = "tabwindow1",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    tabBarHeight = "10%",
    activeTabFGColor = "#DDDDDD",
    inactiveTabFGColor = "#555555",
    color1 = "rgb(24,24,28)",
    color2 = "rgb(16,16,20)",
    tabs = {"Vitals", "Effects", "Skills"}
}, GUI.left_top)

GUI.tabwindow2 = GUI.tabwindow2 or Adjustable.TabWindow:new({
    name = "tabwindow2",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    tabBarHeight = "10%",
    activeTabFGColor = "#DDDDDD",
    inactiveTabFGColor = "#555555",
    color1 = "rgb(24,24,28)",
    color2 = "rgb(16,16,20)",
    tabs = {"Combat", "Quests"}
}, GUI.left_bottom)

GUI.tabwindow3 = GUI.tabwindow3 or Adjustable.TabWindow:new({
    name = "tabwindow3",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    tabBarHeight = "10%",
    activeTabFGColor = "#DDDDDD",
    inactiveTabFGColor = "#555555",
    color1 = "rgb(24,24,28)",
    color2 = "rgb(16,16,20)",
    tabs = {"Map", "Inventory", "Equipment", "Statistics"}
}, GUI.right_top)

GUI.tabwindow4 = GUI.tabwindow4 or Adjustable.TabWindow:new({
    name = "tabwindow4",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
    tabBarHeight = "10%",
    activeTabFGColor = "#DDDDDD",
    inactiveTabFGColor = "#555555",
    color1 = "rgb(24,24,28)",
    color2 = "rgb(16,16,20)",
    tabs = {"ASCII"}
}, GUI.right_bottom)

GUI.buttons = Geyser.HBox:new({
    name = "buttons",
    height = "25",
    width = "98%"
}, GUI.top)
local buttonstyle = Geyser.StyleSheet:new([[
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
]])
local button1 = Geyser.Label:new({
    name = "button1",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>1</center>]]
}, GUI.buttons)
button1:setClickCallback("slot1")
function slot1()
    send("1")
end
local button2 = Geyser.Label:new({
    name = "button2",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>2</center>]]
}, GUI.buttons)
button2:setClickCallback("slot2")
function slot2()
    send("2")
end
local button3 = Geyser.Label:new({
    name = "button3",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>3</center>]]
}, GUI.buttons)
button3:setClickCallback("slot3")
function slot3()
    send("3")
end
local button4 = Geyser.Label:new({
    name = "button4",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>4</center>]]
}, GUI.buttons)
button4:setClickCallback("slot4")
function slot4()
    send("4")
end
local button5 = Geyser.Label:new({
    name = "button5",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>5</center>]]
}, GUI.buttons)
button5:setClickCallback("slot5")
function slot5()
    send("5")
end
local button6 = Geyser.Label:new({
    name = "button6",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>6</center>]]
}, GUI.buttons)
button6:setClickCallback("slot6")
function slot6()
    send("6")
end
local button7 = Geyser.Label:new({
    name = "button7",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>7</center>]]
}, GUI.buttons)
button7:setClickCallback("slot7")
function slot7()
    send("7")
end
local button8 = Geyser.Label:new({
    name = "button8",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>8</center>]]
}, GUI.buttons)
button8:setClickCallback("slot8")
function slot8()
    send("8")
end
local button9 = Geyser.Label:new({
    name = "button9",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>9</center>]]
}, GUI.buttons)
button9:setClickCallback("slot9")
function slot9()
    send("9")
end
local button10 = Geyser.Label:new({
    name = "button0",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>0</center>]]
}, GUI.buttons)
button10:setClickCallback("slot10")
function slot10()
    send("0")
end
local button11 = Geyser.Label:new({
    name = "button11",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>-</center>]]
}, GUI.buttons)
button11:setClickCallback("slot11")
function slot11()
    send("-")
end
local button12 = Geyser.Label:new({
    name = "button12",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>=</center>]]
}, GUI.buttons)
button12:setClickCallback("slot12")
function slot12()
    send("=")
end
local button13 = Geyser.Label:new({
    name = "vote",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>Vote!</center>]]
}, GUI.buttons)
button13:setClickCallback("vote")
function vote()
    openUrl("https://www.mudverse.com/vote/531")
end

-------[ Spawn Mudlet Mapper ]---------------------------------
GUI.mapper = GUI.mapper or Geyser.Mapper:new({
    name = "mapper",
    x = 5,
    y = 5,
    width = "96%",
    height = "97%"
}, GUI.tabwindow3.Mapcenter)

-------[ Save/Load User Tab Prefs ]-----------------------------
GUI.tabwindow1:load(1, string.format("%s/PRS/settings/", getMudletHomeDir())) -- Load all tabs

function SaveTabsOnExit()
    GUI.tabwindow1:save(1, string.format("%s/PRS/settings/", getMudletHomeDir())) -- Save all tabs on exit
end
registerAnonymousEventHandler("sysExitEvent", SaveTabsOnExit)

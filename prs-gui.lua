-- Procedural Realms Script (PRS) Graphical User Interface (GUI) for Mudlet
-- by Stack (https://ilpdev.com/prs)
GUI = GUI or {}

-- Skin Mudlet Toolbar
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

GUI.top = Adjustable.Container:new({
    name = "top",
    y = "0%",
    height = "10%",
    adjLabelstyle = "border: 5px solid rgb(16,16,20,50);",
    titleTxtColor = "#161620",
    buttonstyle = "rectangular",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.bottom = Adjustable.Container:new({
    name = "bottom",
    height = "10%",
    y = "-10%",
    adjLabelstyle = "border: 5px solid rgb(16,16,20,50);",
    titleTxtColor = "#161620",
    buttonstyle = "rectangular",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.right_top = Adjustable.Container:new({
    name = "right_top",
    x = "-20%",
    y = "0%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 5px solid rgb(16,16,20,50);",
    titleTxtColor = "#161620",
    buttonstyle = "rectangular",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.right_bottom = Adjustable.Container:new({
    name = "right_bottom",
    x = "-20%",
    y = "50%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 5px solid rgb(16,16,20,50);",
    titleTxtColor = "#161620",
    buttonstyle = "rectangular",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.left_top = Adjustable.Container:new({
    name = "left_top",
    x = "0%",
    y = "0%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 5px solid rgb(16,16,20,50);",
    titleTxtColor = "#161620",
    buttonstyle = "rectangular",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.left_bottom = Adjustable.Container:new({
    name = "left_bottom",
    x = "0%",
    y = "50%",
    height = "50%",
    width = "20%",
    adjLabelstyle = "border: 5px solid rgb(16,16,20,50);",
    titleTxtColor = "#161620",
    buttonstyle = "rectangular",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

Adjustable.Container:doAll(function(self)
    self:addConnectMenu()
end)

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
local button2 = Geyser.Label:new({
    name = "button2",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>2</center>]]
}, GUI.buttons)
local button3 = Geyser.Label:new({
    name = "button3",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>3</center>]]
}, GUI.buttons)
local button4 = Geyser.Label:new({
    name = "button4",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>4</center>]]
}, GUI.buttons)
local button5 = Geyser.Label:new({
    name = "button5",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>5</center>]]
}, GUI.buttons)
local button6 = Geyser.Label:new({
    name = "button6",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>6</center>]]
}, GUI.buttons)
local button7 = Geyser.Label:new({
    name = "button7",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>7</center>]]
}, GUI.buttons)
local button8 = Geyser.Label:new({
    name = "button8",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>8</center>]]
}, GUI.buttons)
local button9 = Geyser.Label:new({
    name = "button9",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>9</center>]]
}, GUI.buttons)
local button10 = Geyser.Label:new({
    name = "button0",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>0</center>]]
}, GUI.buttons)
local button11 = Geyser.Label:new({
    name = "button11",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>-</center>]]
}, GUI.buttons)
local button12 = Geyser.Label:new({
    name = "button12",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>=</center>]]
}, GUI.buttons)
local button13 = Geyser.Label:new({
    name = "vote",
    stylesheet = buttonstyle:getCSS(),
    message = [[<center>Vote!</center>]]
}, GUI.buttons)

GUI.mapper = GUI.mapper or Geyser.Mapper:new({
    name = "mapper",
    x = 5,
    y = 5,
    width = "96%",
    height = "97%"
}, GUI.tabwindow3.Mapcenter)

GUI.tabwindow1:load(1, string.format("%s/PRS/settings/", getMudletHomeDir())) -- Load all tabs

function SaveTabsOnExit()
    GUI.tabwindow1:save(1, string.format("%s/PRS/settings/", getMudletHomeDir())) -- Save all tabs on exit
end
registerAnonymousEventHandler("sysExitEvent", SaveTabsOnExit)

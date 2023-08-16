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
    tabs = {"Vitals", "Stats"}
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
    tabs = {"Map"}
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
    tabs = {}
}, GUI.right_bottom)

-------[ Buttons ]-------------------------------------------------------------
GUI.buttons = Geyser.HBox:new({
    name = "buttons",
    height = "25",
    width = "98%"
}, GUI.top)

local button1 = Geyser.Label:new({
    name = "button1",
    message = [[<center>1</center>]]
}, GUI.buttons)
button1:setClickCallback("slot1")
button1:setToolTip("[F1]", "10")
button1:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot1()
    send("1")
end

local button2 = Geyser.Label:new({
    name = "button2",
    message = [[<center>2</center>]]
}, GUI.buttons)
button2:setClickCallback("slot2")
button2:setToolTip("[F2]", "10")
button2:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot2()
    send("2")
end

local button3 = Geyser.Label:new({
    name = "button3",
    message = [[<center>3</center>]]
}, GUI.buttons)
button3:setClickCallback("slot3")
button3:setToolTip("[F3]", "10")
button3:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot3()
    send("3")
end

local button4 = Geyser.Label:new({
    name = "button4",
    message = [[<center>4</center>]]
}, GUI.buttons)
button4:setClickCallback("slot4")
button4:setToolTip("[F4]", "10")
button4:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot4()
    send("4")
end

local button5 = Geyser.Label:new({
    name = "button5",
    message = [[<center>5</center>]]
}, GUI.buttons)
button5:setClickCallback("slot5")
button5:setToolTip("[F5]", "10")
button5:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot5()
    send("5")
end

local button6 = Geyser.Label:new({
    name = "button6",
    message = [[<center>6</center>]]
}, GUI.buttons)
button6:setClickCallback("slot6")
button6:setToolTip("[F6]", "10")
button6:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot6()
    send("6")
end

local button7 = Geyser.Label:new({
    name = "button7",
    message = [[<center>7</center>]]
}, GUI.buttons)
button7:setClickCallback("slot7")
button7:setToolTip("[F7]", "10")
button7:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot7()
    send("7")
end

local button8 = Geyser.Label:new({
    name = "button8",
    message = [[<center>8</center>]]
}, GUI.buttons)
button8:setClickCallback("slot8")
button8:setToolTip("[F8]", "10")
button8:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot8()
    send("8")
end

local button9 = Geyser.Label:new({
    name = "button9",
    message = [[<center>9</center>]]
}, GUI.buttons)
button9:setClickCallback("slot9")
button9:setToolTip("[F9]", "10")
button9:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot9()
    send("9")
end

local button10 = Geyser.Label:new({
    name = "button10",
    message = [[<center>0</center>]]
}, GUI.buttons)
button10:setClickCallback("slot10")
button10:setToolTip("[F10]", "10")
button10:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot10()
    send("0")
end

local button11 = Geyser.Label:new({
    name = "button11",
    message = [[<center>-</center>]]
}, GUI.buttons)
button11:setClickCallback("slot11")
button11:setToolTip("[F11]", "10")
button11:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot11()
    send("-")
end

local button12 = Geyser.Label:new({
    name = "button12",
    message = [[<center>=</center>]]
}, GUI.buttons)
button12:setClickCallback("slot12")
button12:setToolTip("[F12]", "10")
button12:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
function slot12()
    send("=")
end

local button13 = Geyser.Label:new({
    name = "vote",
    message = [[<center>Vote!</center>]]
}, GUI.buttons)
button13:setClickCallback("vote")
button13:setToolTip("Vote for PR daily!", "10")
button13:setStyleSheet([[
    QLabel { 
    background-color: rgb(16,16,20);
    border: 1px solid black;
    border-radius: 3px;
    }
    QLabel::hover {
    background-color: rgb(24,24,28);
    border: 1px solid black;
    border-radius: 3px;
    } 
]])
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

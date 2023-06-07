-- Procedural Realms Script (PRS) Graphical User Interface (GUI) by Stack
GUI = GUI or {}

require "PRS.AdjustableTabWindow"

GUI.top = Adjustable.Container:new({
    name = "top",
    y = "0%",
    height = "20%",
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

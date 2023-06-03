-- Procedural Realms Script (PRS) Graphical User Interface (GUI) by Stack
GUI = GUI or {}

GUI.top = Adjustable.Container:new({
    name = "top",
    y = "0%",
    height = "10%",
    lockStyle = "border",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.bottom = Adjustable.Container:new({
    name = "bottom",
    height = "20%",
    y = "-20%",
    lockStyle = "border",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.right = Adjustable.Container:new({
    name = "right",
    y = "0%",
    height = "100%",
    x = "-20%",
    width = "20%",
    lockStyle = "border",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})
GUI.left = Adjustable.Container:new({
    name = "left",
    x = "0%",
    y = "0%",
    height = "100%",
    width = "20%",
    lockStyle = "border",
    defaultDir = string.format("%s/PRS/settings/", getMudletHomeDir())
})

GUI.top:attachToBorder("top")
GUI.bottom:attachToBorder("bottom")
GUI.left:attachToBorder("left")
GUI.right:attachToBorder("right")

GUI.top:connectToBorder("left")
GUI.top:connectToBorder("right")
GUI.bottom:connectToBorder("left")
GUI.bottom:connectToBorder("right")

GUI.top:changeMenuStyle("dark")
GUI.bottom:changeMenuStyle("dark")
GUI.right:changeMenuStyle("dark")
GUI.left:changeMenuStyle("dark")

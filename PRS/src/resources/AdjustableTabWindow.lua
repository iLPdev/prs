-- Adjustable TabWindow
-- TabWindow code by Mudlet Wiki
-- other functions
-- by Edru 10th October 2020
-- https://github.com/Edru2/AdjustableTabWindow 
Adjustable = Adjustable or {}
Adjustable.TabWindow = Adjustable.TabWindow or Geyser.Container:new({
    name = "AdjustableTabWindowClass"
})
local tab_pos = nil

-- Geyser.Label echo function overwritten to not have the color function in it
-- needed for allowing stylesheet to control the text color
local function noColorEcho(self, message, color, format)
    message = message or self.message
    self.message = message
    if format then
        self:processFormatString(format)
    end

    local ft = self.formatTable
    local fs = ft.fontSize
    local alignment = ft.alignment
    if alignment ~= "" then
        alignment = string.format([[align="%s" ]], alignment)
    end
    if ft.bold then
        message = "<b>" .. message .. "</b>"
    end
    if ft.italics then
        message = "<i>" .. message .. "</i>"
    end
    if ft.underline then
        message = "<u>" .. message .. "</u>"
    end
    if ft.strikethrough then
        message = "<s>" .. message .. "</s>"
    end
    if self.font and self.font ~= "" then
        message = string.format('<font face ="%s">%s</font>', self.font, message)
    end
    if not fs then
        fs = tostring(self.fontSize)
    end
    fs = "font-size: " .. fs .. "pt; "
    message = [[<div ]] .. alignment .. [[ style=" ]] .. fs .. [[">]] .. message .. [[</div>]]
    echo(self.name, message)
end

function Adjustable.TabWindow:createBaseContainers()
    self.tabBar = self.tabBar or Geyser.Label:new({
        name = self.name .. "tabBar",
        x = 0,
        y = 0,
        width = "100%",
        height = self.tabBarHeight
    }, self)
    self.tabBar:setStyleSheet(self.tabBarStyle)

    self.header = self.header or Geyser.HBox:new({
        name = self.name .. "header",
        x = 0,
        y = 0,
        width = "100%",
        height = "100%"
    }, self.tabBar)

    self.overlay = self.overlay or Geyser.Label:new({
        name = self.name .. "overlay",
        x = 0,
        y = 0,
        width = "100%",
        height = "100%"
    }, self.tabBar)

    self.overlay:setStyleSheet(self.overlayStyle)
    self.overlay:setMoveCallback(function(event)
        self:onOverlayMove(event)
    end)
    self.overlay:setOnLeave(function(event)
        self:onOverlayLeave(event)
    end)
    self.overlay:setClickCallback(function(event)
        self:onOverlayClick(event)
    end)
    self.overlay:hide()

    self.footerContainer = self.footerContainer or Geyser.Container:new({
        name = self.name .. "footerContainer",
        x = 0,
        y = self.tabBarHeight,
        width = "100%",
        height = "-0"
    }, self)

    self.footer = self.footer or Geyser.Label:new({
        name = self.name .. "footer",
        x = 0,
        y = self.gap,
        width = "100%",
        height = "-0"
    }, self.footerContainer)

    self.footer:setStyleSheet(self.footerStyle)
end

local function setTabToolTip(tab)
    -- put ToolTip on Label if TabText is to long to display
    local w, h = calcFontSize(tab.adjLabel.fontSize)
    local txt_width = #tab.tabText * w
    if tab.adjLabel:get_width() < txt_width then
        tab.adjLabel:setToolTip(tab.tabText)
    else
        tab.adjLabel:resetToolTip()
    end
end

-- function to create new tabs in tabs table or to rewrite/readjust them
function Adjustable.TabWindow:createTabs()
    for k, v in ipairs(self.tabs) do
        self[v .. "center"] = self[v .. "center"] or Geyser.Label:new({
            name = v .. "center",
            x = 0,
            y = 0,
            width = "100%",
            height = "100%"
        }, self.footer)

        self[v .. "center"]:setStyleSheet(self.centerStyle)

        local tabText = self[v] and self[v].tabText or v

        self[v] = self[v] or Adjustable.Container:new({
            name = self.name .. " Tab: " .. v,
            tabname = v,
            origin = self,
            noLimit = true,
            tabText = tabText,
            padding = 0,
            locked = true,
            autoSave = false,
            autoLoad = false,
            raiseOnClick = false,
            adjLabelstyle = self.inactiveTabStyle,
            titleTxtColor = self.tabTxtColor

        }, self.header)

        self[v].adjLabel.echo = noColorEcho
        self[v]:setTitle(tabText)
        self[v]:newLockStyle("tab", function(self)
            self.Inside:resize("-" .. self.padding, "-" .. self.padding)
            self.Inside:move(self.padding, self.padding * 2)
        end)

        self[v].lockStyle = "tab"

        self[v].unlockContainer = function()
            Adjustable.Container.unlockContainer(self[v])
            self[v].adjLabel:echo(self[v].tabText, nil, "c")
        end

        Adjustable.TabWindow.allTabs[v] = self

        self[v]:newCustomItem("Tabify", function()
            Adjustable.TabWindow.allTabs[v]:createTempWindow(self[v])
        end)

        self[v].reposition = self.reposition
        local delIndex = table.index_of(Adjustable.Container.all_windows, self[v].name)
        if delIndex then
            table.remove(Adjustable.Container.all_windows, delIndex)
        end
        Adjustable.Container.all[self[v].name] = nil
        self[v].adjLabelstyle = self.inactiveTabStyle
        self[v].titleTxtColor = self.tabTxtColor
        self[v].adjLabel:setStyleSheet(self.inactiveTabStyle)

        self[v].adjLabel:echo(self[v].tabText, nil, "c")
        self[v].adjLabel:setClickCallback(function(event)
            self:onClick(v, event)
        end)
        self[v].adjLabel:setReleaseCallback(function(event)
            self:onRelease(v, event)
        end)
        self[v].adjLabel:setMoveCallback(function(event)
            self:onMove(v, event)
        end)
        self[v].adjLabel:setDoubleClickCallback(function(event)
            self:onDoubleClick(v, event)
        end)
        self[v].minimizeLabel:setClickCallback(function()
            self:onMinimizeClick(v)
        end)
        self[v].minimizeLabel:echo("<center>🗗</center>")
        self[v].minLabel:setClickCallback(function()
            self:onMinimizeClick(v)
        end)
        self[v .. "center"]:hide()
        -- put ToolTip on Label if TabText is to long to display
        setTabToolTip(self[v])
    end
end

--- Sets the amount of space to use between the tabs and the consoles
-- @tparam number gap Number of pixels to keep between the tabs and consoles
function Adjustable.TabWindow:setGap(gap)
    local gapNumber = tonumber(gap)
    local gapType = type(gap)
    assert(gapType == "number", "gap expected as number, got " .. gapType)
    self.gap = gapNumber
    self.footer:move(0, gapNumber)
end

--- Sets the height of the tabs in pixels/percent
-- @tparam number tabHeight the height of the tabs for the object, in pixels/percent
function Adjustable.TabWindow:setTabHeight(tabHeight)
    self.tabBarHeight = tabHeight
    self.tabBar:resize("100%", tabHeight)
    self.footerContainer:move(0, tabHeight)
    self.footerContainer:resize("100%", "-0")
end

--- Sets the CSS to use for the tab box which contains the tabs for the object
-- @tparam string css The css styling to use for the tab box
function Adjustable.TabWindow:setTabBarCSS(css)
    local cssType = type(css)
    assert(cssType == "string", "css as string expected, got " .. cssType)
    self.tabBarStyle = css
    self.tabBar:setStyleSheet(self.tabBarStyle)
end

--- Sets the color to use for the tab box background
-- @param color Color string suitable for decho or hecho, or color name eg "purple", or table of colors {r,g,b}
function Adjustable.TabWindow:setTabBarColor(color)
    self.tabBarColor = color
    self.tabBarStyle = ""
    self.tabBar:setStyleSheet(self.tabBarStyle)
    self.tabBar:setColor(self.tabBarColor)
end

--- Sets the FG color for the active tab
-- @param color Color string suitable for decho or hecho, or color name eg "purple", or table of colors {r,g,b}
function Adjustable.TabWindow:setActiveTabFGColor(color)
    local found
    local add_css
    local r, g, b = Geyser.Color.parse(color)
    local rgb = string.format("rgb(%s, %s, %s)", r, g, b)
    self.activeTabFGColor = color
    self.activeTabStyle, found = string.gsub(" " .. self.activeTabStyle, "(%scolor:).-(;)", "%1" .. rgb .. "%2")
    if found == 0 then
        if string.match(self.activeTabStyle, "QLabel{") then
            add_css = "\nQLabel{color:" .. rgb .. ";}"
        else
            add_css = "\ncolor:" .. rgb .. ";"
        end
        self.activeTabStyle = self.activeTabStyle .. add_css
    end
    self:adjustTabStyle()
end

--- Sets the FG color for the inactive tab
-- @param color Color string suitable for decho or hecho, or color name eg "purple", or table of colors {r,g,b}
function Adjustable.TabWindow:setInactiveTabFGColor(color)
    local found
    local add_css
    self.inactiveTabFGColor = color
    local r, g, b = Geyser.Color.parse(color)
    local rgb = string.format("rgb(%s, %s, %s)", r, g, b)

    self.inactiveTabStyle, found = string.gsub(" " .. self.inactiveTabStyle, "(%scolor:).-(;)", "%1" .. rgb .. "%2")
    if found == 0 then
        if string.match(self.inactiveTabStyle, "QLabel{") then
            add_css = "\nQLabel{color:" .. rgb .. ";}"
        elseif string.match(self.inactiveTabStyle, "QLabel::!hover{") then
            add_css = ""
            self.inactiveTabStyle = string.gsub(self.inactiveTabStyle, "(QLabel::!.-)(})",
                "%1" .. "color:" .. rgb .. ";" .. "%2")
        else
            add_css = "\ncolor:" .. rgb .. ";"
        end
        self.inactiveTabStyle = self.inactiveTabStyle .. add_css
    end
    self:adjustTabStyle()
end

--- Sets the BG color for the active tab.
-- <br>NOTE: If you set CSS for the active tab, it will override this setting.
-- @param color Color string suitable for decho or hecho, or color name eg "purple", or table of colors {r,g,b}
function Adjustable.TabWindow:setActiveTabBGColor(color)
    self.activeTabBGColor = color
    local r, g, b = Geyser.Color.parse(color)
    local rgba = string.format("rgba(%s, %s, %s, %s)", r, g, b, "100%%")
    self.activeTabStyle = string.gsub(self.activeTabStyle, "(background%-color:.-).-(;)", "%1 " .. rgba .. "%2")
    self:adjustTabStyle()
end

--- Sets the BG color for the inactive tab.
-- <br>NOTE: If you set CSS for the inactive tab, it will override this setting.
-- @param color Color string suitable for decho or hecho, or color name eg "purple", or table of colors {r,g,b}
function Adjustable.TabWindow:setInactiveTabBGColor(color)
    self.inactiveTabBGColor = color
    local r, g, b = Geyser.Color.parse(color)
    local rgba = string.format("rgba(%s, %s, %s, %s)", r, g, b, "100%%")
    self.inactiveTabStyle = string.gsub(self.inactiveTabStyle, "(background%-color:.-).-(;)", "%1 " .. rgba .. "%2")
    self:adjustTabStyle()
end

function Adjustable.TabWindow:adjustTabStyle()
    local abg_rgb = string.match(self.activeTabBGColor, "%d+.-%d+.-%d+")
    local ibg_rgb = string.match(self.inactiveTabBGColor, "%d+.-%d+.-%d+")
    for k, v in ipairs(self.tabs) do
        if v == self.current then
            self[v].adjLabelstyle = self.activeTabStyle
            self[v].adjLabel:setStyleSheet(self.activeTabStyle)
            if abg_rgb then
                self[v].adjLabel:setColor("<" .. abg_rgb .. ">")
            else
                self[v].adjLabel:setColor(self.activeTabBGColor)
            end
        else
            self[v].adjLabelstyle = self.inactiveTabStyle
            self[v].adjLabel:setStyleSheet(self.inactiveTabStyle)
            if ibg_rgb then
                self[v].adjLabel:setColor("<" .. ibg_rgb .. ">")
            else
                self[v].adjLabel:setColor(self.inactiveTabBGColor)
            end
        end
    end
end

--- sets the font for all tabs
--- @tparam string font the font to use.
function Adjustable.TabWindow:setTabFont(font)
    self.tabFont = font
    for k, v in ipairs(self.tabs) do
        self[v].adjLabel:setFont(font)
    end
end

--- sets the font for a single tab. If you use setTabFont this will be overridden
--- @tparam string tabName the tab to change the font of
--- @tparam string font the font to use for that tab
function Adjustable.TabWindow:setSingleTabFont(tabName, font)
    local funcName = "EMCO:setSingleTabFont(tabName, font)"
    if not table.contains(self.tabs, tabName) then
        error("tabName must be an existing tab")
    end
    self[tabName].adjLabel:setFont(font)
end

-- finds the right position to drop the tab into
function Adjustable.TabWindow:findPosition(tab)
    local myWindow = Adjustable.TabWindow.currentWindow or self
    local x, w = myWindow.get_x(), myWindow.get_width()
    local total = w / #myWindow.tabs
    local tab_x = tab.get_x() - x
    local position = (tab_x / total) + 1
    position = math.floor(position + 0.5)
    if position < 1 then
        position = 1
    end
    if position > #myWindow.tabs then
        position = #myWindow.tabs + 1
    end
    return position
end

-- checks if 2 elements collide
local function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    if x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1 then
        return true
    end
end

local function getFloatingWindows()
    local floatingWindows = {}
    for k, v in pairs(Adjustable.TabWindow.allTabs) do
        if v[k].floating then
            floatingWindows[k] = v[k]
        end
    end
    return floatingWindows

end

-- checks if your tab collides with one of the tabwindows
function Adjustable.TabWindow:checkMultiCollision(tab)
    local floatingWindows = getFloatingWindows()
    local x1, y1, w1, h1 = tab:get_x(), tab:get_y(), tab:get_width(), tab:get_height()
    for k, v in pairs(floatingWindows) do
        local x2, y2, w2, h2 = v:get_x(), v:get_y(), v:get_width(), v:get_height()
        if checkCollision(x1, y1, w1, h1, x2, y2, w2, h2) and v.windowname == self.windowname and
            not (v.hidden or v.auto_hidden) and not (v == tab) and not v.locked then
            return "floating", v
        end
    end
    for k, v in pairs(Adjustable.TabWindow.all) do
        local x2, y2, w2, h2 = v:get_x(), v:get_y(), v:get_width(), v:get_height()

        if checkCollision(x1, y1, w1, h1, x2, y2, w2, h2) and v.windowname == self.windowname and
            not (v.hidden or v.auto_hidden) then
            return "TabWindow", v
        end
    end
end

-- onMove function
-- contains all the functionality to move the tab (collision check, make space ...)
function Adjustable.TabWindow:onMove(tab, event)
    self[tab]:onMove(self[tab].adjLabel, event)
    self[tab].adjLabel:setAlignment("c")
    if self[tab].floating or not Adjustable.TabWindow.clicked then
        return
    end
    local result, value = self:checkMultiCollision(self[tab])
    if Adjustable.TabWindow.currentWindow and Adjustable.TabWindow.currentWindow ~= value and
        not Adjustable.TabWindow.currentWindow.floating then
        -- reset the tab space
        self:makeSpace(Adjustable.TabWindow.currentWindow, nil, true)
    end
    if result == "TabWindow" then
        Adjustable.TabWindow.currentWindow = value
        tab_pos = value:findPosition(self[tab])
        self:makeSpace(value, tab_pos)
        return
    end
    if result == "floating" and not (value.locked) then
        Adjustable.TabWindow.currentWindow = value
        return
    end
    if Adjustable.TabWindow.currentWindow then
        Adjustable.TabWindow.currentWindow = nil
    end
end

--- Transforms a floating Tab into a temporary TabWindow
-- @tparam tab the tab which will be transformed
function Adjustable.TabWindow:createTempWindow(tab, tempName)
    if tab and not (tab.floating) then
        return
    end

    local rnd_nr = 0
    for i = 0, #Adjustable.TabWindow.all_windows do
        if not Adjustable.TabWindow.all["tempTabWindow" .. i] then
            rnd_nr = i
            break
        end
    end

    local window = tab and tab.windowname ~= "main" and
                       Geyser.windowList[tab.windowname .. "Container"].windowList[tab.windowname] or Geyser
    local tempWindowName = tempName and "tempWindow" .. string.match(tempName, "%d+") or "tempWindow" .. rnd_nr
    local tempTabWindowName = tempName or "tempTabWindow" .. rnd_nr
    local x, y, width, height = 0, 0, 100, 100
    if tab then
        x, y, width, height = tab:get_x(), tab:get_y(), tab:get_width(), tab:get_height()
    end
    local tempWindowConf = {
        name = tempWindowName,
        titleText = "",
        x = x,
        y = y,
        width = width,
        height = height,
        autoSave = false,
        autoLoad = false
    }
    tempWindowConf = table.union(tempWindowConf, self.tempWindowConf)

    local windowCont = Adjustable.Container:new(tempWindowConf)
    windowCont:move(x, y)
    windowCont:resize(width, height)
    table.remove(Adjustable.Container.all_windows, table.index_of(Adjustable.Container.all_windows, windowCont.name))
    Adjustable.Container.all[windowCont.name] = nil

    local tabWindow = Adjustable.TabWindow:new({
        name = tempTabWindowName,
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
        tabTxtColor = self.tabTxtColor,
        tabPadding = self.tabPadding,
        activeTabFGColor = self.activeTabFGColor,
        inactiveTabFGColor = self.inactiveTabFGColor,
        activeTabBGColor = self.activeTabBGColor,
        inactiveTabBGColor = self.inactiveTabBGColor,
        tabBarColor = self.tabBarColor,
        tabBarStyle = self.tabBarStyle,
        color1 = self.color1,
        color2 = self.color2,
        tabBarHeight = self.tabBarHeight,
        footerStyle = self.footerStyle,
        centerStyle = self.centerStyle,
        inactiveTabStyle = self.inactiveTabStyle,
        activeTabStyle = self.activeTabStyle,
        chosenTabStyle = self.chosenTabStyle,
        overlayStyle = self.overlayStyle,
        gap = self.gap,
        temporary = true
    }, windowCont)

    -- save name to get the style on loading
    tabWindow.tempStyle = self.tempStyle or self.name
    if tab then
        self:restoreTab(tab.tabname, tabWindow)
        tab.tempWindow = windowCont
        tab.tempTabWindow = tabWindow
        tab.tempWindow:changeContainer(window)
        tab.tempWindow:setPercent(true, true)
    end
    windowCont:show()
    windowCont.tabWindow = tabWindow
    return windowCont
end

-- mouse movement on the overlay label
function Adjustable.TabWindow:onOverlayMove(event)
    Adjustable.TabWindow.currentWindow = self
    local tab = Adjustable.TabWindow.clickedTab.name
    if Adjustable.TabWindow.clickedTab ~= self.header.windowList[tab] then
        -- need to feed values to findPosition
        local fakeTab = {}
        fakeTab.get_x = function()
            return event.x + self.header.get_x()
        end
        tab_pos = self:findPosition(fakeTab)
        self:makeSpace(self, tab_pos)
    end
end

-- reset tabspace after mouse leaves overlay label and resets the currentWindow
function Adjustable.TabWindow:onOverlayLeave(event)
    Adjustable.TabWindow.currentWindow = nil
    if not (Adjustable.TabWindow.doubleClick) then
        return
    end
    local tab = Adjustable.TabWindow.clickedTab.name
    if Adjustable.TabWindow.clickedTab ~= self.header.windowList[tab] then
        self:makeSpace(nil, nil, true)
    end
end

-- reset the Overlay label to be hidden
local function resetOverlay()
    local tab = Adjustable.TabWindow.clickedTab
    if Adjustable.TabWindow.overlayTimer then
        killTimer(Adjustable.TabWindow.overlayTimer)
        Adjustable.TabWindow.overlayTimer = nil
    end
    for k, v in pairs(Adjustable.TabWindow.all) do
        v.overlay:setStyleSheet("background-color: rgba(0,0,0,0%);")
        v.overlay:hide()
    end
    if Adjustable.TabWindow.currentWindow then
        Adjustable.TabWindow.currentWindow:makeSpace(nil, nil, true)
    end
    Adjustable.TabWindow.doubleClick = nil
    tab_pos = nil

    -- reset Style if overlay is resetet without action
    if tab then
        tab.adjLabel:setStyleSheet(tab.adjLabelstyle)
    end

    if Adjustable.TabWindow.MouseEventID then
        killAnonymousEventHandler(Adjustable.TabWindow.MouseEventID)
        Adjustable.TabWindow.MouseEventID = nil
    end
end

-- handles on overlay click event
function Adjustable.TabWindow:onOverlayClick(event)
    Adjustable.TabWindow.doubleClick = nil
    local tab = Adjustable.TabWindow.clickedTab
    local container = Adjustable.TabWindow.allTabs[tab.tabname] or self
    tab.adjLabel:setStyleSheet(container.activeTabStyle)
    if container[tab.tabname].floating then
        container:restoreTab(tab.tabname, self)
        self:addTab(tab.tabname, tab_pos)
    else
        container:onRelease(tab.tabname, event)
    end
    resetOverlay()
end

-- if clicked on the minimize label the tab will be 
-- restored to be in a tabwindow again
function Adjustable.TabWindow:onMinimizeClick(tab)
    local result, value = self:checkMultiCollision(self[tab])
    if result == "floating" then
        value = nil
    end
    self:restoreTab(tab, value)
end

-- activates the tab tab (doesn't deactivate the previous tab)
-- @see Adjustable.TabWindow:deactivateTab()
function Adjustable.TabWindow:activateTab(tab)
    self:deactivateTab()
    tab = self[tab] and tab or self.tabs[1]
    self.current = tab
    if self.current then
        self[tab].adjLabelstyle = self.activeTabStyle
        self[tab].adjLabel:setStyleSheet(self.activeTabStyle)
        self[self.current .. "center"]:show()
    end
    self:raiseAll()
end

-- deactivates and hides the current active tab
function Adjustable.TabWindow:deactivateTab()
    if self.current and self[self.current] then
        self[self.current].adjLabelstyle = self.inactiveTabStyle
        self[self.current].adjLabel:setStyleSheet(self.inactiveTabStyle)
        self[self.current .. "center"]:hide()
    end
end

-- handles click event on tab
function Adjustable.TabWindow:onClick(tab, event)
    if Adjustable.TabWindow.doubleClick then
        return
    end
    Adjustable.TabWindow.currentWindow = self
    Adjustable.TabWindow.clicked = true
    Adjustable.TabWindow.clickedTab = self[tab]
    if event.button == "LeftButton" and not self[tab].floating then
        self[tab]:resize(self[tab].get_width(), self[tab].get_height())
        self[tab].container = Geyser
        -- set minimized to true to prevent resizing
        self[tab].minimized = true
        self[tab]:unlockContainer()
        self[tab]:onClick(self[tab].adjLabel, event)
        self[tab].exitLabel:hide()
        self[tab].minimizeLabel:hide()
        Adjustable.TabWindow.clicked = true
        Adjustable.TabWindow.clickedTab = self[tab]
        self[tab].adjLabel:echo(self[tab].tabText, nil, "c")
    end

    if self[tab].floating then
        self[tab]:onClick(self[tab].adjLabel, event)
    end
    if not self[tab].floating then
        self:activateTab(tab)
        self[tab].adjLabel:raise(false)
    end
end

-- handles double click event on getAreaTable
-- activates the tab overlay
function Adjustable.TabWindow:onDoubleClick(tab, event)
    Adjustable.TabWindow.currentWindow = self
    Adjustable.TabWindow.doubleClick = true
    Adjustable.TabWindow.clickedTab = self[tab]
    self[tab].adjLabel:setStyleSheet(self.chosenTabStyle)
    for k, v in pairs(Adjustable.TabWindow.all) do
        v.overlay:show()
        v.overlay:raise()
        v.overlay:setStyleSheet(v.overlayStyle)
    end
    Adjustable.TabWindow.overlayTimer = Adjustable.TabWindow.overlayTimer or tempTimer(10, function()
        resetOverlay()
    end)
    Adjustable.TabWindow.MouseEventID = Adjustable.TabWindow.MouseEventID or
                                            registerAnonymousEventHandler("sysWindowMousePressEvent",
            "Adjustable.TabWindow.onMouseClick", true)
end

-- handles the mouseclick event 
-- used for sending windows to the main or userwindow after using doubleclick on a tab
function Adjustable.TabWindow.onMouseClick(event, button, x, y, windowname)
    local newContainer = Geyser
    if windowname ~= "main" then
        newContainer = Geyser.windowList[windowname .. "Container"].windowList[windowname]
    end
    local tab = Adjustable.TabWindow.clickedTab
    local container = Adjustable.TabWindow.allTabs[tab.tabname]

    container:transformTabContainer(tab.tabname)
    local width, height = math.min(newContainer.get_width(), tab:get_width()),
        math.min(newContainer.get_height(), tab:get_height())

    tab:changeContainer(newContainer)
    tab:raiseAll()
    local x = math.min(newContainer.get_width() - width, math.max(0, x - width / 2))
    local y = math.min(newContainer.get_height() - height, math.max(0, y))
    tab:move(x, y)
    tab:resize(width, height)
    tab:setPercent(true, true)
    killAnonymousEventHandler(Adjustable.TabWindow.MouseEventID)
    Adjustable.TabWindow.MouseEventID = nil
    resetOverlay()
end

-- transforms the tab to a window
function Adjustable.TabWindow:transformTabContainer(tab)
    local myWindow = Adjustable.TabWindow.allTabs[tab] or self
    local container = self[tab]
    if container.windowname == "main" then
        Geyser:add(container)
    else
        Geyser.windowList[container.windowname .. "Container"].windowList[container.windowname]:add(container)
    end
    container:unlockContainer()
    container:resize(self.get_width(), self.get_height())
    container:add(self[tab .. "center"])
    myWindow:removeTab(tab)
    myWindow:createTabs()
    container:setPadding(self.tabPadding)
    container:show()
    container:raiseAll()
    myWindow[tab].floating = true
    container.raiseOnClick = true
    container.adjLabel:echo(self[tab].tabText, nil, "c")
    container.adjLabel:resetToolTip()
    container.minimized = false
    container:setPercent(true, true)
    myWindow:activateTab(tab)
    if #myWindow.tabs > 0 then
        myWindow:activateTab(myWindow.tabs[1])
    else
        myWindow.current = nil
    end
    local found
    container.adjLabelstyle, found = string.gsub(self.activeTabStyle, "(qproperty%-alignment%:.-).-(;)",
        "%1 'AlignTop' %2")
    if found == 0 then
        container.adjLabelstyle = container.adjLabelstyle .. "\nqproperty-alignment: 'AlignTop' ;\n"
    end
    container.adjLabel:setStyleSheet(container.adjLabelstyle)
    self[tab .. "center"]:show()
end

-- restores the window to be a tab again
function Adjustable.TabWindow:restoreTab(tab, myWindow)
    myWindow = myWindow or self
    local container = self[tab]
    container.container:remove(container)
    container:remove(self[tab .. "center"])
    container:setPadding(0)
    container:lockContainer()
    container:detach()
    container:disconnect()
    container.adjLabel:echo(self[tab].tabText, nil, "c")
    self:changeTabContainer(tab, myWindow)
    self[tab].floating = false
    container.raiseOnClick = false
    tempTimer(0, function()
        myWindow:activateTab(tab)
    end)
end

-- function to make a gap where the tab can be dropped in
function Adjustable.TabWindow:makeSpace(myWindow, position, resetSpace)
    myWindow = myWindow or self
    position = position or #myWindow.header.windows
    if position < 1 then
        position = 1
    end
    local current_Tab = Adjustable.TabWindow.clickedTab or {}
    local total_count = #myWindow.header.windows + 1
    -- close the space if resetSpace is true
    if resetSpace then
        position = -1
        total_count = total_count - 1
    end

    if myWindow == self and current_Tab.name and not (Adjustable.TabWindow.doubleClick) then
        total_count = total_count - 1
    end
    local new_width = myWindow.get_width() / total_count
    local new_x = 0
    local counter = 1
    for k, v in ipairs(myWindow.header.windows) do
        if v ~= current_Tab.name then
            if counter == position then
                new_x = new_x + new_width
            end
            myWindow.header.windowList[v]:resize(new_width)
            myWindow.header.windowList[v]:move(new_x)
            new_x = new_x + new_width
            counter = counter + 1
        end
    end
end

-- function to change the parent window of the tab 
function Adjustable.TabWindow:changeTabContainer(tab, myWindow, position)
    if self ~= myWindow or self[tab].floating then
        myWindow[tab] = self[tab]
        myWindow[tab .. "center"] = self[tab .. "center"]
        self[tab].container = not (self[tab].floating) and self.header or Geyser
        self[tab .. "center"]:changeContainer(myWindow.footer)
        self[tab]:changeContainer(myWindow.header)
        if not (self[tab].floating) then
            self:removeTab(tab)
            self:createTabs()
        end
        myWindow:createTabs()
        myWindow[tab]:show()
        if not (myWindow.hidden or myWindow.auto_hidden) then
            myWindow:show()
        end
    end
    myWindow:addTab(tab, position)
    if self.current then
        self[self.current]:show()
    end
    if #self.tabs > 0 then
        if not (self[tab].floating) then
            self:activateTab(self.tabs[1])
        end
    else
        self.current = nil
    end
    myWindow:activateTab(tab)
end

-- handles the release event
function Adjustable.TabWindow:onRelease(tab, event, position)
    if Adjustable.TabWindow.doubleClick then
        return
    end
    local myWindow = Adjustable.TabWindow.currentWindow or self
    local floating = self[tab].floating
    if event.button == "LeftButton" and Adjustable.TabWindow.currentWindow and myWindow.type == "adjustabletabwindow" and
        not floating then
        self[tab]:lockContainer()
        self[tab].container = self.header
        self[tab]:onRelease(self[tab].adjLabel, event)
        self[tab].adjLabel:echo(self[tab].tabText, nil, "c")
        tab_pos = tab_pos or myWindow:findPosition(self[tab])
        if myWindow ~= self then
            self:changeTabContainer(tab, myWindow)
        end
        myWindow:addTab(tab, tab_pos)
        myWindow:raiseAll()
    end

    if event.button == "LeftButton" and myWindow.type == "adjustablecontainer" then
        local tabname = myWindow.tabname
        local tabwindow = Adjustable.TabWindow.allTabs[tabname]
        local mytab = tabwindow[tabname]
        local tempWindow = tabwindow:createTempWindow(mytab)
        self:changeTabContainer(tab, tempWindow.tabWindow)
        tempTimer(0, function()
            tempWindow.tabWindow:activateTab(tab)
        end)
        tempWindow:raiseAll()
        self[tab]:onRelease(self[tab].adjLabel, event)
        Adjustable.TabWindow.currentWindow = tempWindow.tabWindow
    end

    if event.button == "LeftButton" and not (Adjustable.TabWindow.currentWindow) and not floating then
        self:transformTabContainer(tab)
        self[tab]:onRelease(self[tab].adjLabel, event)
    end

    if floating then
        self[tab]:onRelease(self[tab].adjLabel, event)
    end

    Adjustable.TabWindow.clicked = false
    Adjustable.TabWindow.currentWindow = nil
    if not (Adjustable.TabWindow.doubleClick) then
        Adjustable.TabWindow.clickedTab = nil
    end
    tab_pos = nil
end

-- change the text a tab displays
function Adjustable.TabWindow:setTabText(which, text)
    assert(type(which) == "string" or type(which) == "number",
        "setTabText: bad argument #1 type (tab name/position as string or number expected, got " .. type(which) .. "!)")
    assert(type(text) == "string",
        "setTabText: bad argument #2 type (tab text as string expected, got " .. type(text) .. "!)")
    if not (type(which) == "number" and which <= #self.tabs) then
        which = table.index_of(self.tabs, which)
    end

    if which then
        self[self.tabs[which]].tabText = text
        self[self.tabs[which]]:setTitle(text)
        self[self.tabs[which]].adjLabel:echo(text, nil, "c")
        setTabToolTip(self[self.tabs[which]])
        return true
    end
    return nil, "setTabText: Couldn't find tab to set a new text"
end

-- removes a tab (this won't be saved)
function Adjustable.TabWindow:removeTab(which)
    assert(type(which) == "string" or type(which) == "number",
        "removeTab: bad argument #1 type (tab name/position as string or number expected, got " .. type(which) .. "!)")
    local index
    if type(which) == "number" and which <= #self.tabs then
        index = which
    else
        index = table.index_of(self.tabs, which)
    end
    if index then
        local tabname = self.tabs[index]
        self[tabname]:hide()
        self.header:remove(self[tabname])
        self.header:organize()
        table.remove(self.tabs, index)
        self:activateTab(self.tabs[1])
        if self.temporary then
            -- destroy empty tempTabWindow
            if table.is_empty(self.tabs) then
                self[tabname].tempWindow:changeContainer("main")
                Adjustable.TabWindow.all[self.name] = nil
                table.remove(Adjustable.TabWindow.all_windows, table.index_of(Adjustable.TabWindow.all_windows, self))
                self[tabname].tempWindow:detach()
                self[tabname].tempWindow:disconnect()
                self[tabname].tempWindow:hide()
                -- delete all references to this tab to avoid it being sent to nirwana if restored
                for k, v in pairs(Adjustable.TabWindow.allTabs) do
                    if v.name == self.name then
                        local styleOrigin = Adjustable.TabWindow.all[self.tempStyle]
                        Adjustable.TabWindow.allTabs[k] = styleOrigin
                        styleOrigin[k] = styleOrigin[k] or self[k]
                        styleOrigin[k .. "center"] = styleOrigin[k .. "center"] or self[k .. "center"]
                        styleOrigin[k].minimizeLabel:setClickCallback(function()
                            styleOrigin[k]:onMinimizeClick(k)
                        end)
                        styleOrigin[k].minLabel:setClickCallback(function()
                            styleOrigin[k]:onMinimizeClick(k)
                        end)
                    end
                end
            end
            self[tabname].tempWindow = nil
            self[tabname].tempTabWindow = nil
        end
        return true
    end
    return nil, "removeTab: Couldn't find tab to remove"
end

-- adds a tab (this won't be saved)
function Adjustable.TabWindow:addTab(name, pos)
    assert(type(name) == "string",
        "addTab: bad argument #1 type (tab name as string expected, got " .. type(name) .. "!)")
    pos = pos or #self.tabs
    pos = pos > #self.tabs and #self.tabs or pos
    assert(type(pos) == "number",
        "addTab: bad argument #2 type (tab position as number expected, got " .. type(pos) .. "!)")
    -- check if tabName exists already
    local index = table.index_of(self.tabs, name)
    -- check if postion is valid
    if pos < 1 and #self.tabs ~= 0 then
        return nil, "addTab: not a valid position"
    end

    pos = index and pos > #self.tabs and #self.tabs or not (index) and pos == #self.tabs and pos + 1 or pos

    -- if tab exists and is at the same position already, do nothing
    if index == pos then
        self.header:organize()
        return true
    end

    -- if tab exists and position is different, then change the position
    if index then
        table.remove(self.tabs, index)
        table.remove(self.header.windows, index)
    end
    table.insert(self.tabs, pos, name)

    -- if tab is new create a new Label
    if not index then
        self:createTabs()
    end

    -- If the container isn't the right one change it (useful if removed in one adj tabwindow and added to another)
    self[name .. "center"]:changeContainer(self.footer)
    self[name]:changeContainer(self.header)

    local headername = self[name].name
    -- if name is already in windows delete it to put it into the right position
    local headerIndex = table.index_of(self.header.windows, headername)
    if headerIndex then
        table.remove(self.header.windows, headerIndex)
    end
    table.insert(self.header.windows, pos, headername)
    self.header.windowList[headername] = self[name]
    self[name]:show()
    self.header:organize()
    self:activateTab(name)
    if self.temporary then
        self[name].tempWindow = self.container.container
        self[name].tempTabWindow = self
    end

    -- put ToolTip on Label if TabText is to long to display
    setTabToolTip(self[name])
    return true
end

function Adjustable.TabWindow:addToTabWindow(container)
    local name = container.name
    self:addTab(name)
    container:detach()
    container:disconnect()
    container:changeContainer(self[name .. "center"])
    container:resize("100%", "100%")
    container:move(0, 0)
    self[name].tabified = true

    if container.type == "adjustablecontainer" then
        container:lockContainer("full")
        if container.autoSave then
            container:disableAutoSave()
        end
        local titleText = string.gsub(container.titleText, "&nbsp;", "")
        self:setTabText(name, titleText)
        self:createTabs()
    end
end

-- transforms adjcontainer to a floating tab
function Adjustable.TabWindow:tabify(container)
    local x, y, width, height = container:get_x(), container:get_y(), container:get_width(), container:get_height()
    local parent = container.container
    self:addToTabWindow(container)
    self:transformTabContainer(container.name)
    self[container.name]:move(x, y)
    self[container.name]:resize(width, height)
    self[container.name]:changeContainer(parent)
    self:createTempWindow(self[container.name])
end

function Adjustable.TabWindow:addTabifyMenu(adjcontainer)
    if adjcontainer.type ~= "adjustablecontainer" then
        return "not an adjustable container"
    end
    adjcontainer:newCustomItem("Tabify", function()
        self:tabify(adjcontainer)
    end)
end

--- saves your container settings
-- like tab position and some other variables in your Mudlet Profile Dir/ Adjustable.TabWindow
-- to be reliable it is important that every Adjustable.TabWindow has an unique 'name'
-- @see Adjustable.TabWindow:load
function Adjustable.TabWindow:save(slot, dir)
    if type(self) ~= "table" then
        dir = slot
        slot = self
    end
    assert(slot == nil or type(slot) == "string" or type(slot) == "number",
        "Adjustable.TabWindow.save: bad argument #1 type (slot as string or number expected, got " .. type(slot) .. "!)")
    assert(dir == nil or type(dir) == "string",
        "Adjustable.TabWindow.save: bad argument #2 type (directory as string expected, got " .. type(dir) .. "!)")

    dir = dir or self.defaultDir
    slot = slot or ""
    local saveDir = string.format("%s%s%s.lua", dir, "TabWindowTabs", slot)

    local mytable = {}
    -- save fixed tabs
    for k, v in pairs(Adjustable.TabWindow.all) do
        mytable[k] = {}
        mytable[k].tabs = v.tabs
        mytable[k].current = v.current
        mytable[k].temporary = v.temporary
    end
    -- save floating tabs, tempTabWindows and tabified containers
    for k, v in pairs(Adjustable.TabWindow.allTabs) do

        -- floating tabs
        if v[k].floating then
            -- save the tabs adjustable container settings
            v[k]:save(slot, dir)
            -- get all floating tabs and their windownames
            mytable[v.name].floatingTabs = mytable[v.name].floatingTabs or {}
            mytable[v.name].floatingTabs[k] = "main"
            if v[k].windowname ~= "main" then
                mytable[v.name].floatingTabs[k] = v[k].windowname
            end
        end

        -- tempTabWindows
        if v[k].tempWindow then
            -- save tempWindow adjustable container settings
            v[k].tempWindow:save(slot, dir)
            mytable[v.name].windowname = v[k].tempWindow.windowname
            -- save window where tempStyle came from
            mytable[v.name].tempStyle = v[k].tempTabWindow.tempStyle
        end

        -- tabified containers
        if v[k].tabified then
            mytable.tabifiedContainers = mytable.tabifiedContainers or {}
            mytable.tabifiedContainers[#mytable.tabifiedContainers + 1] = k
        end
    end

    if not (io.exists(dir)) then
        lfs.mkdir(dir)
    end
    table.save(saveDir, mytable)
end

--- restores/loads the before saved settings 
-- it is very important to load after all TabWindows are created
-- @see Adjustable.TabWindow:save
function Adjustable.TabWindow:load(slot, dir)
    if type(self) ~= "table" then
        dir = slot
        slot = self
    end
    assert(slot == nil or type(slot) == "string" or type(slot) == "number",
        "Adjustable.TabWindow.load: bad argument #1 type (slot as string or number expected, got " .. type(slot) .. "!)")
    assert(dir == nil or type(dir) == "string",
        "Adjustable.TabWindow.load: bad argument #2 type (directory as string expected, got " .. type(dir) .. "!)")
    dir = dir or self.defaultDir
    local slot = slot or ""
    local loadDir = string.format("%s%s%s.lua", dir, "TabWindowTabs", slot)
    local mytable = {}
    if io.exists(loadDir) then
        table.load(loadDir, mytable)
    else
        return "No saved settings found at: " .. loadDir
    end

    -- find the tabified container by name
    local function findWindow(cont, name)
        cont = cont or Geyser
        for k, v in pairs(cont.windowList) do
            if name == v.name then
                return v
            end
            if findWindow(v, name) then
                return findWindow(v, name)
            end
        end
    end

    -- create Tabified Windows
    if mytable.tabifiedContainers then
        for k, v in ipairs(mytable.tabifiedContainers) do
            local container = findWindow(nil, v)
            if not (Adjustable.TabWindow.allTabs[v]) then
                Adjustable.TabWindow.all[Adjustable.TabWindow.all_windows[1]]:addToTabWindow(container)
            end
        end
        mytable.tabifiedContainers = nil
    end
    -- create TempWindows and TempTabWindows
    for k, v in pairs(mytable) do
        if v.temporary then
            if not Adjustable.TabWindow.all[k] then
                local tempStyleWindow = Adjustable.TabWindow.all[v.tempStyle]
                tempStyleWindow:createTempWindow(nil, k)
            end
            Adjustable.TabWindow.all[k].container.container:load(slot, dir)
            if v.windowname ~= "main" then
                Adjustable.TabWindow.all[k].container.container:changeContainer(
                    Geyser.windowList[v.windowname .. "Container"].windowList[v.windowname])
            end
        end
    end

    for k, v in pairs(mytable) do
        -- load fixed Tabs
        local myWindow = Adjustable.TabWindow.all[k]
        for k1, v1 in ipairs(v.tabs) do
            local myTabWindow = Adjustable.TabWindow.allTabs[v1]
            if myTabWindow then
                local myTab = myTabWindow[v1]
                if myTab.floating then
                    myTabWindow:restoreTab(v1)
                end
                if not myWindow.header.windowList[v1] then
                    myTabWindow:changeTabContainer(v1, myWindow)
                end
                myWindow:addTab(v1, k1)
            end
        end
        if myWindow then
            myWindow:deactivateTab()
            myWindow.current = v.current
            tempTimer(0, function()
                myWindow:activateTab(v.current)
            end)
            myWindow:raiseAll()
        end
        -- load floating Tabs
        if v.floatingTabs then
            for k1, v1 in pairs(v.floatingTabs) do
                local myTabWindow = Adjustable.TabWindow.allTabs[k1]
                local styleTabWindow = Adjustable.TabWindow.all[k]
                if myTabWindow and styleTabWindow then
                    local myTab = myTabWindow[k1]
                    if myTabWindow ~= styleTabWindow then
                        myTabWindow:changeTabContainer(k1, styleTabWindow)
                        myTabWindow = styleTabWindow
                    end
                    myTabWindow:transformTabContainer(k1)
                    -- send my Tab to a UserWindow if saved there
                    if v1 ~= "main" then
                        myTab:changeContainer(Geyser.windowList[v1 .. "Container"].windowList[v1])
                    end
                    -- load Adjustable Container settings
                    myTab:load(slot, dir)
                end
            end
        end
    end
end
string.format("%s/PRS/settings/", getMudletHomeDir())
-- EMCO by demonnic https://github.com/demonnic/EMCO
function Adjustable.TabWindow:transferEMCO(emco)
    local EMCO = EMCO or require("PRS.emco")
    -- echo("EMCO Loaded") hide debug tracer
    emco:hide()
    local emco_tabs = emco.tabs
    local emco_tabwindows = emco.consoles
    local emco_windows = emco.mc

    -- xEcho override
    local myXEcho = function(s, tabName, message, xtype, excludeAll)
        s.currentTab = self.current
        if s.blink and tabName ~= s.currentTab then
            if not (s.allTabName == s.currentTab and not s.blinkFromAll) then
                s.tabsToBlink[tabName] = true
            end
        end
        EMCO.xEcho(s, tabName, message, xtype, excludeAll)
    end

    -- Flash override
    local myFlash = function(s)
        Geyser.Container.flash(s)
        raiseWindow(s.name .. "_dimensions_flash")
    end
    -- doBlink override
    local myDoBlink = function(s)
        s.currentTab = self.current
        if s.blink then
            if s.allTab and not s.blinkFromAll and
                (s.currentTab == s.allTabName or self[s.allTabName .. "center"].hidden == false) then
                s.tabsToBlink = {}
            elseif s.tabsToBlink[s.currentTab] then
                s.tabsToBlink[s.currentTab] = nil
            end
        end
        for tab, _ in pairs(s.tabsToBlink) do
            if not self[tab].floating and self[tab .. "center"].hidden then
                s.tabs[tab]:flash()
            else
                s.tabsToBlink[tab] = nil
            end
        end
    end

    -- function for transfering tab and console
    local function transferTab(tabwindow)
        emco_windows[tabwindow]:show()
        emco_windows[tabwindow]:changeContainer(self[tabwindow .. "center"])
        emco_tabs[tabwindow]:changeContainer(self[tabwindow])
        emco_tabs[tabwindow]:move(0, 0)
        emco_tabs[tabwindow]:resize("100%", "100%")
        emco_tabs[tabwindow]:hide()
        emco_tabs[tabwindow].flash = myFlash
        if emco_tabs[tabwindow].font then
            self[tabwindow].adjLabel:setFont(emco_tabs[tabwindow].font)
        end
    end

    -- addTab override
    local myAddTab = function(s, tabName, position)
        EMCO.addTab(s, tabName)
        self:addTab(tabName, position)
        transferTab(tabName)
        self:activateTab(tabName)
    end

    -- removeTab override
    local myRemoveTab = function(s, tabName)
        EMCO.removeTab(s, tabName)
        if self[tabName].floating then
            self:restoreTab(tabName)
        end
        Adjustable.TabWindow.allTabs[tabName]:removeTab(tabName)
    end

    -- transfering process
    self.tabs = table.n_union(self.tabs, emco_tabwindows)
    self:createTabs()
    for k, v in ipairs(emco_tabwindows) do
        transferTab(v)
    end
    self:activateTab(emco.currentTab)
    emco.reset = function()
    end
    emco.removeTab = myRemoveTab
    emco.addTab = myAddTab
    emco.xEcho = myXEcho
    emco.doBlink = myDoBlink
    emco.setGap = function(s, gap)
        EMCO.setGap(s, gap)
        self:setGap(math.max(2, gap) - 2)
    end
    emco.setTabHeight = function(s, height)
        EMCO.setTabHeight(s, height)
        self:setTabHeight(height + 2)
    end
    emco.setTabBoxColor = function(s, color)
        EMCO.setTabBarColor(s, color)
        self:setTabBarColor(color)
    end
    emco.setTabBoxCSS = function(s, css)
        EMCO.setTabBoxCSS(s, css)
        self:setTabBarCSS(css)
    end
    emco.setActiveTabBGColor = function(s, color)
        self:setActiveTabBGColor(color)
        EMCO.setActiveTabBGColor(s, color)
    end
    emco.setInactiveTabBGColor = function(s, color)
        self:setInactiveTabBGColor(color)
        EMCO.setInactiveTabBGColor(s, color)
    end
    emco.setActiveTabFGColor = function(s, color)
        EMCO.setActiveTabFGColor(s, color)
        self:setActiveTabFGColor(color)
    end
    emco.setInactiveTabFGColor = function(s, color)
        EMCO.setInactiveTabFGColor(s, color)
        self:setInactiveTabFGColor(color)
    end
    emco.setSingleTabFont = function(s, tab, font)
        EMCO.setSingleTabFont(s, tab, font)
        self:setSingleTabFont(tab, font)
    end
    emco.setTabFont = function(s, font)
        EMCO.setTabFont(s, font)
        self:setTabFont(font)
    end
    emco.save = function(s, slot, dir)
        EMCO.save(s)
        self:save(slot, dir)
    end
    emco.load = function(s, slot, dir)
        EMCO.load(s)
        self:load(slot, dir)
    end
end

-- EMCO by demonnic https://github.com/demonnic/EMCO
-- convert EMCO to Adjustable TabWindow
function Adjustable.TabWindow.convertEMCO(emco)
    if emco.myTabWindow then
        return
    end
    emco.myTabWindow = emco.myTabWindow or Adjustable.TabWindow:new({
        name = emco.name .. "TabWindow",
        x = emco.x,
        y = emco.y,
        width = emco.width,
        height = emco.height,
        centerStyle = "background-color: rgba(0,0,0,0);",
        footerStyle = "background-color: rgba(0,0,0,0);",
        activeTabStyle = emco.activeTabCSS,
        inactiveTabStyle = emco.inactiveTabCSS,
        tabBarHeight = emco.tabHeight + 2,
        gap = emco.gap - 2
    }, emco.container)
    emco.myTabWindow:setActiveTabFGColor(emco.activeTabFGColor)
    emco.myTabWindow:setInactiveTabFGColor(emco.inactiveTabFGColor)
    emco.myTabWindow:setActiveTabBGColor(emco.activeTabBGColor)
    emco.myTabWindow:setInactiveTabBGColor(emco.inactiveTabBGColor)
    emco.myTabWindow:transferEMCO(emco)
    emco.hide = function()
        Geyser.Container.hide(emco.myTabWindow)
    end
    emco.show = function()
        Geyser.Container.show(emco.myTabWindow)
    end
    emco:show()
end

-- Save a reference to our parent constructor
Adjustable.TabWindow.parent = Geyser.Container
-- Create table to put every Adjustable.TabWindow in it
Adjustable.TabWindow.all = Adjustable.TabWindow.all or {}
Adjustable.TabWindow.all_windows = Adjustable.TabWindow.all_windows or {}
Adjustable.TabWindow.allTabs = Adjustable.TabWindow.allTabs or {}

-- tabwindow constructor
function Adjustable.TabWindow:new(cons, container)
    Geyser.HBox.organize = Geyser.HBox.organize or Geyser.HBox.reposition
    local me = self.parent:new(cons, container)
    cons = cons or {}
    setmetatable(me, self)
    self.__index = self
    me.type = "adjustabletabwindow"
    me.defaultDir = me.defaultDir or getMudletHomeDir() .. "/PRS/"
    me.tabs = me.tabs or {}
    me.tabTxtColor = me.tabTxtColor or "white"
    me.tabPadding = me.tabPadding or 12
    me.color1 = me.color1 or "rgb(0,0,100)"
    me.color2 = me.color2 or "rgb(0,0,70)"
    me.activeTabBGColor = me.activeTabBGColor or me.color1
    me.inactiveTabBGColor = me.inactiveTabBGColor or me.color2
    me.tabBarHeight = me.tabBarHeight or "35"
    me.gap = me.gap or 0
    me.footerStyle = me.footerStyle or [[
    background-color: ]] .. me.color1 .. [[;
    border-bottom-left-radius: 10px;
    border-bottom-right-radius: 10px;
    ]]

    me.centerStyle = me.centerStyle or [[
    background-color: ]] .. me.color2 .. [[;
    border-radius: 10px;
    margin: 5px;
    ]]

    me.inactiveTabStyle = me.inactiveTabStyle or [[QLabel::hover{
        background-color: ]] .. me.activeTabBGColor .. [[;
        color: ]] .. me.tabTxtColor .. [[;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
        margin-right: 1px;
        margin-left: 1px;
        qproperty-alignment: 'AlignVCenter';
    }
    QLabel::!hover{
        background-color: ]] .. me.inactiveTabBGColor .. [[;
        color: ]] .. me.tabTxtColor .. [[;
        border-top-left-radius: 10px;
        border-top-right-radius: 10px;
        margin-right: 1px;
        margin-left: 1px;
        qproperty-alignment: 'AlignVCenter';
    }
    ]]

    me.activeTabStyle = me.activeTabStyle or [[
    background-color: ]] .. me.activeTabBGColor .. [[;
    color: ]] .. me.tabTxtColor .. [[;
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    margin-right: 1px;
    margin-left: 1px;
    qproperty-alignment: 'AlignVCenter';
    ]]

    me.chosenTabStyle = me.chosenTabStyle or [[
    background-color: rgba(255,30,0,60%);
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
    margin-right: 1px;
    margin-left: 1px;
    color: ]] .. me.tabTxtColor .. [[;
    
    ]]

    me.overlayStyle = me.overlayStyle or [[
    background-color: rgba(0,0,0,0%);
    border: 2px solid white;]]

    me.tabBarStyle = me.tabBarStyle or [[
    background-color: rgba(0,0,0,0%);
    ]]

    me.tempWindowConf = me.tempWindowConf or {
        buttonsize = "12",
        buttonFontSize = "7",
        padding = 9,
        buttonstyle = [[
        QLabel{ border-radius: 4px; background-color: rgba(80,80,80,80%);}
        QLabel::hover{ background-color: rgba(60,60,60,50%);}
        ]],
        adjLabelstyle = [[background-color: rgba(0,0,0,90%); border: 2px solid rgb(50,50,50);]]
    }

    me:createBaseContainers()
    me:createTabs()

    if me.tabBarColor then
        me:setTabBarColor(me.tabBarColor)
    else
        me.tabBarColor = "black"
    end

    local found = string.match(" " .. me.activeTabStyle, "(%scolor:).-(;)")
    if not (found) then
        me.activeTabFGColor = me.activeTabFGColor or me.tabTxtColor
    end

    found = string.match(" " .. me.inactiveTabStyle, "(%scolor:).-(;)")
    if not (found) then
        me.inactiveTabFGColor = me.inactiveTabFGColor or me.tabTxtColor
    end

    if me.activeTabFGColor then
        me:setActiveTabFGColor(me.activeTabFGColor)
    end
    if me.inactiveTabFGColor then
        me:setInactiveTabFGColor(me.inactiveTabFGColor)
    end

    me.current = me.current or me.tabs[#me.tabs]

    if me.tabs[1] then
        me:activateTab(me.tabs[1])
    end
    tempTimer(0, function()
        if me.tabs[1] then
            me[me.tabs[#me.tabs] .. "center"]:hide()
        end
    end)

    if not Adjustable.TabWindow.all[me.name] then
        Adjustable.TabWindow.all_windows[#Adjustable.TabWindow.all_windows + 1] = me.name
    end
    Adjustable.TabWindow.all[me.name] = me

    return me
end

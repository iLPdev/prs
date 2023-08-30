PRSinv = PRSinv or {}

PRSinv.inventoryTable = PRSinv.inventoryTable or {}

PRSinv.container = PRSinv.container or Geyser.ScrollBox:new({
    name = "inventoryScrollBox",
    height = "95%",
    width = "95%",
    x = 10,
    y = 10
}, GUI.tabwindow2.Inventorycenter)

PRSinv.gmcpGetItem = function(id)
    send("gmcp item " .. id, false)
end

PRSinv.currentInventoryIndex = 1

PRSinv.getNextInventoryItem = function()
    if PRSinv.currentInventoryIndex <= #gmcp.Char.inventory then
        local iid = gmcp.Char.inventory[PRSinv.currentInventoryIndex]
        if not PRSinv.inventoryTable[iid] then
            -- echo("Getting inventory item " .. PRSinv.currentInventoryIndex .. "/" .. #gmcp.Char.inventory .. "\n")
            PRSinv.gmcpGetItem(iid)
            PRSinv.currentInventoryIndex = PRSinv.currentInventoryIndex + 1
        else
            -- echo("Already got " .. PRSinv.currentInventoryIndex .. "/" .. #gmcp.Char.inventory .. "\n")
            PRSinv.currentInventoryIndex = PRSinv.currentInventoryIndex + 1
            PRSinv.getNextInventoryItem()
        end
    else
        PRSinv.displayAllInventory()
    end
end

PRSinv.gmcpStoreItemData = function()
    if not gmcp or not gmcp.Item or not gmcp.Item.Info then
        -- echo("Item not set...\n")
        return
    end

    PRSinv.inventoryTable[gmcp.Item.Info.iid] = PRSutil.tableCopy(gmcp.Item, nil)
    -- echo("Stored: " .. gmcp.Item.Info.iid .. "\n")
    PRSinv.getNextInventoryItem()
end

PRSinv.getAllInventoryData = function()
    PRSinv.currentInventoryIndex = 1
    PRSinv.getNextInventoryItem()
end

PRSinv.labels = PRSinv.labels or {}

PRSinv.displayAllInventory = function()
    for i, iid in ipairs(gmcp.Char.inventory) do
        PRSinv.displayItem(i, iid)
    end
end

PRSinv.labelHeight = 20
PRSinv.labelGapHeight = 0

PRSinv.displayItem = function(i, iid)
    local y = (i - 1) * (PRSinv.labelGapHeight + PRSinv.labelHeight)
    PRSinv.labels[i] = PRSinv.labels[i] or Geyser.Label:new({
        name = "invLabel" .. i,
        x = 0,
        y = y,
        width = "100%-20px",
        height = PRSinv.labelHeight
    }, PRSinv.container)
    local label = PRSinv.labels[i]
    label:setStyleSheet([[
    background-color: rgb(16,16,20);
  ]])
    label:setFontSize(9)
    -- label:createRightClickMenu({
    -- MenuItems = {
    -- "Drop"
    -- }
    -- })
    -- label:setClickCallback(function (event)
    -- label:onRightClick(event)
    -- end)

    local item = PRSinv.inventoryTable[iid]
    if item then
        label:hecho("L" .. item.Info.level .. " " .. item.Info.amount .. "x " ..
                        PRSutil.getHechoColor(item.Info.colorName))
    end
end

if PRSinv.invEventHandler then
    killAnonymousEventHandler(PRSinv.invEventHandler)
end -- clean up any already registered handlers for this function
PRSinv.invEventHandler = registerAnonymousEventHandler("gmcp.Item", PRSinv.gmcpStoreItemData)

if PRSinv.getInvEventHandler then
    killAnonymousEventHandler(PRSinv.getInvEventHandler)
end -- clean up any already registered handlers for this function
PRSinv.getInvEventHandler = registerAnonymousEventHandler("gmcp.Char.inventory", PRSinv.getAllInventoryData)

PRSchat = PRSchat or {}
PRSchat.triggers = PRSchat.triggers or {}

local EMCO = require("PRS.emco")
local rev = require("PRS.revisionator")

function PRSchat.tabs()
    local title_text
    if gmcp and gmcp.Char and gmcp.Char.player then
        title_text = "Procedural Realms - " .. gmcp.Char.player.name
    else
        title_text = "Procedural Realms"
        registerAnonymousEventHandler("gmcp.Char.player.name", function()
            PRSchat.UW:setTitle("Procedural Realms - " .. gmcp.Char.player.name)
        end, true)
    end

    PRSchat.UW = Geyser.UserWindow:new({
        name = "Chat",
        titleText = title_text,
        y = "50%",
        --docked = true,
        width = "25%",
        height = "75%"
    })

    local stylesheet =
        [[background-color: rgb(80,80,80,255); border-width: 1px; border-style: solid; border-color: black; border-radius: 0px;]]
    local istylesheet =
        [[background-color: rgb(60,60,60,255); border-width: 1px; border-style: solid; border-color: black; border-radius: 0px;]]

    PRSchat.EMCO = EMCO:new({
        name = "PRSchatTabs",
        x = "0",
        y = "0",
        width = "100%",
        height = "100%",
        allTab = true,
        allTabName = "All",
        gap = 2,
        leftMargin = 2,
        consoleColor = "black",
        consoles = {"Chat", "Newbie", "Trade", "Local", "Tell", "All"},
        mapTab = false,
        activeTabFGColor = "white",
        inactiveTabFGColor = "gray",
        activeTabCSS = stylesheet,
        inactiveTabCSS = istylesheet,
        preserveBackground = true,
        timestamp = true,
        customTimestampColor = true,
        timestampFGColor = "dim_gray",
        timestampBGColor = "black"
    }, PRSchat.UW)

    local emcoRev = rev:new({
        name = "prsRevisionator"
    })

    emcoRev:addPatch(function()
        --- patch for v1.6.0
        PRSchat.EMCO.leftMargin = 2
        PRSchat.EMCO.tabBold = true
        PRSchat.EMCO:setActiveTabFGColor("white")
        PRSchat.EMCO:setinactiveTabFGColor("gray")
        PRSchat.EMCO:enableTimeStamp()
        PRSchat.EMCO:enableCustomTimestampColor()
        PRSchat.EMCO:setTimestampFGColor("dim_gray")
        PRSchat.EMCO:setTimestampBGColor("black")
    end)

    local function saver(eventName, packageName)
        if eventName == "sysExitEvent" or packageName == "PRS" then
            PRSchat.EMCO:save()
        end
    end

    local function loader(eventName, packageName)
        if eventName == "sysLoadEvent" or packageName == "PRS" then
            PRSchat.EMCO:load()
            -- new stuff below here
            local changed = emcoRev:migrate()
            if changed then -- save the emco changes back to its own save file
                PRSchat.EMCO:save()
            end
        end
    end

    PRSchat.EMCO:setCmdAction("Chat", function(str)
        send("chat " .. str)
    end)
    PRSchat.EMCO.mc["Chat"]:enableCommandLine()
    PRSchat.EMCO:setCmdAction("Newbie", function(str)
        send("newbie " .. str)
    end)
    PRSchat.EMCO.mc["Newbie"]:enableCommandLine()
    PRSchat.EMCO:setCmdAction("Trade", function(str)
        send("trade " .. str)
    end)
    PRSchat.EMCO.mc["Trade"]:enableCommandLine()
    PRSchat.EMCO:setCmdAction("Local", function(str)
        send("say " .. str)
    end)
    PRSchat.EMCO.mc["Local"]:enableCommandLine()
    local tell_rex = rex.new("^@(?<to>\\w+) (?<msg>.+)$")
    PRSchat.EMCO:setCmdAction("Tell", function(str)
        local _, _, matches = tell_rex:tfind(str)
        if matches then
            send(f "tell {matches.to} {matches.msg}")
        else
            send("reply " .. str)
        end
    end)
    PRSchat.EMCO.mc["Tell"]:enableCommandLine()

    registerNamedEventHandler("PRS", "load", "sysLoadEvent", loader)
    registerNamedEventHandler("PRS", "install", "sysInstall", loader)
    registerNamedEventHandler("PRS", "exit", "sysExitEvent", saver)
    registerNamedEventHandler("PRS", "uninstall", "sysUninstall", saver)
end

function PRSchat.stop()
    for k, v in pairs(PRSchat.triggers) do
        killTrigger(v)
    end
    PRSchat.triggers = {}

    return true
end

function PRSchat.initialize()
    if not PRSchat.triggers.chat_trigger_id then
        PRSchat.triggers.chat_trigger_id = tempRegexTrigger("^< Chat \\| (?<sender>.+) > (?<msg>.+)$", function()
            local chat_lines = {}

            if not PRSchat.triggers.chat_line_id then
                PRSchat.triggers.chat_line_id = tempRegexTrigger(".*", function()
                    if isPrompt() then
                        local concat_lines = table.concat(chat_lines)
                        local result = concat_lines:sub(1, -2) .. "\n"

                        PRSchat.EMCO:decho("Chat", result, false)
                        killTrigger(PRSchat.triggers.chat_line_id)
                        PRSchat.triggers.chat_line_id = nil
                    else
                        table.insert(chat_lines, copy2decho() .. " ")
                    end
                end)
            end
        end)
    end

    if not PRSchat.triggers.newbie_trigger_id then
        PRSchat.triggers.newbie_trigger_id = tempRegexTrigger("^< Newbie \\| (?<sender>.+) > (?<msg>.+)$", function()
            local chat_lines = {}

            if not PRSchat.triggers.newbie_line_id then
                PRSchat.triggers.newbie_line_id = tempRegexTrigger(".*", function()
                    if isPrompt() then
                        local concat_lines = table.concat(chat_lines)
                        local result = concat_lines:sub(1, -2) .. "\n"

                        PRSchat.EMCO:decho("Newbie", result, false)
                        killTrigger(PRSchat.triggers.newbie_line_id)
                        PRSchat.triggers.newbie_line_id = nil
                    else
                        table.insert(chat_lines, copy2decho() .. " ")
                    end
                end)
            end
        end)
    end

    if not PRSchat.triggers.trade_trigger_id then
        PRSchat.triggers.trade_trigger_id = tempRegexTrigger("^< Trade \\| (?<sender>.+) > (?<msg>.+)$", function()
            local chat_lines = {}

            if not PRSchat.triggers.trade_line_id then
                PRSchat.triggers.trade_line_id = tempRegexTrigger(".*", function()
                    if isPrompt() then
                        local concat_lines = table.concat(chat_lines)
                        local result = concat_lines:sub(1, -2) .. "\n"

                        PRSchat.EMCO:decho("Trade", result, false)
                        killTrigger(PRSchat.triggers.trade_line_id)
                        PRSchat.triggers.trade_line_id = nil
                    else
                        table.insert(chat_lines, copy2decho() .. " ")
                    end
                end)
            end
        end)
    end

    if not PRSchat.triggers.local_trigger_id then
        PRSchat.triggers.local_trigger_id = tempRegexTrigger("^(?<sender>.+) say(?<s>s)?, '(?<msg>.+)$", function()
            local chat_lines = {}

            if not PRSchat.triggers.local_line_id then
                PRSchat.triggers.local_line_id = tempRegexTrigger(".+", function()
                    table.insert(chat_lines, copy2decho() .. " ")
                    if string.ends(line, "'") then
                        local concat_lines = table.concat(chat_lines)
                        local result = concat_lines:sub(1, -2) .. "\n"

                        PRSchat.EMCO:decho("Local", result, false)
                        killTrigger(PRSchat.triggers.local_line_id)
                        PRSchat.triggers.local_line_id = nil
                    end
                end)
            end
        end)
    end

    if not PRSchat.triggers.tell_trigger_id then
        PRSchat.triggers.tell_trigger_id = tempRegexTrigger("^(?<from>.+) tell(?<s>s)? (?<to>\\w+), '(?<msg>.+)$",
            function()
                local chat_lines = {}

                if not PRSchat.triggers.tell_line_id then
                    PRSchat.triggers.tell_line_id = tempRegexTrigger(".+", function()
                        table.insert(chat_lines, copy2decho() .. " ")
                        if string.ends(line, "'") then
                            local concat_lines = table.concat(chat_lines)
                            local result = concat_lines:sub(1, -2) .. "\n"

                            PRSchat.EMCO:decho("Tell", result, false)
                            killTrigger(PRSchat.triggers.tell_line_id)
                            PRSchat.triggers.tell_line_id = nil
                        end
                    end)
                end
            end)
    end
end
PRSchat.initialize()

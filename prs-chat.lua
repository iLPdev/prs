PRSchat = PRSchat or {}
PRSchat.triggers = PRSchat.triggers or {}

function PRSchat.tabs()
  local EMCO = require("PRS.emco")
  PRSchat.UW = Geyser.UserWindow:new({name = "Chat", titleText ="Procedural Realms", y="50%", docked = true})
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
      "Chat",
      "Newbie",
      "Trade",
      "Local",
      "Tell",
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


function PRSchat.stop()
  for k, v in pairs(PRSchat.triggers) do
    killTrigger(v)
  end
  
  return true
end

function PRSchat.initialize()
  if not PRSchat.triggers.chat_trigger_id then
    PRSchat.triggers.chat_trigger_id = tempRegexTrigger("^< Chat \\| (?<sender>.+) > (?<msg>.+)$", function()
      local chat_lines = {}
  
      PRSchat.triggers.chat_line_id = tempRegexTrigger(".*", function()
        if isPrompt() then
          local concat_lines = table.concat(chat_lines)
          local result = concat_lines:sub(1, -2).."\n"
  
          PRSchat.EMCO:decho("Chat", result, false)
          killTrigger(PRSchat.triggers.chat_line_id)
        else
          table.insert(chat_lines, copy2decho().." ")
        end
      end)
    end)
  end

  if not PRSchat.triggers.newbie_trigger_id then
    PRSchat.triggers.newbie_trigger_id = tempRegexTrigger("^< Newbie \\| (?<sender>.+) > (?<msg>.+)$", function()
      local chat_lines = {}
  
      PRSchat.triggers.newbie_line_id = tempRegexTrigger(".*", function()
        if isPrompt() then
          local concat_lines = table.concat(chat_lines)
          local result = concat_lines:sub(1, -2).."\n"
  
          PRSchat.EMCO:decho("Newbie", result, false)
          killTrigger(PRSchat.triggers.newbie_line_id)
        else
          table.insert(chat_lines, copy2decho().." ")
        end
      end)
    end)
  end

  if not PRSchat.triggers.trade_trigger_id then
    PRSchat.triggers.trade_trigger_id = tempRegexTrigger("^< Trade \\| (?<sender>.+) > (?<msg>.+)$", function()
      local chat_lines = {}
  
      PRSchat.triggers.trade_line_id = tempRegexTrigger(".*", function()
        if isPrompt() then
          local concat_lines = table.concat(chat_lines)
          local result = concat_lines:sub(1, -2).."\n"
  
          PRSchat.EMCO:decho("Trade", result, false)
          killTrigger(PRSchat.triggers.trade_line_id)
        else
          table.insert(chat_lines, copy2decho().." ")
        end
      end)
    end)
  end

  if not PRSchat.triggers.local_trigger_id then
    PRSchat.triggers.local_trigger_id = tempRegexTrigger("^(?<sender>.+) say(?<s>s)?, '(?<msg>.+)$", function()
      local chat_lines = {}
  
      PRSchat.triggers.local_line_id = tempRegexTrigger(".+", function()
        table.insert(chat_lines, copy2decho().." ")
        if string.ends(line, "'") then
          local concat_lines = table.concat(chat_lines)
          local result = concat_lines:sub(1, -2).."\n"
  
          PRSchat.EMCO:decho("Local", result, false)
          killTrigger(PRSchat.triggers.local_line_id)
        end
      end)
    end)
  end

  if not PRSchat.triggers.tell_trigger_id then
    PRSchat.triggers.tell_trigger_id = tempRegexTrigger("^(?<from>.+) tell(?<s>s)? (?<to>\\w+), '(?<msg>.+)$", function()
      local chat_lines = {}
  
      PRSchat.triggers.tell_line_id = tempRegexTrigger(".+", function()
        table.insert(chat_lines, copy2decho().." ")
        if string.ends(line, "'") then
          local concat_lines = table.concat(chat_lines)
          local result = concat_lines:sub(1, -2).."\n"
  
          PRSchat.EMCO:decho("Tell", result, false)
          killTrigger(PRSchat.triggers.tell_line_id)
        end
      end)
    end)
  end
end

PRSchat.initialize()

-- Procedural Realms Script (PRS) Skills Tab for Mudlet
-- by Grrtt and Stack (https://ilpdev.com/prs)
PRSskills = PRSskills or {}

local SUG = require("PRS.sug")

PRSskills.previousSkillCount = PRSskills.previousSkillCount or 0

PRSskills.scrollContainer = PRSskills.scrollContainer or Geyser.Container:new({
    name = "skillsScrollContainer",
    width = "100%",
    height = "100%",
    x = 0,
    y = 0
}, GUI.tabwindow1.Skillscenter)

PRSskills.scrollBox = PRSskills.scrollBox or Geyser.ScrollBox:new({
    name = "skillsScrollBox",
    height = "100%",
    width = "100%",
    x = 0,
    y = 0
}, PRSskills.scrollContainer)

PRSskills.labels = PRSskills.labels or {}

local SKILL_LABEL_HEIGHT = 60
local SKILL_LABEL_NO_BAR_HEIGHT = 30

function isInArray(array, target)
    for _, value in ipairs(array) do
        if value == target then
            return true
        end
    end
    return false
end

function sortSkills(skills)
    local sorted = {
        weapon = {},
        crafting = {},
        learned = {},
        artisan = {}
    }

    for i, skill in ipairs(skills) do
        local category = getSkillCategory(skill);
        skill.gmcpIndex = i
        table.insert(sorted[category], skill)
    end

    return PRSutil.tableConcat(sorted.weapon, PRSutil.tableConcat(sorted.crafting,
        PRSutil.tableConcat(sorted.artisan, sorted.learned)))
end

function getSkillCategory(skill)
    if (isInArray(skill.type, "weapon")) then
        return "weapon"
    elseif (isInArray(skill.type, "crafting")) then
        return "crafting"
    elseif (isInArray(skill.type, "artisan")) then
        return "artisan"
    elseif (isInArray(skill.type, "learned")) then
        return "learned"
    else
        echo("Skill could not be sorted: \n")
        display(skill)
    end
end

function getSkillColor(skill)
    local category = getSkillCategory(skill)
    if category == "weapon" then
        return "#ff0000"
    elseif category == "crafting" then
        return "#ff00ff"
    elseif category == "artisan" then
        return "#ffff00"
    elseif category == "learned" then
        return "#ff0000"
    end
end

function getSkillAnsiColor(skill)
    local category = getSkillCategory(skill)
    if category == "weapon" then
        return "<ansi_light_red>"
    elseif category == "crafting" then
        return "#<ansi_light_magenta>"
    elseif category == "artisan" then
        return "<ansi_light_yellow>"
    elseif category == "learned" then
        return "<ansi_light_red>"
    end
end

function showSkill(skills, container, labels, skillNum, showBar, y, color)
    local skill = skills[skillNum]

    createNewSkillLabel(skillNum, skills, container, labels, y, color, showBar)

    labels[skillNum]:show()
    container:add(labels[skillNum])

    if showBar then
        addGaugeToSkillLabel(skillNum, skills, labels, color)
        labels[skillNum].progressBar:show()
    else
        labels[skillNum].progressBar:hide()
    end

    labels[skillNum]:cecho(getSkillString(skill))
end

function createNewSkillLabel(skillNum, skills, container, labels, y, color, showBar)
    local height = SKILL_LABEL_HEIGHT
    if not showBar then
        height = SKILL_LABEL_NO_BAR_HEIGHT
    end

    if labels[skillNum] == nil then
        table.insert(labels, Geyser.Label:new({
            name = "skillName" .. skillNum,
            height = SKILL_LABEL_HEIGHT
        }, container))
    end

    labels[skillNum]:resize("100%-20px", height)
    labels[skillNum]:move(0, y)
    labels[skillNum]:setStyleSheet([[
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-right: none;
    border-left: none;
    background-color: #222;
    padding: 15px;
    padding-top: 0px;
    padding-bottom: 0px;
    font-size: 18px;
  ]])

    addGaugeToSkillLabel(skillNum, skills, labels, color)
end

function addGaugeToSkillLabel(skillNum, skills, labels, color)
    local skill = skills[skillNum]
    labels[skillNum].progressBar = labels[skillNum].progressBar or SUG:new({
        name = "skillGauge" .. skillNum,
        x = 15,
        y = "65%",
        height = 15,
        width = "90%", -- everything up to here is standard Geyser.Gauge
        updateTime = 0,
        updateEvent = "gmcp.Char.skills",
        textTemplate = "|p%",
        currentVariable = "gmcp.Char.skills[" .. skill.gmcpIndex .. "].tnl", -- if it is nil or unreachable, it will use the defaultCurrent of 50
        maxVariable = 100
    }, labels[skillNum])
    labels[skillNum].progressBar.front:setStyleSheet(string.format([[background-color: %s;
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 7;
    padding: 15px;
  ]], color))
    labels[skillNum].progressBar.back:setStyleSheet([[background-color: #303030;
    border-width: 0px;
    border-color: black;
    border-style: solid;
    border-radius: 7;
    padding: 15px;
  ]])
    labels[skillNum].progressBar.text:setStyleSheet([[
    margin-left: 10px;
  ]])
end

function getSkillString(skill)
    local skillString = ""
    local color = getSkillAnsiColor(skill)
    if (skill.level) then
        skillString = "<ansi_light_white>L" .. skill.level .. " <ansi_white>" .. skill.name .. "<br>"
    elseif (skill.rank) then
        skillString = color .. "R" .. skill.rank .. " <ansi_white>" .. skill.name
    end
    return skillString
end

function createSkills()
    local sortedSkills = sortSkills(gmcp.Char.skills)

    local currentY = 0
    for i, skill in ipairs(sortedSkills) do
        local showBar = skill.level ~= null
        local color = getSkillColor(skill)
        showSkill(sortedSkills, PRSskills.scrollBox, PRSskills.labels, i, showBar, currentY, color)
        if showBar then
            currentY = currentY + SKILL_LABEL_HEIGHT
        else
            currentY = currentY + SKILL_LABEL_NO_BAR_HEIGHT
        end
    end

    for n = #sortedSkills + 1, #PRSskills.labels, 1 do
        PRSskills.labels[n]:hide()
        PRSskills.scrollBox:remove(PRSskills.labels[n])
    end
end

function skillEventHandler()
    if (gmcp and gmcp.Char and gmcp.Char.skills and #gmcp.Char.skills ~= PRSskills.previousSkillCount) then
        createSkills()
    end
end

if skillEventHandlerId then
    killAnonymousEventHandler(skillEventHandlerId)
end -- clean up any already registered handlers for this function
skillEventHandlerId = registerAnonymousEventHandler("gmcp.Char.skills", skillEventHandler)

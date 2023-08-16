-- Procedural Realms Script (PRS) GMCP Events Core for Mudlet
-- by Dalem
-- https://ilpdev.com/prs
core = core or {}
core.events = core.events or {}

local function is_array(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end

local function remove_key(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

local function update_state_from_diff(old, diff, prefix)
    local events = {}
    for k in pairs(diff) do
        if type(diff[k]) == "table" and not is_array(diff[k]) then
            if next(diff[k]) == nil then
                old[k] = {}
            else
                old[k] = old[k] or {}

                update_state_from_diff(old[k], remove_key(diff, k), prefix .. "." .. k)
            end
        else
            old[k] = remove_key(diff, k)
        end
        table.insert(events, prefix .. "." .. k)
    end

    for _, ev in ipairs(events) do
        raiseEvent(ev)
    end
end

local function get_dropped_and_added_affects(old_affects, new_affects)
    local added_affects = {}
    local dropped_affects = {}

    if new_affects then
        table.sort(new_affects, function(left, right)
            return left.name < right.name
        end)
    end
    if old_affects then
        table.sort(old_affects, function(left, right)
            return left.name < right.name
        end)
    end

    local old_aff_idx = 1
    local new_aff_idx = 1
    local old_aff_n = table.getn(old_affects)
    local new_aff_n = table.getn(new_affects)
    while true do
        if new_aff_idx > new_aff_n and old_aff_idx > old_aff_n then
            break
        elseif old_aff_idx > old_aff_n then
            table.insert(added_affects, 1, new_affects[new_aff_idx])
            new_aff_idx = new_aff_idx + 1
        elseif new_aff_idx > new_aff_n then
            table.insert(dropped_affects, 1, old_affects[old_aff_idx])
            old_aff_idx = old_aff_idx + 1
        elseif old_affects[old_aff_idx].name == new_affects[new_aff_idx].name then
            old_aff_idx = old_aff_idx + 1
            new_aff_idx = new_aff_idx + 1
        elseif old_affects[old_aff_idx].name > new_affects[new_aff_idx].name then
            table.insert(added_affects, 1, new_affects[new_aff_idx])
            new_aff_idx = new_aff_idx + 1
        elseif old_affects[old_aff_idx].name < new_affects[new_aff_idx].name then
            table.insert(dropped_affects, 1, old_affects[old_aff_idx])
            old_aff_idx = old_aff_idx + 1
        end
    end

    return dropped_affects, added_affects
end

function core.on_gmcp_char(event, args)
    if not gmcp.Char.State then
        return
    end
    if not gmcp.Char.State.update then
        return
    end

    local diff_table = gmcp.Char.State.update

    local dropped = {}
    local added = {}
    if diff_table.affects then
        if not gmcp.Char.affects then
            gmcp.Char.affects = {}
        end
        dropped, added = get_dropped_and_added_affects(gmcp.Char.affects, diff_table.affects)
    end

    update_state_from_diff(gmcp.Char, diff_table, "gmcp.Char")

    if table.getn(dropped) > 0 then
        for i, affect in ipairs(dropped) do
            raiseEvent("affectDropped", affect.name)
        end
    end
    if table.getn(added) > 0 then
        for i, affect in ipairs(added) do
            raiseEvent("affectAdded", affect.name)
        end
    end
end

function core.on_gmcp_char_state(event, args)
    if not gmcp.Char.State then
        return
    end
    if not gmcp.Char.State.update then
        return
    end

    local diff_table = gmcp.Char.State.update

    local dropped = {}
    local added = {}
    if diff_table.affects then
        if not gmcp.Char.affects then
            gmcp.Char.affects = {}
        end
        dropped, added = get_dropped_and_added_affects(gmcp.Char.affects, diff_table.affects)
    end

    update_state_from_diff(gmcp.Char, diff_table, "gmcp.Char")

    if table.getn(dropped) > 0 then
        for i, affect in ipairs(dropped) do
            raiseEvent("affectDropped", affect.name)
        end
    end
    if table.getn(added) > 0 then
        for i, affect in ipairs(added) do
            raiseEvent("affectAdded", affect.name)
        end
    end
end

function core.initialize()
    for _, handlerID in pairs(core.events) do
        killAnonymousEventHandler(handlerID)
    end
    core.events.ongmcpchar = registerAnonymousEventHandler("gmcp.Char", "core.on_gmcp_char")
    core.events.ongmcpcharstate = registerAnonymousEventHandler("gmcp.Char.State", "core.on_gmcp_char_state")
end

function core.stop()
    for _, handlerID in pairs(core.events) do
        killAnonymousEventHandler(handlerID)
    end
end

core.initialize()

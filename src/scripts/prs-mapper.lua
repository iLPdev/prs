-- Procedural Realms Script (PRS) for Mudlet
-- by Stack (https://ilpdev.com/prs) and Dalem based on generic GMCP mapping script 
-- by Blizzard (https://worldofpa.in) based upon an MSDP script from the Mudlet
-- forums in the generic mapper thread with pieces from Jor'Mox's generic mapper
-- script and the mmpkg mapper by breakone9r.
mudlet = mudlet or {};
mudlet.mapper_script = true

map = map or {}
map.room_info = map.room_info or {}
map.prev_info = map.prev_info or {}
map.aliases = map.aliases or {}
map.events = map.events or {}
map.configs = map.configs or {}
map.configs.speedwalk_delay = .2

local defaults = {
    -- using Geyser to handle the mapper in this, since this is a totally new script
    mapper = {
        x = 0,
        y = 0,
        width = "100%",
        height = "100%"
    }
}

local terrain_types = {
    -- used to make rooms of different terrain types have different colors
    -- add a new entry for each terrain type, and set the color with RGB values
    -- each id value must be unique, terrain types not listed here will use mapper default color
    -- not used if you define these in a map XML file
    ["Tall Grass"] = {
        id = 17,
        r = 0,
        g = 128,
        b = 0
    },
    ["Grass"] = {
        id = 18,
        r = 0,
        g = 255,
        b = 0
    },
    ["Shore"] = {
        id = 19,
        r = 128,
        g = 128,
        b = 0
    },
    ["Bridge"] = {
        id = 20,
        r = 255,
        g = 255,
        b = 255
    },
    ["Road"] = {
        id = 21,
        r = 0,
        g = 128,
        b = 128
    },
    ["Steppe"] = {
        id = 22,
        r = 255,
        g = 255,
        b = 0
    },
    ["Scrublands"] = {
        id = 23,
        r = 128,
        g = 128,
        b = 0
    },
    ["Wasteland"] = {
        id = 24,
        r = 128,
        g = 0,
        b = 0
    },
    ["Fence"] = {
        id = 25,
        r = 255,
        g = 255,
        b = 255
    },
    ["River"] = {
        id = 26,
        r = 0,
        g = 0,
        b = 255
    },
    ["Lake"] = {
        id = 27,
        r = 0,
        g = 0,
        b = 255
    },
    ["Fishing Pier"] = {
        id = 28,
        r = 0,
        g = 0,
        b = 255
    },
    ["Farmland"] = {
        id = 29,
        r = 255,
        g = 255,
        b = 0
    },
    ["Deep Water"] = {
        id = 30,
        r = 0,
        g = 0,
        b = 128
    },
    ["Gate"] = {
        id = 31,
        r = 255,
        g = 255,
        b = 0
    },
    ["Nexus"] = {
        id = 32,
        r = 128,
        g = 128,
        b = 128
    },
    ["Wall"] = {
        id = 33,
        r = 64,
        g = 64,
        b = 64
    },
    ["Armor Shop"] = {
        id = 34,
        r = 255,
        g = 255,
        b = 255
    },
    ["Alchemist"] = {
        id = 35,
        r = 255,
        g = 0,
        b = 255
    },
    ["Farming Store"] = {
        id = 36,
        r = 0,
        g = 128,
        b = 0
    },
    ["Outlands Portal"] = {
        id = 37,
        r = 255,
        g = 0,
        b = 255
    },
    ["Abandoned Mine"] = {
        id = 38,
        r = 255,
        g = 0,
        b = 0
    },
    ["Shrine"] = {
        id = 39,
        r = 255,
        g = 255,
        b = 255
    },
    ["Grocery Store"] = {
        id = 40,
        r = 128,
        g = 128,
        b = 0
    },
    ["Building"] = {
        id = 41,
        r = 255,
        g = 255,
        b = 0
    },
    ["Tool Shop"] = {
        id = 42,
        r = 128,
        g = 128,
        b = 0
    },
    ["Restaurant"] = {
        id = 43,
        r = 0,
        g = 255,
        b = 0
    },
    ["Clothing Shop"] = {
        id = 44,
        r = 0,
        g = 128,
        b = 128
    },
    ["Books Shop"] = {
        id = 45,
        r = 255,
        g = 255,
        b = 0
    },
    ["Book Shop"] = {
        id = 48,
        r = 255,
        g = 255,
        b = 0
    },
    ["Leatherworker's Shop"] = {
        id = 46,
        r = 0,
        g = 255,
        b = 255
    },
    ["Weapon Shop"] = {
        id = 47,
        r = 255,
        g = 0,
        b = 0
    },
    ["Altar"] = {
        id = 49,
        r = 255,
        g = 255,
        b = 255
    },
    ["Portal Shop"] = {
        id = 50,
        r = 128,
        g = 0,
        b = 128
    },
    ["Auction House"] = {
        id = 51,
        r = 128,
        g = 0,
        b = 0
    },
    ["Underworld Shop"] = {
        id = 52,
        r = 192,
        g = 192,
        b = 192
    },
    ["Hall of Scenarios"] = {
        id = 53,
        r = 255,
        g = 0,
        b = 0
    },
    ["Employment Office"] = {
        id = 54,
        r = 255,
        g = 255,
        b = 0
    },
    ["Hall of Lessons"] = {
        id = 55,
        r = 255,
        g = 0,
        b = 255
    },
    ["Bounty Board"] = {
        id = 56,
        r = 0,
        g = 255,
        b = 0
    },
    ["Vending Machine"] = {
        id = 57,
        r = 255,
        g = 0,
        b = 255
    },
    ["Tavern Stairs"] = {
        id = 58,
        r = 255,
        g = 255,
        b = 255
    },
    ["Great Plains Portal"] = {
        id = 59,
        r = 255,
        g = 0,
        b = 255
    },
    ["Hidden Grove Portal"] = {
        id = 60,
        r = 255,
        g = 0,
        b = 255
    },
    ["Endless Sands Portal"] = {
        id = 61,
        r = 255,
        g = 0,
        b = 255
    },
    ["Frozen Peaks Portal"] = {
        id = 62,
        r = 255,
        g = 0,
        b = 255
    },
    ["Dark Woods"] = {
        id = 63,
        r = 128,
        g = 128,
        b = 128
    },
    ["Thick Woods"] = {
        id = 64,
        r = 0,
        g = 128,
        b = 0
    },
    ["Obelisk"] = {
        id = 65,
        r = 128,
        g = 0,
        b = 128
    },
    ["Spider Cave"] = {
        id = 66,
        r = 0,
        g = 128,
        b = 0
    },
    ["Tempest Hideout"] = {
        id = 67,
        r = 128,
        g = 128,
        b = 128
    },
    ["Temple"] = {
        id = 68,
        r = 128,
        g = 128,
        b = 128
    },
    ["Sparse Woods"] = {
        id = 69,
        r = 0,
        g = 255,
        b = 0
    },
    ["Statue Shrine"] = {
        id = 70,
        r = 255,
        g = 255,
        b = 0
    },
    ["Desert"] = {
        id = 71,
        r = 255,
        g = 255,
        b = 0
    },
    ["Ravine"] = {
        id = 72,
        r = 128,
        g = 128,
        b = 128
    },
    ["Dunes"] = {
        id = 73,
        r = 255,
        g = 255,
        b = 0
    },
    ["Legion Fortress"] = {
        id = 74,
        r = 255,
        g = 0,
        b = 0
    },
    ["Plateau"] = {
        id = 75,
        r = 255,
        g = 0,
        b = 0
    },
    ["Canyon"] = {
        id = 76,
        r = 128,
        g = 0,
        b = 128
    },
    ["Oasis"] = {
        id = 77,
        r = 0,
        g = 155,
        b = 0
    },
    ["Summit"] = {
        id = 78,
        r = 255,
        g = 255,
        b = 255
    },
    --  ["Ravine"] = {id = 79, r = 128, g = 128, b = 128}, -- duplicate key id reserved for later use
    ["Mountains"] = {
        id = 80,
        r = 0,
        g = 255,
        b = 255
    },
    ["Foothills"] = {
        id = 81,
        r = 255,
        g = 255,
        b = 0
    },
    ["Valley"] = {
        id = 82,
        r = 0,
        g = 128,
        b = 0
    },
    ["Bait and Tackle"] = {
        id = 83,
        r = 255,
        g = 255,
        b = 255
    },
    ["Riscacles Settlement"] = {
        id = 84,
        r = 128,
        g = 0,
        b = 128
    },
    ["Temple Entrance"] = {
        id = 85,
        r = 128,
        g = 0,
        b = 128
    },
    ["Frozen River"] = {
        id = 86,
        r = 0,
        g = 255,
        b = 255
    },
    ["Clearing"] = {
        id = 87,
        r = 0,
        g = 128,
        b = 0
    },
    ["Frozen Peak"] = {
        id = 88,
        r = 0,
        g = 0,
        b = 255
    },
    ["Obsidian Floor"] = {
        id = 89,
        r = 192,
        g = 192,
        b = 192
    },
    ["Obelisk Exit"] = {
        id = 90,
        r = 128,
        g = 0,
        b = 128
    },
    ["Permafrost"] = {
        id = 91,
        r = 0,
        g = 255,
        b = 255
    },
    ["Gold Mine Tailings"] = {
        id = 92,
        r = 255,
        g = 255,
        b = 255
    },
    ["Witch Doctor"] = {
        id = 93,
        r = 255,
        g = 0,
        b = 255
    },
    ["Combat Book Shop"] = {
        id = 94,
        r = 255,
        g = 255,
        b = 0
    },
    ["Artisan Book Shop"] = {
        id = 95,
        r = 255,
        g = 255,
        b = 0
    },
    ["Crafting Book Shop"] = {
        id = 96,
        r = 255,
        g = 255,
        b = 0
    },
    ["Scroll Scribe"] = {
        id = 97,
        r = 255,
        g = 255,
        b = 0
    }
}

-- list of possible movement directions and appropriate coordinate changes
local move_vectors = {
    n = {0, 1, 0},
    s = {0, -1, 0},
    e = {1, 0, 0},
    w = {-1, 0, 0},
    nw = {-1, 1, 0},
    ne = {1, 1, 0},
    sw = {-1, -1, 0},
    se = {1, -1, 0},
    u = {0, 0, 1},
    d = {0, 0, -1}
}

local exitmap = {
    n = 'north',
    ne = 'northeast',
    nw = 'northwest',
    e = 'east',
    w = 'west',
    s = 'south',
    se = 'southeast',
    sw = 'southwest',
    u = 'up',
    d = 'down',
    ["in"] = 'in',
    out = 'out',
    l = 'look'
}

local stubmap = {
    north = 1,
    northeast = 2,
    northwest = 3,
    east = 4,
    west = 5,
    south = 6,
    southeast = 7,
    southwest = 8,
    up = 9,
    down = 10,
    ["in"] = 11,
    out = 12,
    northup = 13,
    southdown = 14,
    southup = 15,
    northdown = 16,
    eastup = 17,
    westdown = 18,
    westup = 19,
    eastdown = 20,
    [1] = "n",
    [2] = "ne",
    [3] = "nw",
    [4] = "e",
    [5] = "w",
    [6] = "s",
    [7] = "se",
    [8] = "sw",
    [9] = "u",
    [10] = "d",
    [11] = "in",
    [12] = "out",
    [13] = "northup",
    [14] = "southdown",
    [15] = "southup",
    [16] = "northdown",
    [17] = "eastup",
    [18] = "westdown",
    [19] = "westup",
    [20] = "eastdown"
}

local reverse_dir = {
    n = "s",
    e = "w",
    s = "n",
    w = "e",
    ne = "sw",
    nw = "se",
    se = "nw",
    sw = "ne",
    d = "u",
    u = "d"
}

local short = {}
for k, v in pairs(exitmap) do
    short[v] = k
end

local function get_room_id_by_coordinates(area_name, x, y, z)
    local result = getRoomIDbyHash(area_name .. ":" .. x .. "," .. y .. "," .. z)
    if result == -1 then
        return nil
    else
        return result
    end
end

local function make_room()
    local info = map.room_info
    local coords = {info.x, -info.y, 0}
    local room_id = createRoomID()
    if not addRoom(room_id) then
        echo("Error: call to addRoom failed.\n")
    end

    setRoomIDbyHash(room_id, info.area .. ":" .. coords[1] .. "," .. coords[2] .. "," .. coords[3])

    setRoomName(room_id, info.name)

    local areas = getAreaTable()

    local area_id
    if areas[info.area] == nil then
        local areaID, err = addAreaName(info.area)
        if areaID == nil or areaID < 1 or err then
            echo("Error: new area name could not be added - error is: " .. err .. "\n")
            return
        else
            setGridMode(areaID, true)
            area_id = areaID
        end
    else
        area_id = areas[info.area]
    end

    if not area_id == getRoomArea(room_id) then
        echo("Error: room area was not set successfully.\n")
    end
    setRoomArea(room_id, area_id)
    setRoomCoordinates(room_id, coords[1], coords[2], coords[3])
    if terrain_types[info.terrain] then
        setRoomEnv(room_id, terrain_types[info.terrain].id)
    end

    for dir, _ in pairs(info.exits) do
        setExitStub(room_id, dir, true)

        local exit_coords_delta = move_vectors[dir]
        local exit_room_id = get_room_id_by_coordinates(info.area, coords[1] + exit_coords_delta[1],
            coords[2] + exit_coords_delta[2], coords[3] + exit_coords_delta[3])
        if exit_room_id ~= nill then
            connectExitStub(room_id, exit_room_id, dir)
        end
    end
end

local function shift_room(dir)
    local ID = get_room_id_by_coordinates(map.room_info.area, map.room_info.x, -map.room_info.y, 0)
    local x, y, z = getRoomCoordinates(ID)
    local x1, y1, z1 = table.unpack(move_vectors[dir])
    x = x + x1
    y = y + y1
    z = z + z1
    setRoomCoordinates(ID, x, y, z)
    updateMap()
end

local function handle_move()
    local info = map.room_info
    local room_id = get_room_id_by_coordinates(info.area, info.x, -info.y, 0)

    if not room_id then
        make_room()
    else
        local stubs = getExitStubs1(room_id)
        if stubs == nil then
            return
        end

        local areas = getAreaTable()
        local area_id = areas[info.area]
        if area_id == nil then
            echo("Error: found an existant room with an unmapped area id.\n")
            return
        end

        local coords = {info.x, -info.y, 0}

        for _, v in pairs(stubs) do
            local exit_coords_delta = move_vectors[stubmap[v]]
            local exit_room_id = get_room_id_by_coordinates(info.area, coords[1] + exit_coords_delta[1],
                coords[2] + exit_coords_delta[2], coords[3] + exit_coords_delta[3])
            if exit_room_id ~= nill then
                connectExitStub(room_id, exit_room_id, v)
            end
        end
    end
end

local function config()

    -- setting terrain colors
    for k, v in pairs(terrain_types) do
        setCustomEnvColor(v.id, v.r, v.g, v.b, 255)
    end
    -- making mapper window
    -- local info = defaults.mapper
    -- Geyser.Mapper:new({name = "myMap", x = info.x, y = info.y, width = info.width, height = info.height})
    -- clearing existing aliases if they exist
    for k, v in pairs(map.aliases) do
        killAlias(v)
    end
    map.aliases = {}
    -- making an alias to let the user shift a room around via command line
    table.insert(map.aliases, tempAlias([[^shift (\w+)$]], [[raiseEvent("shiftRoom",matches[2])]]))
    table.insert(map.aliases, tempAlias([[^make_room$]], [[make_room()]]))
end

local function check_doors(roomID, exits)
    -- looks to see if there are doors in designated directions
    -- used for room comparison, can also be used for pathing purposes
    if type(exits) == "string" then
        exits = {exits}
    end
    local statuses = {}
    local doors = getDoors(roomID)
    local dir
    for k, v in pairs(exits) do
        dir = short[k] or short[v]
        if table.contains({'u', 'd'}, dir) then
            dir = exitmap[dir]
        end
        if not doors[dir] or doors[dir] == 0 then
            return false
        else
            statuses[dir] = doors[dir]
        end
    end
    return statuses
end

local continue_walk, timerID
continue_walk = function(new_room)
    if not walking then
        return
    end
    -- calculate wait time until next command, with randomness
    local wait = map.configs.speedwalk_delay or 0
    if wait > 0 and map.configs.speedwalk_random then
        wait = wait * (1 + math.random(0, 100) / 100)
    end
    -- if no wait after new room, move immediately
    if new_room and map.configs.speedwalk_wait and wait == 0 then
        new_room = false
    end
    -- send command if we don't need to wait
    if not new_room then
        send(table.remove(map.walkDirs, 1))
        -- check to see if we are done
        if #map.walkDirs == 0 then
            walking = false
        end
    end
    -- make tempTimer to send next command if necessary
    if walking and (not map.configs.speedwalk_wait or (map.configs.speedwalk_wait and wait > 0)) then
        if timerID then
            killTimer(timerID)
        end
        timerID = tempTimer(wait, function()
            continue_walk()
        end)
    end
end

function map.speedwalk(roomID, walkPath, walkDirs)
    roomID = roomID or speedWalkPath[#speedWalkPath]
    local areas = getAreaTable()
    local area_id = areas[gmcp.Char.room.area]
    if area_id == nil then
        echo("Error: could not identify the current area.\n")
        return
    end
    local current_room_id = get_room_id_by_coordinates(gmcp.Char.room.area, gmcp.Char.room.x, -gmcp.Char.room.y, 0)
    if current_room_id == nil then
        echo("Error: could not find the current room in the map.\n")
        return
    end

    getPath(current_room_id, roomID)
    walkPath = speedWalkPath
    walkDirs = speedWalkDir
    if #speedWalkPath == 0 then
        echo("No path to chosen room found.", false, true)
        return
    end
    table.insert(walkPath, 1, current_room_id)
    -- go through dirs to find doors that need opened, etc
    -- add in necessary extra commands to walkDirs table
    local k = 1
    repeat
        local id, dir = walkPath[k], walkDirs[k]
        if exitmap[dir] or short[dir] then
            local door = check_doors(id, exitmap[dir] or dir)
            local status = door and door[dir]
            if status and status > 1 then
                -- if locked, unlock door
                if status == 3 then
                    table.insert(walkPath, k, id)
                    table.insert(walkDirs, k, "unlock " .. (exitmap[dir] or dir))
                    k = k + 1
                end
                -- if closed, open door
                table.insert(walkPath, k, id)
                table.insert(walkDirs, k, "open " .. (exitmap[dir] or dir))
                k = k + 1
            end
        end
        k = k + 1
    until k > #walkDirs
    if map.configs.use_translation then
        for k, v in ipairs(walkDirs) do
            walkDirs[k] = map.configs.lang_dirs[v] or v
        end
    end
    -- perform walk
    walking = true
    if map.configs.speedwalk_wait or map.configs.speedwalk_delay > 0 then
        map.walkDirs = walkDirs
        continue_walk()
    else
        for _, dir in ipairs(walkDirs) do
            send(dir)
        end
        walking = false
    end
end

function doSpeedWalk()
    if #speedWalkPath ~= 0 then
        map.speedwalk(nil, speedWalkPath, speedWalkDir)
    else
        echo("No path to chosen room found.", false, true)
    end
end

function map.eventHandler(event, ...)
    if event == "gmcp.room.info" then
        if gmcp.room.info.zone == "Battlefield" then
            return
        end
        map.prev_info = map.room_info
        map.room_info = {
            vnum = gmcp.room.info.num,
            area = gmcp.room.info.zone,
            x = tonumber(gmcp.room.info.x),
            y = tonumber(gmcp.room.info.y),
            name = gmcp.room.info.name,
            terrain = gmcp.room.info.terrain,
            exits = table.deepcopy(gmcp.room.info.exits)
        }
        for k, v in pairs(map.room_info.exits) do
            map.room_info.exits[k] = tonumber(v)
        end
        if map.prev_info.area and (map.prev_info.area ~= map.room_info.area) then
            if gmcp.room.info.instanced then
                deleteArea(gmcp.room.info.zone)
            end
        end
        handle_move()
    elseif event == "shiftRoom" then
        local dir = exitmap[arg[1]] or arg[1]
        if not table.contains(exits, dir) then
            echo("Error: Invalid direction '" .. dir .. "'.")
        else
            shift_room(dir)
        end
    elseif event == "sysConnectionEvent" then
        config()
    end
end

if map.events.room_info_id then
    killAnonymousEventHandler(map.events.room_info_id)
end -- clean up any already registered handlers for this function
map.events.room_info_id = registerAnonymousEventHandler("gmcp.room.info", "map.eventHandler")
if map.events.shift_room_id then
    killAnonymousEventHandler(map.events.shift_room_id)
end -- clean up any already registered handlers for this function
map.events.shift_room_id = registerAnonymousEventHandler("shiftRoom", "map.eventHandler")
if map.events.connect_id then
    killAnonymousEventHandler(map.events.connect_id)
end -- clean up any already registered handlers for this function
map.events.connect_id = registerAnonymousEventHandler("sysConnectionEvent", "map.eventHandler")
if map.events.centering_id then
    killAnonymousEventHandler(map.events.centering_id)
end -- clean up any already registered handlers for this function
map.events.centering_id = registerAnonymousEventHandler("gmcp.Char.room", function(event, args)

    if gmcp.Char.room.area == "Battlefield" then
        return
    end

    local room_id = get_room_id_by_coordinates(gmcp.Char.room.area, gmcp.Char.room.x, -gmcp.Char.room.y, 0)
    if room_id ~= nil then
        centerview(room_id)
    end
end)

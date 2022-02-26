-- Procedural Realms Mapping Script for Mudlet v0.4.0
-- by Stack (https://ilpdev.com/prs) based on generic GMCP mapping script 
-- by Blizzard (https://worldofpa.in) based upon an MSDP script from the Mudlet
-- forums in the generic mapper thread with pieces from Jor'Mox's generic mapper
-- script and the mmpkg mapper by breakone9r.

map = map or {}
map.room_info = map.room_info or {}
map.prev_info = map.prev_info or {}
map.aliases = map.aliases or {}
map.configs = map.configs or {}
map.configs.speedwalk_delay = 0

local defaults = {
    -- using Geyser to handle the mapper in this, since this is a totally new script
    mapper = {x = 0, y = 0, width = "100%", height = "100%"},
}

local terrain_types = {
    -- used to make rooms of different terrain types have different colors
    -- add a new entry for each terrain type, and set the color with RGB values
    -- each id value must be unique, terrain types not listed here will use mapper default color
    -- not used if you define these in a map XML file
    ["Tall Grass"] = {id = 17, r = 0, g = 128, b = 0},
    ["Grass"] = {id = 18, r = 0, g = 255, b = 0},
    ["Shore"] = {id = 19, r = 128, g = 128, b = 0},
    ["Bridge"] = {id = 20, r = 255, g = 255, b = 255},
    ["Road"] = {id = 21, r = 0, g = 128, b = 128},
    ["Steppe"] = {id = 22, r = 255, g = 255, b = 0},
    ["Scrublands"] = {id = 23, r = 128, g = 128, b = 0},
    ["Wasteland"] = {id = 24, r = 128, g = 0, b = 0},
    ["Fence"] = {id = 25, r = 255, g = 255, b = 255},    
}

-- list of possible movement directions and appropriate coordinate changes
local move_vectors = {
    n = {0,1,0}, s = {0,-1,0}, e = {1,0,0}, w = {-1,0,0},
    nw = {-1,1,0}, ne = {1,1,0}, sw = {-1,-1,0}, se = {1,-1,0},
    u = {0,0,1}, d = {0,0,-1}
}

local exitmap = {
    n = 'north',    ne = 'northeast',   nw = 'northwest',   e = 'east',
    w = 'west',     s = 'south',        se = 'southeast',   sw = 'southwest',
    u = 'up',       d = 'down',         ["in"] = 'in',      out = 'out',
    l = 'look'
}

local stubmap = {
    north = 1,      northeast = 2,      northwest = 3,      east = 4,
    west = 5,       south = 6,          southeast = 7,      southwest = 8,
    up = 9,         down = 10,          ["in"] = 11,        out = 12,
    northup = 13,   southdown = 14,     southup = 15,       northdown = 16,
    eastup = 17,    westdown = 18,      westup = 19,        eastdown = 20,
    [1] = "n",      [2] = "ne",         [3] = "nw",         [4] = "e",
    [5] = "w",      [6] = "s",          [7] = "se",         [8] = "sw",
    [9] = "u",     [10] = "d",          [11] = "in",        [12] = "out",
    [13] = "northup", [14] = "southdown", [15] = "southup", [16] = "northdown",
    [17] = "eastup", [18] = "westdown", [19] = "westup",    [20] = "eastdown",
}

local short = {}
for k,v in pairs(exitmap) do
    short[v] = k
end

local function make_room()
    local info = map.room_info
    local coords = {0,0,0}
    addRoom(info.vnum)
	  setRoomName(info.vnum, info.name)
    local areas = getAreaTable()
    local areaID = areas[info.area]
    if not areaID then
        areaID = addAreaName(info.area)
    else
        coords = {getRoomCoordinates(map.prev_info.vnum)}
        local shift = {0,0,0}
        for k,v in pairs(info.exits) do
            if v == map.prev_info.vnum and move_vectors[k] then
                shift = move_vectors[k]
                break
            end
        end
        for n = 1,3 do
            coords[n] = coords[n] - shift[n]
        end
        -- map stretching
        local overlap = getRoomsByPosition(areaID,coords[1],coords[2],coords[3])
        if not table.is_empty(overlap) then
            local rooms = getAreaRooms(areaID)
            local rcoords
            for _,id in ipairs(rooms) do
                rcoords = {getRoomCoordinates(id)}
                for n = 1,3 do
                    if shift[n] ~= 0 and (rcoords[n] - coords[n]) * shift[n] <= 0 then
                        rcoords[n] = rcoords[n] - shift[n]
                    end
                end
                setRoomCoordinates(id,rcoords[1],rcoords[2],rcoords[3])
            end
        end
    end
    setRoomArea(info.vnum, areaID)
    setRoomCoordinates(info.vnum, coords[1], coords[2], coords[3])
    if terrain_types[info.terrain] then
        setRoomEnv(info.vnum, terrain_types[info.terrain].id)
    end
    for dir, id in pairs(info.exits) do
        -- need to see how special exits are represented to handle those properly here
        if getRoomName(id) then
            setExit(info.vnum, id, dir)
        else
            setExitStub(info.vnum, dir, true)
        end
    end
end

local function shift_room(dir)
    local ID = map.room_info.vnum
    local x,y,z = getRoomCoordinates(ID)
    local x1,y1,z1 = table.unpack(move_vectors[dir])
    x = x + x1
    y = y + y1
    z = z + z1
    setRoomCoordinates(ID,x,y,z)
    updateMap()
end

local function handle_move()
    local info = map.room_info
    if not getRoomName(info.vnum) then
        make_room()
    else
        local stubs = getExitStubs1(info.vnum)
		if stubs then
          for _, n in ipairs(stubs) do
              local dir = stubmap[n]
              local id = info.exits[dir]
              -- need to see how special exits are represented to handle those properly here
              if id and getRoomName(id) then
                  setExit(info.vnum, id, dir)
              end
          end
		end
    end
    centerview(map.room_info.vnum)
end

local function config()
		
    -- setting terrain colors
    for k,v in pairs(terrain_types) do
        setCustomEnvColor(v.id, v.r, v.g, v.b, 255)
    end
    -- making mapper window
    -- local info = defaults.mapper
    -- Geyser.Mapper:new({name = "myMap", x = info.x, y = info.y, width = info.width, height = info.height})
    -- clearing existing aliases if they exist
    for k,v in pairs(map.aliases) do
        killAlias(v)
    end
    map.aliases = {}
    -- making an alias to let the user shift a room around via command line
    table.insert(map.aliases,tempAlias([[^shift (\w+)$]],[[raiseEvent("shiftRoom",matches[2])]]))
	table.insert(map.aliases,tempAlias([[^make_room$]],[[make_room()]]))
end

local function check_doors(roomID,exits)
    -- looks to see if there are doors in designated directions
    -- used for room comparison, can also be used for pathing purposes
    if type(exits) == "string" then exits = {exits} end
    local statuses = {}
    local doors = getDoors(roomID)
    local dir
    for k,v in pairs(exits) do
        dir = short[k] or short[v]
        if table.contains({'u','d'},dir) then
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
    if not walking then return end
    -- calculate wait time until next command, with randomness
    local wait = map.configs.speedwalk_delay or 0
    if wait > 0 and map.configs.speedwalk_random then
        wait = wait * (1 + math.random(0,100)/100)
    end
    -- if no wait after new room, move immediately
    if new_room and map.configs.speedwalk_wait and wait == 0 then
        new_room = false
    end
    -- send command if we don't need to wait
    if not new_room then
        send(table.remove(map.walkDirs,1))
        -- check to see if we are done
        if #map.walkDirs == 0 then
            walking = false
        end
    end
    -- make tempTimer to send next command if necessary
    if walking and (not map.configs.speedwalk_wait or (map.configs.speedwalk_wait and wait > 0)) then
        if timerID then killTimer(timerID) end
        timerID = tempTimer(wait, function() continue_walk() end)
    end
end

function map.speedwalk(roomID, walkPath, walkDirs)
    roomID = roomID or speedWalkPath[#speedWalkPath]
    getPath(map.room_info.vnum, roomID)
    walkPath = speedWalkPath
    walkDirs = speedWalkDir
    if #speedWalkPath == 0 then
        map.echo("No path to chosen room found.",false,true)
        return
    end
    table.insert(walkPath, 1, map.room_info.vnum)
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
                    table.insert(walkPath,k,id)
                    table.insert(walkDirs,k,"unlock " .. (exitmap[dir] or dir))
                    k = k + 1
                end
                -- if closed, open door
                table.insert(walkPath,k,id)
                table.insert(walkDirs,k,"open " .. (exitmap[dir] or dir))
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
        for _,dir in ipairs(walkDirs) do
            send(dir)
        end
        walking = false
    end
end

function doSpeedWalk()
    if #speedWalkPath ~= 0 then
        map.speedwalk(nil, speedWalkPath, speedWalkDir)
    else
        echo("No path to chosen room found.",false,true)
    end
end


function map.eventHandler(event,...)
    if event == "gmcp.room.info" then
        map.prev_info = map.room_info
        map.room_info = {
          vnum = tonumber(gmcp.room.info.num),
          area = gmcp.room.info.zone,
          name = gmcp.room.info.name,
          terrain = gmcp.room.info.terrain,
          exits = gmcp.room.info.exits
        }
        for k,v in pairs(map.room_info.exits) do
            map.room_info.exits[k] = tonumber(v)
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

registerAnonymousEventHandler("gmcp.room.info","map.eventHandler")
registerAnonymousEventHandler("shiftRoom","map.eventHandler")
registerAnonymousEventHandler("sysConnectionEvent", "map.eventHandler")
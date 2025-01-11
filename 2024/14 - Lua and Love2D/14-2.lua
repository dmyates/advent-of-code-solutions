local function moveGuards(guards, mapWidth, mapHeight)
    for _, guard in ipairs(guards) do
        guard.x = guard.x + guard.vx
        guard.y = guard.y + guard.vy
        -- wrap at the edges
        if guard.x < 1 then
            guard.x = guard.x + mapWidth
        elseif guard.x > mapWidth then
            guard.x = guard.x - mapWidth
        end
        if guard.y < 1 then
            guard.y = guard.y + mapHeight
        elseif guard.y > mapHeight then
            guard.y = guard.y - mapHeight
        end
    end
end

local function calculateSafety(guards, mapWidth, mapHeight)
    local quadrants = {0, 0, 0, 0}
    local centerX = math.ceil(mapWidth / 2)
    local centerY = math.ceil(mapHeight / 2)

    -- Count robots in each quadrant
    for _, guard in ipairs(guards) do
        -- Skip robots exactly on center lines
        if guard.x == centerX or guard.y == centerY then
            goto continue
        end
        -- Count each quadrant
        if guard.y < centerY then
            if guard.x < centerX then
                quadrants[1] = quadrants[1] + 1  -- Top-left
            elseif guard.x > centerX then
                quadrants[2] = quadrants[2] + 1  -- Top-right
            end
        elseif guard.y > centerY then
            if guard.x < centerX then
                quadrants[3] = quadrants[3] + 1  -- Bottom-left
            elseif guard.x > centerX then
                quadrants[4] = quadrants[4] + 1  -- Bottom-right
            end
        end
        ::continue::
    end

    return quadrants[1] * quadrants[2] * quadrants[3] * quadrants[4]
end

local function visualizeMap(guards, mapWidth, mapHeight)
    -- Initialize empty map
    local map = {}
    for y = 1, mapHeight do
        map[y] = {}
        for x = 1, mapWidth do
            map[y][x] = 0
        end
    end

    -- Count guards at each position
    for _, guard in ipairs(guards) do
        local x, y = math.floor(guard.x), math.floor(guard.y)
        map[y][x] = map[y][x] + 1
    end

    -- Create string representation
    local result = {}
    for y = 1, mapHeight do
        local row = {}
        for x = 1, mapWidth do
            row[x] = map[y][x] > 0 and tostring(map[y][x]) or "."
        end
        table.insert(result, table.concat(row))
    end

    return table.concat(result, "\n")
end

local file = io.open("input.txt", "r")

local guards = {}
for line in file:lines() do
    local startX, startY, vx, vy = line:match("p=(%d+),(%d+) v=(%-?%d+),(%-?%d+)")
    -- ^ I can't believe it's not regex!
    table.insert(guards, {
        x = tonumber(startX+1), -- +1 to account for Lua's 1-based indexing
        y = tonumber(startY+1), -- +1 to account for Lua's 1-based indexing
        vx = tonumber(vx),
        vy = tonumber(vy),
    })
end

file:close()

local mapWidth = 101
local mapHeight = 103

-- Put your own number here
local lowSafety = 160000000

print("At least one of these should be a tree.")
for i = 1, 10000 do
    moveGuards(guards, mapWidth, mapHeight)
    local safety = calculateSafety(guards, mapWidth, mapHeight)
    if safety < lowSafety then
        print("---")
        print(safety)
        print(i)
        print(visualizeMap(guards, mapWidth, mapHeight))
        print("---")
    end
end
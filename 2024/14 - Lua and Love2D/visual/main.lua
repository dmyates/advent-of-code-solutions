function love.load()
    TILE_SIZE = 8
    MAP_WIDTH = 101  -- Width in tiles
    MAP_HEIGHT = 103  -- Height in tiles
    MIN_SLOW_MOTION = 0.04
    MAX_SLOW_MOTION = 2048.0

    love.window.setMode(MAP_WIDTH * TILE_SIZE, MAP_HEIGHT * TILE_SIZE)

    gameSpeed = 0.04
    elapsedTime = 0
    isPaused = false
    guards = {}
    
    
    -- Load guards from file
    local file = io.open("input.txt", "r")
    if file then
        for line in file:lines() do
            local tileX, tileY, vx, vy = line:match("p=(%d+),(%d+) v=(%-?%d+),(%-?%d+)")
            if tileX then
                table.insert(guards, {
                    x = tonumber(tileX) * TILE_SIZE + TILE_SIZE/2, -- middle of the tile
                    y = tonumber(tileY) * TILE_SIZE + TILE_SIZE/2,
                    vx = tonumber(vx),
                    vy = tonumber(vy),
                    moveAccumX = 0, -- accumulate partial movement for grid snap
                    moveAccumY = 0
                })
            end
        end
        file:close()
    end
end

function love.update(dt)
    -- Don't update if paused
    if isPaused then return end
    
    -- Apply speed to dt
    dt = dt * gameSpeed
    
    elapsedTime = elapsedTime + dt
    for _, guard in ipairs(guards) do
        -- Accumulate movement
        guard.moveAccumX = guard.moveAccumX + guard.vx * dt
        guard.moveAccumY = guard.moveAccumY + guard.vy * dt
        
        -- Move when accumulated movement reaches one full tile
        while guard.moveAccumX >= 1 do
            guard.x = guard.x + TILE_SIZE
            guard.moveAccumX = guard.moveAccumX - 1
        end
        while guard.moveAccumX <= -1 do
            guard.x = guard.x - TILE_SIZE
            guard.moveAccumX = guard.moveAccumX + 1
        end
        while guard.moveAccumY >= 1 do
            guard.y = guard.y + TILE_SIZE
            guard.moveAccumY = guard.moveAccumY - 1
        end
        while guard.moveAccumY <= -1 do
            guard.y = guard.y - TILE_SIZE
            guard.moveAccumY = guard.moveAccumY + 1
        end
        
        -- Wrap around screen edges
        if guard.x < 0 then
            guard.x = guard.x + MAP_WIDTH * TILE_SIZE
        elseif guard.x > MAP_WIDTH * TILE_SIZE then
            guard.x = guard.x - MAP_WIDTH * TILE_SIZE
        end
        if guard.y < 0 then
            guard.y = guard.y + MAP_HEIGHT * TILE_SIZE
        elseif guard.y > MAP_HEIGHT * TILE_SIZE then
            guard.y = guard.y - MAP_HEIGHT * TILE_SIZE
        end
    end
end

function love.keypressed(key)
    -- Pause
    if key == "space" then
        isPaused = not isPaused 
    elseif key == "left" then
        -- Slow down
        gameSpeed = math.max(MIN_SLOW_MOTION, gameSpeed * 0.5)
    elseif key == "right" then
        -- Speed up
        gameSpeed = math.min(MAX_SLOW_MOTION, gameSpeed * 2.0)
    end
end

function love.draw()
    -- Grid 
    love.graphics.setColor(0.2, 0.2, 0.2)
    for i = 0, love.graphics.getWidth(), TILE_SIZE do
        love.graphics.line(i, 0, i, love.graphics.getHeight())
    end
    for i = 0, love.graphics.getHeight(), TILE_SIZE do
        love.graphics.line(0, i, love.graphics.getWidth(), i)
    end

    -- Draw guards
    for _, guard in ipairs(guards) do
        love.graphics.setColor(0.5, 0.5, 1)
        love.graphics.rectangle("fill", guard.x-TILE_SIZE/2, guard.y-TILE_SIZE/2, TILE_SIZE/2, TILE_SIZE/2)
        
        -- sightline
        love.graphics.setColor(1, 0, 0)
        local lineLength = TILE_SIZE
        love.graphics.line(
            guard.x,
            guard.y,
            guard.x + math.cos(math.atan2(guard.vy, guard.vx)) * lineLength,
            guard.y + math.sin(math.atan2(guard.vy, guard.vx)) * lineLength
        )
    end

    -- Time
    love.graphics.setColor(1, 1, 1)  -- white
    love.graphics.print(string.format("Time: %.1f", elapsedTime), 10, 10)

    -- Pause and speed
    love.graphics.setColor(1, 1, 1)
    if isPaused then
        love.graphics.print("PAUSED", 10, 30)
    end
    love.graphics.print(string.format("Speed: %.2fx", gameSpeed), 10, 50)
end

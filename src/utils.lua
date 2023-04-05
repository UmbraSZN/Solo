--returns normalised vector between two points 
function normalise(x1, y1, x2, y2) --x and y positions of the points
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx^2 + dy^2)
    return dx/length, dy/length
end

--reduces cooldowns
function manageCd(dt, cd) --change in time and cooldown time    
    if cd > 0 then
        cd = cd - dt
    elseif cd < 0 then
        cd = 0
    end
    return cd
end

--clear non-collider tables
function clearTable(tableToClear) --table to clear
    for i = #tableToClear, 1, -1 do
        table.remove(tableToClear, i)
    end
end

--clear collider tables
function clearColliderTable(tableToClear) --table to clear
    for i = #tableToClear, 1, -1 do
        tableToClear[i]:destroy()
        table.remove(tableToClear, i)
    end
end

--clear everything (for going to a new map etc)
function destroyAll()
    clearColliderTable(walls)
    clearColliderTable(enemies)
    clearColliderTable(gates)
    clearTable(effects)
end

function drawGame()
    
    cam:attach()
        drawMap()
        --world:draw()
        local cx, cy = cam:mousePosition()
        love.graphics.push("all")
        love.graphics.setColor(0, 1, 0) --green
        love.graphics.circle("fill", cx, cy, 1)
        love.graphics.pop()
        enemies:draw()
        effects:draw()
        player:draw()
    cam:detach()
    
end



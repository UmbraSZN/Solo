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
function clearTable(table) --table to clear
    for i = #table, 1, -1 do
        table.remove(table, i)
    end
end

--clear collider tables
function clearColliderTable(table) --table to clear
    for i = #table, 1, -1 do
        table[i]:destroy()
        table.remove(table, i)
    end
end

--clear everything (for going to a new map etc)
function destroyAll()
    clearColliderTable(walls)
    clearColliderTable(enemies)
    clearTable(effects)
end


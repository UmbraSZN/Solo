function normalise(x1, y1, x2, y2) --returns normalised vector between two points 
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx^2 + dy^2)
    return dx/length, dy/length
end

function manageCd(dt, cd) --change in time and cooldown time    
    if cd > 0 then
        cd = cd - dt
    elseif cd < 0 then
        cd = 0
    end
    return cd
end



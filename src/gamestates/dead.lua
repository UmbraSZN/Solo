local dead = {}
local timer


function dead:enter()
    timer = 5
end

function dead:update(dt)
    timer = manageCd(dt, timer)
    if timer == 0 then
        gamestate.switch(game, "Overworld Map")
    end
end

function dead:draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local font = love.graphics.getFont()

    love.graphics.printf("Game Over", ww/2 - font:getWidth("Game Over")/2, wh/2 - font:getHeight("Game Over")/2, ww)
end




return dead


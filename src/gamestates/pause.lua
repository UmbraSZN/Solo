local pause = {}

function pause:enter(from)
    self.from = from
    buttons:destroyAll()
    buttons:menu("paused")
end

function pause:leave()
    buttons:destroyAll()
end

function pause:resume()
    buttons:menu("paused")
end

function pause:resize()
    buttons:destroyAll()
    buttons:menu("paused")
end

function pause:update(dt)
    buttons:update(dt)
end

function pause:draw()
    self.from:draw() --add blur
    buttons:draw()

    local cx, cy = love.mouse.getPosition()
    love.graphics.push("all")
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", cx, cy, 1)
    love.graphics.pop()
end

function pause:mousepressed(x, y, button)

    if button == 1 then --lmb
        buttons:click(x, y)
    end
end

function pause:keypressed(key)
    if key == "escape" then
        gamestate.pop()
    end
end


return pause 


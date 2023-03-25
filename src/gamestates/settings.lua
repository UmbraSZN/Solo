local settings = {}

function settings:enter()
    buttons:destroyAll()
    buttons:menu("settings")
end

function settings:leave()
    buttons:destroyAll()
end

function settings:resume()
    buttons:menu("settings")
end

function settings:resize()
    buttons:destroyAll()
    buttons:menu("settings")
end

function settings:update(dt)
    buttons:update(dt)
end

function settings:draw()
    buttons:draw()

    local cx, cy = love.mouse.getPosition()
    love.graphics.push("all")
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", cx, cy, 1)
    love.graphics.pop()
end

function settings:mousepressed(x, y, button)

    if button == 1 then --lmb
        buttons:click(x, y)
    end
end

function settings:keypressed(key)
    if key == "escape" then
        gamestate.pop()
    end
end


return settings


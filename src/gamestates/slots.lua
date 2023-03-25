local slots = {}

function slots:enter()
    buttons:destroyAll()
    buttons:menu("slots")
end

function slots:leave()
    buttons:destroyAll()
end

function slots:resize()
    buttons:destroyAll()
    buttons:menu("slots")
end

function slots:update(dt)
    buttons:update(dt)  
end

function slots:draw()
    buttons:draw()

    local cx, cy = love.mouse.getPosition()
    love.graphics.push("all")
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", cx, cy, 1)
    love.graphics.pop()
end

function slots:mousepressed(x, y, button)

    if button == 1 then --lmb
        buttons:click(x, y)
    end
end

return slots


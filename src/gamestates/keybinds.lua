local keybinds = {}

function keybinds:enter()
    buttons:destroyAll()
    buttons:menu("keybinds")
end

function keybinds:leave()
    buttons:destroyAll()
end

function keybinds:resize()
    buttons:destroyAll()
    buttons:menu("keybinds")
end

function keybinds:update(dt)
    buttons:update(dt)
end

function keybinds:draw()
    buttons:draw()

    local cx, cy = love.mouse.getPosition()
    love.graphics.push("all")
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", cx, cy, 1)
    love.graphics.pop()
end

function keybinds:mousepressed(x, y, button)

    if button == 1 then --lmb
        buttons:click(x, y)
    end
end

function keybinds:keypressed(key)
    if key == "escape" then
        gamestate.pop()
    end
end

return keybinds


local menu = {}

function menu:enter()
    buttons:menu("main")
end

function menu:update(dt)
    buttons:update(dt)
end

function menu:draw()
    buttons:draw()

    local cx, cy = love.mouse.getPosition()
    love.graphics.push("all")
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", cx, cy, 1)
    love.graphics.pop()
end

function menu:mousepressed(x, y, button)

    if button == 1 then --lmb
        buttons:click(x, y)
    end
end

function menu:resize(w, h)
    buttons:destroyAll()
    gamestate.switch(menu)
end

return menu


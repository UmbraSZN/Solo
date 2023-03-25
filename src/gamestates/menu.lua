local menu = {}

function menu:enter() 
    --gamepaused = false
    buttons:destroyAll()
    buttons:menu("main")
end

function menu:resume()
    buttons:menu("main")
end

function menu:resize()
    buttons:destroyAll()
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


return menu


--pop (leave, no enter (does resume))
--push (same as switch, but no leave)
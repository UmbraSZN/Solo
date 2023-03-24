local menu = {}

function menu:enter()
    buttons:new(
    "Play",
    50, 
    50, 
    200, 
    100, 
    function()
        print("Entering game")
        gamestate.switch(game)
     end)
end

function menu:update(dt)
    buttons:update(dt)
end

function menu:draw()
    love.graphics.push("all")    
    love.graphics.setColor(0, 0, 0) --black
    buttons:draw()
    love.graphics.pop() 

    local cx, cy = love.mouse.getPosition()
    love.graphics.circle("fill", cx, cy, 1)
end

function menu:mousepressed(x, y, button)

    if button == 1 then --lmb
        buttons:click(x, y)
    end
end



return menu


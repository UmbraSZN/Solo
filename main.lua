function love.load()
    love.graphics.setBackgroundColor(22/255, 22/255, 22/255)
    require("src/startup/gameStart")
    startGame()
end

function love.update(dt)
    player:update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end



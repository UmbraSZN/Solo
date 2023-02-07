function love.load()
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



function love.load()
    require("src/startup/gameStart")
    startGame()

    local testCollider = world:newRectangleCollider(100, 150, 80, 200)
    testCollider:setType("static")

end

function love.update(dt)
    player:update(dt)
    world:update(dt)
    cam:update(dt)
end

function love.draw()
    cam:attach()
        world:draw()
    cam:detach()
end



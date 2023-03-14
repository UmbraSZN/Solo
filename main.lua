function love.load()
    require("src/startup/gameStart")
    startGame()

    world:setQueryDebugDrawing(true)
    local testCollider = world:newRectangleCollider(100, 150, 80, 200)
    testCollider:setType("static")
    testCollider:setCollisionClass("Wall")
    

end

function love.update(dt)
    player:update(dt)
    enemies:update(dt)
    world:update(dt)
    cam:update(dt)
end

function love.draw()
    cam:attach()
        world:draw()
        local cx, cy = cam:mousePosition()
        love.graphics.circle("fill", cx, cy, 1)
    cam:detach()
end


function love.keypressed(key)
     
    if key == "o" then 
        local testEnemy = enemies:spawn(120, 40, "test")

    elseif key == "l" then
        local testDummy = world:newCircleCollider(0, 0, 20)
        testDummy.health = 100
        testDummy:setCollisionClass("Enemy")

    elseif key == "q" and player.state == "default" and player.dashTimer == 0 then --dodge/dash
        player:dodge()

    elseif key == "p" then
        print("X: ", player:getX())
        print("Y: ", player:getY())
        
    end

end

function love.mousepressed(x, y, button)

    local cx, cy = cam:mousePosition() --position of mouse in relation to the world

    if button == 1 then --left click

        --check if clicking a button

        if player.state == "default" then --player is in normal gameplay
            player:lightAttack(cx, cy)

        end

    end

end






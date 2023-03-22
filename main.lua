function love.load()
    require("src/startup/gameStart")
    startGame()

    world:setQueryDebugDrawing(true)
    local testCollider = world:newRectangleCollider(100, 150, 80, 200)
    testCollider:setType("static")
    testCollider:setCollisionClass("Wall")
    
    buttons:new("Test", 500, 200)
end

function love.update(dt)
    if gamestate == "game" then
        player:update(dt)
        enemies:update(dt)
        gates:update(dt)
        world:update(dt)
        effects:update(dt)
        cam:update(dt)
    
    elseif gamestate == "menu" then
        
    end
end

function love.draw()
    if gamestate == "game" then
        cam:attach()
            world:draw()
            local cx, cy = cam:mousePosition()
            love.graphics.circle("fill", cx, cy, 1)
            effects:draw()
            --player:draw()
        cam:detach()
        love.graphics.print("Health: ".. player.health, 10, 10)
    
    elseif gamestate == "menu" then
        love.graphics.print("Press enter to continue", 10, 10)
        
        buttons:draw()
    end
end


function love.keypressed(key)
    if gamestate == "game" then
        
        if key == "o" then --debugging
            local testEnemy = enemies:spawn(120, 40, "test")

        elseif key == "l" then --debugging
            local testDummy = world:newCircleCollider(0, 0, 20)
            testDummy.health = 100
            testDummy:setCollisionClass("Enemy")

        elseif key == "q" and player.state == "default" and player.dashTimer == 0 then --dodge/dash
            player:dodge()

        elseif key == "r" and player.state == "default" and player.heavyTimer == 0 then --heavy attack
            --player:heavyAttack()
            player:attack("heavy")

        elseif key == "f" and player.state == "default" and player.blockTimer == 0 then --block/parry
            player.state = "blocking"
            
        elseif key == "p" then --debugging
            print("X: ", player:getX())
            print("Y: ", player:getY())

        elseif key == "i" then --debugging
            --spawn gate
            gates:spawn(50, 80, "E")
        end

    elseif gamestate == "menu" then

        if key == "return" then --enter
            gamestate = "game"
        end
    end
end

function love.keyreleased(key)

    if gamestate == "game" then
        if key == "f" and player.state == "blocking" then
            player.state = "default"
            player.blockDuration = 0
            player.blockTimer = player.blockCd
        end

    end
end

function love.mousepressed(x, y, button)

    if gamestate == "game" then
        local cx, cy = cam:mousePosition() --position of mouse in relation to the world

        if button == 1 then --left click

            --check if clicking a button

            if player.state == "default" then --player is in normal gameplay
                --player:lightAttack(cx, cy)
                player:attack("light")

            end

        end

    elseif gamestate == "menu" then

        if button == 1 then --left click

        end

    end

end






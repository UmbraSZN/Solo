local game = {}

function game:update(dt)
    if gamepaused then
        --update pause menu?
    return end --leaves the function
    player:update(dt)
    enemies:update(dt)
    gates:update(dt)
    world:update(dt)
    effects:update(dt)
    cam:update(dt)
end

function game:draw()
    --make blurry if game paused
    cam:attach()
        world:draw()
        local cx, cy = cam:mousePosition()
        love.graphics.push("all")
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("fill", cx, cy, 1)
        love.graphics.pop()
        effects:draw()
        --player:draw()
    cam:detach()
    love.graphics.print("Health: ".. player.health, 10, 10)

    if gamepaused then
        local ww = love.graphics.getWidth()
        local wh = love.graphics.getHeight()
        love.graphics.printf("Paused", 0, wh/2 - 50, ww, "center")--make buttons
    end
end

function game:enter()
    gamepaused = false
end

function game:keypressed(key)

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

    elseif key == "escape" then
        --gamestate.switch(menu) --change
        gamepaused = not gamepaused
        if gamepaused then
            print("Paused")
        else 
            print("Resumed")
        end

    end

end

function game:keyreleased(key)
    if key == "f" and player.state == "blocking" then
        player.state = "default"
        player.blockDuration = 0
        player.blockTimer = player.blockCd
    end
end

function game:mousepressed(x, y, button)
    local cx, cy = cam:mousePosition() --position of mouse in relation to the world

    if button == 1 then --left click

        --check if clicking a button?

        if player.state == "default" and not gamepaused then --player is in normal gameplay
            player:attack("light")

        end

    end
end

return game


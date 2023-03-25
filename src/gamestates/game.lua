local game = {}


function game:enter(previous)
    -- if previous ~= game then
    --     gamepaused = false
    -- end
    buttons:destroyAll()
end

function game:resume() --may not need because leave is called with pop
    --buttons:destroyAll()
end

function game:resize(w, h) --may not need
    -- buttons:destroyAll()
    -- if gamepaused then
    --     buttons:menu("paused")
    -- end
end

function game:update(dt)
    -- if gamepaused then
    --     if table.getn(buttons) == 0 then --doesn't add buttons every frame
    --         buttons:menu("paused") 
    --     else
    --         buttons:update(dt)
    --     end
    -- return end --leaves the update function
    player:update(dt)
    enemies:update(dt)
    gates:update(dt)
    world:update(dt)
    effects:update(dt)
    cam:update(dt)
end

function game:draw()
    -- if gamepaused then 
    --     --blur background
    -- end
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

    -- if gamepaused then
    --     buttons:draw()
    -- end
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
        -- gamepaused = not gamepaused
        -- if gamepaused then
        --     print("Paused")
        -- else 
        --     print("Resumed")
        -- end
        gamestate.push(pause)

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
    
    -- if not gamepaused then
        if button == 1 then --left click

            if player.state == "default" then --player is in normal gameplay
                player:attack("light")

            end

        end

    -- else
        if button == 1 then
            buttons:click(x, y)
        end
    -- end
end


return game


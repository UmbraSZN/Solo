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
        --give iframes
        player.state = "dashing"
        player.iFrames = player.dashDuration
        player.animTimer = player.dashDuration
        player.dashTimer = player.dashCd

        local vx, vy = 0, 0 --vectors 
        if love.keyboard.isDown("a") then
            print("x")
            vx = -1
        end

        if love.keyboard.isDown("d") then
            vx = 1
        end

        if love.keyboard.isDown("s") then
            vy = 1
        end

        if love.keyboard.isDown("w") then
            vy = -1
        end

        if vx ~= 0 and vy ~= 0 then
            vx = vx/math.sqrt(2)
            vy = vy/math.sqrt(2)
        end

        if vx == 0 and vy == 0 then
            --perform spot-dodge
            --longer dodge frames?
        end

        player:setLinearDamping(0.5)
        player:setLinearVelocity(vx * 200, vy * 200)

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
            
            player.state = "attacking"
            player.animTimer = player.lightAttackDuration
            

            local px, py = player:getPosition()
            local dx, dy = cx - px, cy - py
            local length = math.sqrt(dx^2 + dy^2)
            local vx, vy = dx/length, dy/length

            local query = world:queryCircleArea(px + vx * 40, py + vy * 40, 35, {"Enemy"})

            for _, e in ipairs(query) do
                --check for block
                e.health = e.health - 10 --change damage value based on a variable later
                e.state = "stunned"
                e.stunTimer = player.lightStun

                --knockback
                e:setLinearVelocity(vx * 50, vy * 50)
                

                
                if e.health <= 0 then
                    for i, v in ipairs(enemies) do
                        if e == v then
                            table.remove(enemies, i)
                        end
                    end
                    e:destroy()
                    --drop items
                    --give exp
                end

            end

        end

    end

end






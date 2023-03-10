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
    end

    if key == "l" then
        local testDummy = world:newCircleCollider(0, 0, 20)
        testDummy.health = 100
        testDummy:setCollisionClass("Enemy")
    end

end

function love.mousepressed(x, y, button)

    local cx, cy = cam:mousePosition() --position of mouse in relation to the world

    if button == 1 then --left click


        --check if clicking a button

        if player.state == "default" then --player is in normal gameplay
            
            player.state = "attacking"
            player.cd = player.lightAttackCd
            

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






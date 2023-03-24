player = world:newCircleCollider(0, 0, 20)
player:setCollisionClass("Player")
player.speed = 80
player.health = 100
player.state = "default"
player.iFrames = 0
player.animTimer = 0 --change how this works
player.stunTimer = 0
player.attackTimer = 0
player.lightAttackDuration = 0.2 --dont need anymore?
player.lightStun = 0.1
player.heavyAttackDuration = 0.35
player.heavyStun = 0.15
player.heavyCd = 4
player.heavyTimer = 0
player.dashDuration = 0.4
player.dashCd = 2.5
player.dashTimer = 0
player.blockTimer = 0
player.blockCd = 2
player.blockDuration = 0
player.parryStun = 0.1

--click lmb
--enter attacking state
--spawn sword
--wait 0.2 ish seconds
--swing 
--damage enemies in query


function player:update(dt)

    if player.state ~= "stunned" and player.state ~= "dashing" then
        player:setLinearDamping(0)

        if love.keyboard.isDown("f") and player.state == "blocking" then
            player.blockDuration = player.blockDuration + dt
        end

        --moving player(w, a, s, d)
        local vx, vy = 0, 0 --vectors
        if love.keyboard.isDown("a") then
            vx = player.speed * -1
        end

        if love.keyboard.isDown("d") then
            vx = player.speed
        end

        if love.keyboard.isDown("s") then
            vy = player.speed
        end

        if love.keyboard.isDown("w") then
            vy = player.speed * -1
        end

        if vx ~= 0 and vy ~= 0 then
            vx = vx/math.sqrt(2)
            vy = vy/math.sqrt(2)
        end

        player:setLinearVelocity(vx, vy)

        if player.dashTimer > 0 then
            player.dashTimer = player.dashTimer - dt
            if player.dashTimer < 0 then
                player.dashTimer = 0
            end
        end

    elseif player.state == "stunned" then

        if player.stunTimer > 0 then
            player.stunTimer = player.stunTimer - dt
            if player.stunTimer <= 0 then
                player.stunTimer = 0
                player.state = "default"
            end
        end 

    elseif player.state == "dashing" then

        if player.animTimer > 0 then 
            player.animTimer = player.animTimer - dt
            if player.animTimer <= 0 then
                player.animTimer = 0
                player.state = "default"
            end
        end
    end

    if player.state == "attacking" then

        player.attackTimer = player.attackTimer + dt


        local px, py = player:getPosition()
        local cx, cy = cam:mousePosition()
        local dx, dy = cx - px, cy - py
        local length = math.sqrt(dx^2 + dy^2)
        local vx, vy = dx/length, dy/length

        local rot = math.atan2(vy, vx)

        if player.attackTimer >= player.animTimer then

            --attack
            player.state = "default"
            player.attackTimer = 0
            player.animTimer = 0
            
            effects:spawn(px + vx * 40, py + vy * 40, "swordSwipe", rot - math.pi/4)
            local query = world:queryCircleArea(px + vx * 40, py + vy * 40, 35, {"Enemy"})
        
            for _, e in ipairs(query) do
                --check for block
                e.health = e.health - 10 --change damage value based on a variable later
                e.state = "stunned"
                e.stunTimer = player.lightStun
        
                --knockback
                e:setLinearVelocity(vx * 50, vy * 50)
                
        
                --move to enemy module?
                if e.health <= 0 then

                    for i = #enemies, 1, -1 do
                        if e == enemies[i] then
                            table.remove(enemies, i)
                        end
                    end
                    e:destroy()
                    --drop items
                    --give exp
                end
        
            end

        else

            --draw sword

            effects:spawn(px, py, "sword", rot + math.pi/4)

        end

    end

--[[
    if player.animTimer > 0 then 
        player.animTimer = player.animTimer - dt
        if player.animTimer <= 0 then
            player.animTimer = 0
            player.state = "default"
        end
    end
]]
    if player.iFrames > 0 then
        player.iFrames = player.iFrames - dt
        if player.iFrames < 0 then
            player.iFrames = 0
        end
    end

    if player.blockTimer > 0 then
        player.blockTimer = player.blockTimer - dt
        if player.blockTimer <= 0 then
            player.blockTimer = 0
        end
    end

    if player.heavyTimer > 0 then
        player.heavyTimer = player.heavyTimer - dt
        if player.heavyTimer <= 0 then
            player.heavyTimer = 0
        end
    end


end

-- function player:draw() 

--     --add an indication if hit

--     if player.state == "attacking" then
--         --swSpr, px+swX, py+swY, swordRot, nil, nil, swSpr:getWidth()/2, swSpr:getHeight()/2
--         local px, py = player:getPosition()
--         local cx, cy = cam:mousePosition()
--         local dx, dy = cx - px, cy - py
--         local length = math.sqrt(dx^2 + dy^2)
--         local vx, vy = dx/length, dy/length
    
--         local rot = math.atan2(vy, vx)

--         local swordSprite = love.graphics.newImage(sprites.sword)
--         love.graphics.draw(swordSprite, px + vx * 20, py + vy * 20, rot + math.pi/4, nil, nil, swordSprite:getWidth()/2, swordSprite:getHeight()/2)
--     end
-- end

function player:dodge()
    player.state = "dashing"
    player.iFrames = player.dashDuration
    player.animTimer = player.dashDuration
    player.dashTimer = player.dashCd

    local vx, vy = 0, 0 --vectors 
    if love.keyboard.isDown("a") then
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
end

function player:attack(type)
    
    player.state = "attacking"

    if type == "light" then
        --set light values
        player.animTimer = 0.35 --windup

    elseif type == "heavy" then
        --set heavy values
        player.animTimer = 0.55 --windup
    end

    
end

--add player slowdown when attacking?


--[[
function player:lightAttack(cx, cy)

    player.state = "attacking"
    player.animTimer = player.lightAttackDuration
    

    local px, py = player:getPosition()
    local dx, dy = cx - px, cy - py
    local length = math.sqrt(dx^2 + dy^2)
    local vx, vy = dx/length, dy/length

    local rot = math.atan2(vy, vx)
    --effects:spawn(px + vx * 20, py + vy * 20, "sword", rot + math.pi/4)
    effects:spawn(px + vx * 40, py + vy * 40, "swordSwipe", rot - math.pi/4)
    local query = world:queryCircleArea(px + vx * 40, py + vy * 40, 35, {"Enemy"})

    for _, e in ipairs(query) do
        --check for block
        e.health = e.health - 10 --change damage value based on a variable later
        e.state = "stunned"
        e.stunTimer = player.lightStun

        --knockback
        e:setLinearVelocity(vx * 50, vy * 50)
        

        --move to enemy module?
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
]]

--[[
function player:heavyAttack()
    player.state = "attacking"
    player.animTimer = player.heavyAttackDuration
    player.heavyTimer = player.heavyCd
    
    local cx, cy = cam:mousePosition()
    local px, py = player:getPosition()
    local dx, dy = cx - px, cy - py
    local length = math.sqrt(dx^2 + dy^2)
    local vx, vy = dx/length, dy/length

    local query = world:queryCircleArea(px + vx * 50, py + vy * 50, 45, {"Enemy"})

    for _, e in ipairs(query) do
        e.health = e.health - 15 --change damage value based on a variable later
        e.state = "stunned"
        e.stunTimer = player.heavyStun

        --knockback
        e:setLinearVelocity(vx * 80, vy * 80)
        

        --move to enemy module?
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
]]
--make attacks happen at the end of the wind up timer so there is a time frame where you can react to an attack to parry.
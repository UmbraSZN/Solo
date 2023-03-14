player = world:newCircleCollider(0, 0, 20)
player:setCollisionClass("Player")
player.speed = 80
player.health = 100
player.state = "default"
player.iFrames = 0
player.animTimer = 0
player.stunTimer = 0
player.lightAttackDuration = 0.2
player.lightStun = 0.1
player.dashDuration = 0.4
player.dashCd = 2.5
player.dashTimer = 0

function player:update(dt)

    if player.state ~= "stunned" and player.state ~= "dashing" then
        player:setLinearDamping(0)

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
    end


    if player.animTimer > 0 then 
        player.animTimer = player.animTimer - dt
        if player.animTimer <= 0 then
            player.animTimer = 0
            player.state = "default"
        end
    end

    if player.iFrames > 0 then
        player.iFrames = player.iFrames - dt
        if player.iFrames < 0 then
            player.iFrames = 0
        end
    end
end

function player:dodge()
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
end

function player:lightAttack(cx, cy)
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
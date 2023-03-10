player = world:newCircleCollider(50, 50, 20)
player:setCollisionClass("Player")
player.speed = 80
player.health = 100
player.state = "default"
player.iFrames = 0
player.animTimer = 0
player.lightAttackDuration = 0.2
player.lightStun = 0.2
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

        player:setLinearVelocity(0, 0)
        --add timer?
        player.state = "default"
        
    end


    if player.animTimer > 0 then 
        player.animTimer = player.animTimer - dt
        if player.animTimer < 0 then
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


player = world:newCircleCollider(50, 50, 20)
player:setCollisionClass("Player")
player.speed = 80
player.health = 100
player.state = "default"
player.cd = 0
player.lightAttackCd = 0.2
player.lightStun = 0.2

function player:update(dt)

    if player.state ~= "stunned" then

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

    else

        player:setLinearVelocity(0, 0)
        --add timer?
        player.state = "default"
    end


    if player.cd > 0 then 
        player.cd = player.cd - dt
        if player.cd < 0 then
            player.cd = 0
            player.state = "default"
        end
    end


end


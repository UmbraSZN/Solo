player = world:newCircleCollider(0, 0, 20) --x, y, radius
player:setCollisionClass("Player")
player.speed = 120
player.health = 100
player.state = "default"
player.iFrames = 0
player.animTimer = 0 
player.dashCdTimer = 0
player.stunTimer = 0
player.attackTimer = 0
player.dashDuration = 0.25
player.dashCd = 1



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


    elseif player.state == "stunned" then

        player.stunTimer = manageCd(dt, player.stunTimer)
        if player.stunTimer == 0 then
            player.state = "default"
        end

    elseif player.state == "dashing" then

        player.animTimer = manageCd(dt, player.animTimer)
        if player.animTimer == 0 then
            player.state = "default"
        end
    end

    if player.state ~= "dashing" then
        player.dashCdTimer = manageCd(dt, player.dashCdTimer)
    end

    if player.state == "attacking" then
        player.state = "default"
        local px, py = player:getPosition()
        local mx, my = cam:mousePosition()
        local vx, vy = normalise(px, py, mx, my)
        local rot = math.atan2(vy, vx)

        effects:spawn(px + vx * 40, py + vy * 40, "swordSwipe", rot - math.pi/4)
        local query = world:queryCircleArea(self:getX() + vx * 40, self:getY() + vy * 40, 35, {"Enemy"})
        for _, e in ipairs(query) do
            e:hit(10, 0.1, vx, vy) --change damage value based on a variable later
        end

    else
        player.attackTimer = manageCd(dt, player.attackTimer)

    end

    player.iFrames = manageCd(dt, player.iFrames)
    

    player:checkDead()
end

function player:dodge()
    player.state = "dashing"
    player.iFrames = player.dashDuration
    player.animTimer = player.dashDuration
    player.dashCdTimer = player.dashCd

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
        player.iFrames = 0
        player.animTimer = 0
        player.dashCdTimer = 0
    end

    player:setLinearDamping(0.5)
    player:setLinearVelocity(vx * 400, vy * 400)
end


function player:attack(type)

    player.state = "attacking"

    if type == "light" then
        --set light values
        player.attackTimer = 0.2

    elseif type == "ability1" then
        --set ability values
        
    end

end


function player:hit(dmg, stun, vx, vy)

    if self.iFrames == 0 then  --can be hit        
        --deal damage
        self.stunTimer = stun
        self.state = "stunned"
        self.health = self.health - dmg
        self:setLinearVelocity(vx * 500, vy * 500)
    else
        --dodge (no damage)
        print("dodged")
    end

end

function player:checkDead()
    if player.health <= 0 then
        --love.event.quit()
    end
end



--possible plan:
--could make queries in direction of player for range of 200 + radius
--if query hits a collider stops
--if query successful then start following player
--when distance is larger than 300 + radius return to spawn
--when within a certain range attack 
--if the player is attacking then attempt block or dodge (weighted on type)



--[[

    function enemy:update(dt)
        local dist = self:checkRange()
        local rad = self:getRadius()

        if self.state == "default" then
            if dist < 250 + rad and dist >= 70 + rad then
                self:moveToPlayer(dt)

            elseif dist >= 250 + rad then 
                self:returnToSpawn(dt)

            elseif dist < 70 + rad then
                self:setLinearVelocity(0,0)
                --reduce speed?
                self:decideAction(dt)

            end

        elseif self.state == "attacking" then
            --add same attack code as player
            self.attackTimer = self.attackTimer + dt

            local px, py = player:getPosition()
            local ex, ey = self:getPosition()

            local dx, dy = px - ex, py - ey
            local length = math.sqrt(dx^2 + dy^2)
            local vx, vy = dx/length, dy/length

            local rot = math.atan2(vy, vx)

            if self.attackTimer >= self.animTimer then

                --attack
                self.state = "default"
                self.attackTimer = 0
                self.animTimer = 0
                
                effects:spawn(ex + vx * 40, ey + vy * 40, "swordSwipe", rot - math.pi/4)
                local query = world:queryCircleArea(ex + vx * 40, ey + vy * 40, 35, {"Player"})
            
                for _, p in ipairs(query) do
    
                    local parryCheck = p:hit(10, self.lightStun, vx, vy)
                    if parryCheck then
                        self.stunTimer = parryCheck
                        self.state = "stunned"
                        
                    end
                
                end
            else

                effects:spawn(ex, ey, "sword", rot + math.pi/4)

            end


        elseif self.state == "attemptDodge" then
            
            if self.reactionTimer <= 0 then
                --dash
                self.state = "dashing"
                self.reactionTimer = 0
                --set iframes and duration
                self.iFrames = self.dashDuration

            else
    
                self.reactionTimer = self.reactionTimer - dt
            end

        elseif self.state == "dashing" then
            --dash timer and iframes
            self.iFrames = self.iFrames - dt
            if self.iFrames <= 0 then
                self.state = "default"
                self.iFrames = 0
            end

        elseif self.state == "attemptBlock" then
            
            if self.reactionTimer <= 0 then
                --block
                self.state = "blocking"
                self.reactionTimer = 0

            else
    
                self.reactionTimer = self.reactionTimer - dt
            end

        elseif self.state == "blocking" then
            self.blockDuration = self.blockDuration + dt
            if player.state == "default" then
                self.blockDuration = 0 
                self.state = "default"
            end

        elseif self.state == "stunned" then
            --reduce stun timer
            self.stunTimer = self.stunTimer - dt
            if self.stunTimer <= 0 then
                self.state = "default"
                self.stunTimer = 0
            end

        end

        if self.state ~= "attacking" then
            self.attackTimer = 0
        end
    end

    function enemy:decideAction(dt)

        if self.state == "default" then

            if player.state == "attacking" then
                --block/dodge/hit
                local action = love.math.random(1, 2)
                if action == 1 then
                    --block
                    self.reactionTimer = self.baseReactionTime + reactionTimeRng()
                    self.state = "attemptBlock"

                elseif action == 2 then
                    --dodge
                    self.reactionTimer = self.baseReactionTime + reactionTimeRng()
                    self.state = "attemptDodge"

                end
            else
                --attack
                self.animTimer = 0.4
                self.state = "attacking"
            end
        end
    end


    function enemy:checkRange()
        local ex, ey = self:getPosition()
        local px, py = player:getPosition()

        local dx, dy = px - ex, py - ey
        local length = math.sqrt(dx^2 + dy^2)

        return length
    end

    function enemy:moveToPlayer(dt)
        local ex, ey = self:getPosition()
        local px, py = player:getPosition()

        local dx, dy = px - ex, py - ey
        local length = math.sqrt(dx^2 + dy^2)
        local vx, vy = dx/length, dy/length

        self:setLinearVelocity(vx * self.speed, vy * self.speed)
    end


    function enemy:returnToSpawn(dt)
        local ex, ey = self:getPosition()
        local xToSpawn, yToSpawn = self.spawnX - ex, self.spawnY - ey
        local lengthToSpawn = math.sqrt(xToSpawn^2 + yToSpawn^2)
        if lengthToSpawn <= 5 then
            self:setLinearVelocity(0, 0)
            --enemy:wander() --implement
        else
            local vx, vy = xToSpawn/lengthToSpawn, yToSpawn/lengthToSpawn
            self:setLinearVelocity(vx * self.speed, vy * self.speed)
        end
    end
    
    function enemy:hit(dmg, stun, vx, vy) --damage, stun and vectors of the attack

        if self.iFrames <= 0 then

            if self.blockDuration < 0.2 and self.state == "blocking" then
                --parried (no damage)
                print("enemy parried")
                player.stunTimer = self.lightStun

            elseif self.state == "blocking" then
                --blocked (reduced damage + reduced stun)
                print("enemy blocked")
                self.stunTimer = stun
                self.state = "stunned"
                self.health = self.health - dmg/2
                self:setLinearVelocity(vx * 50, vy * 50)
                
            else
                --full damage
                self.stunTimer = stun
                self.state = "stunned"
                self.health = self.health - dmg
                self:setLinearVelocity(vx * 50, vy * 50)
                
            end

        else
            --dodge (no damage)
            print("enemy dodged")
        end
    end

]]



--[[
enemies = {}

function enemies:spawn(x, y, type) --spawn a new enemy

    local enemy
    if type == "test" then
        enemy = world:newCircleCollider(x, y, 20)
        enemy.speed = 50
        enemy.health = 100
        enemy.spawnX = x 
        enemy.spawnY = y 
        enemy.state = "default"
        enemy.stunTimer = 0
        enemy.animTimer = 0
        enemy.attackTimer = 0
        enemy.lightStun = 0.1
        enemy.lightAttackDuration = 0.2
        enemy.dashDuration = 0.4
        
        
    elseif type == "" then
        --code for different mob type

    end

    function enemy:move(dt)
        
        local radius = self:getRadius()
        local enemyX, enemyY = self:getPosition()
        local playerX, playerY = player:getPosition()

        local dx, dy = playerX - enemyX, playerY - enemyY
        local length = math.sqrt(dx^2 + dy^2)
        
        if length < 200 + radius and length >= 50 + radius then --within detection range
            --move to player
            --add code to consider colliders
            local vx, vy = dx/length, dy/length 
            self:setLinearVelocity(vx * self.speed, vy * self.speed)

        elseif length >= 200 + radius then 
            --return to spawn
            local xToSpawn, yToSpawn = self.spawnX - enemyX, self.spawnY - enemyY
            local lengthToSpawn = math.sqrt(xToSpawn^2 + yToSpawn^2)
            if lengthToSpawn <= 5 then
                enemy:wander()
            else
                local dx, dy = xToSpawn/lengthToSpawn, yToSpawn/lengthToSpawn
                self:setLinearVelocity(dx * self.speed, dy * self.speed)
            end

            

        elseif length < 50 + radius then --make value larger?
            --enter combat mode
            --self:setLinearVelocity(0,0)
            --self:combat(dt, dx, dy, length)
            
            if player.state == "attacking" then
                --attempt block or dodge

                local dodgeRoll = love.math.random(1, 20)
                if dodgeRoll == love.math.random(1, 20) then
                    print("dodge")
                    self:dodge()
                else
                    local blockRoll = love.math.random(1, 5)
                    if blockRoll == love.math.random(1, 5) then
                        print("block")
                        --self:block()
                    end
                end

            else 
                --attack
                print("attack")
                --self:attack()
            end
        end

    end


    function enemy:attack()


    end


    function enemy:block()


    end


    function enemy:dodge()
        self.state = "dashing"
        self.iFrames = self.dashDuration
        self.animTimer = self.dashDuration

        local enemyX, enemyY = self:getPosition()
        local playerX, playerY = player:getPosition()
        local dx, dy = playerX - enemyX, playerY - enemyY
        local length = math.sqrt(dx^2 + dy^2)

        local vx, vy = dx/length, dy/length

        self:setLinearDamping(0.5)
        self:setLinearVelocity(-vx * 200, -vy * 200)
    end







--[[
    function enemy:combata(dt, dx, dy, length) --old combat
        
        if self.state == "default" then

            self.state = "attacking"
            self.animTimer = self.lightAttackDuration
            local vx, vy = dx/length, dy/length
            local query = world:queryCircleArea(self:getX() + vx * 40, self:getY() + vy * 40, 35, {"Player"})
            
            --add a delay/cooldown on attacking
            for _, plr in ipairs(query) do
                --check for block
                --check if player can be damaged
                if plr.iFrames == 0 then --not invincible

                    if plr.blockDuration == 0 then
                        plr.health = plr.health - 10 --change damage value based on a variable later
                        plr.stunTimer = self.lightStun
                        plr.state = "stunned"
                        plr:setLinearVelocity(vx * 50, vy * 50)
                    
                    elseif plr.blockDuration < 0.5 then
                        --parry
                        print("parried")
                        self.stunTimer = plr.parryStun
                        self.state = "stunned"

                    else
                        --block
                        print("blocked")
                        plr.health = plr.health - 10 * 0.5 --change damage value based on a variable later
                        plr.stunTimer = self.lightStun
                        plr.state = "stunned"
                        plr:setLinearVelocity(vx * 50, vy * 50) --reduce knockback?
                    end

                else
                    print("dodged")
                    --play atttack dodge sound
                end
            end
        end
    end
]]

--[[
    function enemy:combat(dt, dx, dy, length)

        if self.state == "default" then

            self.state = "attacking"
            self.animTimer = 0.35
            self.attackTimer = self.attackTimer + dt
            local vx, vy = dx/length, dy/length

            local rot = math.atan2(vy, vx)

            if self.attackTimer >= self.animTimer then
                self.state = "default"
                self.attackTimer = 0
                self.animTimer = 0

                local ex, ey = self:getPosition()
                effects:spawn(ex + vx * 40, ey + vy * 40, "swordSwipe", rot - math.pi/4)
                local query = world:queryCircleArea(ex + vx * 40, ey + vy * 40, 35, {"Player"})

                for _, p in ipairs(query) do
                    p.health = p.health - 10 --change damage value based on a variable later
                    p.state = "stunned"
                    p.stunTimer = self.lightStun
            
                    --knockback
                    p:setLinearVelocity(vx * 50, vy * 50)
                end

            else

                effects:spawn(ex, ey, "sword", rot + math.pi/4)

            end
        end

    end


    function enemy:wander()
        self:setLinearVelocity(0,0)
        --need to add code
        --randomly move around near spawn point
    end

    enemy:setCollisionClass("Enemy")
    table.insert(enemies, enemy)
end


function enemies:update(dt)

    for _, e in ipairs(enemies) do

        e:setLinearDamping(0)
        if e.state == "default" then
            e:move()

        elseif e.state == "attacking" then
            


        elseif e.state == "stunned" then
            e.stunTimer = e.stunTimer - dt
            if e.stunTimer < 0 then
                e.stunTimer = 0
                e.state = "default"
            end
        
        elseif e.state == "dashing" then
            if e.animTimer > 0 then
                e.animTimer = e.animTimer - dt
                if e.animTimer <= 0 then
                    e.animTimer = 0
                    e.state = "default"
                end
            end

        elseif e.state == "blocking" then
            

        end
        
        -- if e.animTimer > 0 then
        --     e.animTimer = e.animTimer - dt
        --     if e.animTimer <= 0 then
        --         e.animTimer = 0
        --         e.state = "default"
        --     end
        -- end

    end

end
]]
--local query = world:queryRectangleArea(self:getX() + vx * 20, self:getY() + vy * 20, 40, 100, {"Player"}) 
--rectangles may be better to use when attacking as they give better htiboxes however there was an issue with them interacting with circles 




--move death check into enemy and player respectivly - checked every update 
--move damage check into enemy and player respectivly - checked every update
--add radius to enemy distance checking


function reactionTimeRng()
    local rng = 1 --placeholder
    while rng > 0.2 do
        rng = love.math.random()
    end
    return rng - 0.1 --reaction time either improved or worse
end
enemies = {}
local projectiles = {}

function enemies:spawn(x, y, type)

    local enemy
    if type == "testclose" then
        enemy = world:newCircleCollider(x, y, 20)
        enemy.speed = 80
        enemy.health = 100
        enemy.damage = 10
        enemy.spawnX = x 
        enemy.spawnY = y 
        enemy.state = "default"
        enemy.animTimer = 0
        enemy.attackTimer = 0
        enemy.stunTimer = 0
        enemy.knockback = 1

        function enemy:update(dt)
            local dist = self:checkRange()
            local rad = self:getRadius()
    
            if self.state == "default" then
                if dist < 250 + rad then
                    self:moveToPlayer(dt)
    
                elseif dist >= 250 + rad then 
                    self:returnToSpawn(dt)
    
                end
    
            elseif self.state == "stunned" then
                self.stunTimer = manageCd(dt, self.stunTimer)
                if self.stunTimer == 0 then
                    self.state = "default"
                end
    
            end
    
            if self:enter("Player") then
                
                local vx, vy = normalise(self:getX(), self:getY(), player:getX(), player:getY())
                player:hit(enemy.damage, 0.1, vx, vy)
            end
    
        end
    
    elseif type == "testrange" then
        enemy = world:newCircleCollider(x, y, 20)
        enemy.speed = 40
        enemy.health = 100
        enemy.damage = 20
        enemy.spawnX = x
        enemy.spawnY = y
        enemy.state = "default"
        enemy.animTimer = 0
        enemy.attackDelay = 0
        enemy.stunTimer = 0
        enemy.knockback = 4

        function enemy:update(dt)
            local dist = self:checkRange()
            local rad = self:getRadius()
    
            if self.state == "default" then
                if dist < 400 + rad and dist >= 200 + rad then
                    self:moveToPlayer(dt)
                    self:rangeAttack(dt)
    
                elseif dist >= 400 + rad then 
                    self:returnToSpawn(dt)

                else
                    self:moveAwayFromPlayer(dt)
                    self:rangeAttack(dt)
                
                end
    
            elseif self.state == "stunned" then
                self.stunTimer = manageCd(dt, self.stunTimer)
                if self.stunTimer == 0 then
                    self.state = "default"
                end

    
            end

            self.attackDelay = manageCd(dt, self.attackDelay)
            if self.attackDelay == 0 then
                if self.state ~= "stunned" then
                    self.state = "default"
                end
            end
    
        end

    end

    function enemy:rangeAttack(dt)
        self.state = "attacking"
        self.attackDelay = 1.5
        local ex, ey = self:getPosition()
        local vx, vy = normalise(ex, ey, player:getX(), player:getY())

        --create projectile
        local projectile = world:newCircleCollider(ex, ey, 5) --bullet
        projectile:setCollisionClass("EnemyProj")
        table.insert(projectiles, projectile)
        projectile.timeToLive = 1.2
        projectile:setLinearVelocity(vx * 500, vy * 500)
    end

    function enemy:checkRange()
        local ex, ey = self:getPosition()
        local px, py = player:getPosition()

        local dx, dy = px - ex, py - ey
        local length = math.sqrt(dx^2 + dy^2)

        return length
    end

    function enemy:moveAwayFromPlayer(dt)
        local ex, ey = self:getPosition()
        local px, py = player:getPosition()
        local vx, vy = normalise(ex, ey, px, py)

        self:setLinearVelocity(-vx * self.speed, -vy * self.speed)
    end

    function enemy:moveToPlayer(dt)
        local ex, ey = self:getPosition()
        local px, py = player:getPosition()
        local vx, vy = normalise(ex, ey, px, py)

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

        self.stunTimer = stun
        self.state = "stunned"
        self.health = self.health - dmg
        self:setLinearVelocity(vx * 50 * self.knockback, vy * 50 * self.knockback)
        
    end


    enemy:setCollisionClass("Enemy")
    table.insert(enemies, enemy)
end


function enemies:update(dt)

    projectiles:update(dt)
    for _, e in ipairs(enemies) do
        e:update(dt)

    end

    --kill enemies
    for i = #enemies, 1, -1 do
        if enemies[i].health <= 0 then --add loot drop
            enemies[i]:destroy()
            table.remove(enemies, i)
        end
    end

end



function projectiles:update(dt)
    local toDelete = {}
    for i, proj in ipairs(projectiles) do
        proj.timeToLive = manageCd(dt, proj.timeToLive)
        if proj.timeToLive == 0 then
            table.insert(toDelete, proj)
        end

        if proj:enter("Player") or proj:enter("Wall") then
            table.insert(toDelete, proj)
        end
    end


    for i = #projectiles, 1, -1 do
        for i, projToDel in pairs(toDelete) do
            if projectiles[i] == projToDel then
                projectiles[i]:destroy()
                table.remove(projectiles, i)
            end
        end
    end
end



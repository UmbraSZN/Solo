enemies = {}
local projectiles = {}

function enemies:spawn(x, y, type)

    local enemy
    if type == "testclose" then
        enemy = world:newCircleCollider(x, y, 8)
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

        local g = anim8.newGrid(16, 17, sprites.skeleton:getWidth(), sprites.skeleton:getHeight())
        enemy.animations = {} 
        enemy.animations.left = anim8.newAnimation(g("1-6", 1), 0.15)
        enemy.animations.right = anim8.newAnimation(g("1-6", 2), 0.15)
        enemy.animations.up = anim8.newAnimation(g("1-6", 3), 0.15)
        enemy.animations.down = anim8.newAnimation(g("1-6", 4), 0.15)
        enemy.anim = enemy.animations.down

        function enemy:update(dt)
            local dist = self:checkRange()
            local rad = self:getRadius()
    
            if self.state == "default" then
                if dist < 150 + rad then
                    self:moveToPlayer(dt)
    
                elseif dist >= 150 + rad then 
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

            local vx, vy = self:getLinearVelocity()
            local rot = math.atan2(vy, vx)
            if rot == 0 then return end 
            if rot < math.pi/4 and rot > -math.pi/4 then
                self.anim = self.animations.right
            elseif rot <= 3*math.pi/2 and rot >= math.pi/4 then
                self.anim = self.animations.down
            elseif rot >= -3*math.pi/4 and rot <= -math.pi/4 then
                self.anim = self.animations.up
            else 
                self.anim = self.animations.left
            end

            self.anim:update(dt)
    
        end
    
    elseif type == "testrange" then
        enemy = world:newCircleCollider(x, y, 8)
        enemy.speed = 50
        enemy.health = 100
        enemy.damage = 20
        enemy.spawnX = x
        enemy.spawnY = y
        enemy.state = "default"
        enemy.animTimer = 0
        enemy.attackDelay = 0
        enemy.stunTimer = 0
        enemy.knockback = 4

        local g = anim8.newGrid(16, 17, sprites.skeleton:getWidth(), sprites.skeleton:getHeight())
        enemy.animations = {}
        enemy.animations.left = anim8.newAnimation(g("1-6", 1), 0.09)
        enemy.animations.right = anim8.newAnimation(g("1-6", 2), 0.09)
        enemy.animations.up = anim8.newAnimation(g("1-6", 3), 0.09)
        enemy.animations.down = anim8.newAnimation(g("1-6", 4), 0.09)
        enemy.anim = enemy.animations.down

        function enemy:update(dt)
            local dist = self:checkRange()
            local rad = self:getRadius()
    
            if self.state == "default" then
                if dist < 150 + rad and dist >= 75 + rad then
                    self:moveToPlayer(dt)
                    self:rangeAttack(dt)
    
                elseif dist >= 150 + rad then 
                    self:returnToSpawn(dt)

                elseif dist <= 70 then
                    self:moveAwayFromPlayer(dt)
                    self:rangeAttack(dt)

                else
                    self:setLinearVelocity(0, 0)
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

            --angle enemy based on their movement direction
            local vx, vy = self:getLinearVelocity()
            local rot = math.atan2(vy, vx)
            if rot == 0 then return end 
            if rot < math.pi/4 and rot > -math.pi/4 then
                self.anim = self.animations.right
            elseif rot <= 3*math.pi/2 and rot >= math.pi/4 then
                self.anim = self.animations.down
            elseif rot >= -3*math.pi/4 and rot <= -math.pi/4 then
                self.anim = self.animations.up
            else 
                self.anim = self.animations.left
            end

            self.anim:update(dt)
        end

    end

    function enemy:rangeAttack(dt)
        if self.attackDelay ~= 0 then return end
        self.attackDelay = 1.5
        local ex, ey = self:getPosition()
        local vx, vy = normalise(ex, ey, player:getX(), player:getY())

        --create projectile
        local projectile = world:newCircleCollider(ex, ey, 4) --bullet
        projectile:setCollisionClass("EnemyProj")
        table.insert(projectiles, projectile)
        projectile.damage = self.damage
        projectile.timeToLive = 1.2
        projectile.vx = vx
        projectile.vy = vy
        projectile:setLinearVelocity(vx * 200, vy * 200)
        effects:spawn(projectile:getX(), projectile:getY(), "fireball", 0, 0.6, nil, projectile)
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
        self:setLinearVelocity(vx * 30 * self.knockback, vy * 30 * self.knockback)
        
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

function enemies:draw()

    for _, enemy in ipairs(enemies) do
        local x, y = enemy:getPosition()

        enemy.anim:draw(sprites.skeleton, x, y - 2, nil, 1, nil, 8, 8)
    end
end



function projectiles:update(dt)
    local toDelete = {}
    for i, proj in ipairs(projectiles) do

        --reducing cooldowns
        proj.timeToLive = manageCd(dt, proj.timeToLive)
        if proj.timeToLive == 0 then
            table.insert(toDelete, proj)
        end

        --add to delete table when hitting
        if proj:enter("Player") or proj:enter("Wall") then 
            table.insert(toDelete, proj)
        end

        --deal damage
        if proj:enter("Player") then 
            player:hit(proj.damage, 0.1, proj.vx, proj.vy)
        end


    end

    --delete projectiles in delete table
    for i = #projectiles, 1, -1 do
        for i, projToDel in pairs(toDelete) do
            if projectiles[i] == projToDel then
                effects:removeProjectile(projectiles[i])
                projectiles[i]:destroy()
                table.remove(projectiles, i)
            end
        end
    end
end



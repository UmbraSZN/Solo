enemies = {}

function enemies:spawn(x, y, type) --spawn a new enemy

    local enemy
    if type == "test" then
        enemy = world:newCircleCollider(x, y, 20)
        enemy.speed = 50
        enemy.spawnX = x 
        enemy.spawnY = y 
        
    elseif type == "" then
        --code for different mob type

    end

    function enemy:move()
        local enemyX, enemyY = self:getPosition()
        local playerX, playerY = player:getPosition()

        local dx, dy = playerX - enemyX, playerY - enemyY
        local length = math.sqrt(dx^2 + dy^2)

        if length < 200 and length >= 50 then --within detection range
            --move to player
            --add code to consider colliders
            local vx, vy = dx/length, dy/length 
            self:setLinearVelocity(vx * self.speed, vy * self.speed)

        elseif length >= 200 then 
            --return to spawn
            local xToSpawn, yToSpawn = self.spawnX - enemyX, self.spawnY - enemyY
            local lengthToSpawn = math.sqrt(xToSpawn^2 + yToSpawn^2)
            local dx, dy = xToSpawn/lengthToSpawn, yToSpawn/lengthToSpawn
            self:setLinearVelocity(dx * self.speed, dy * self.speed)

        elseif length < 50 then
            --enter combat mode
            self:setLinearVelocity(0,0)
        end

    end

    enemy:setCollisionClass("Enemy")
    table.insert(enemies, enemy)
end


function enemies:update(dt)

    for _, e in ipairs(enemies) do
        
        e:move()

    end

end


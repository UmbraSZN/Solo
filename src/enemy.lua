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

        elseif length < 50 then --make value larger?
            --enter combat mode
            self:setLinearVelocity(0,0)
            self:combat(dx, dy, length)
        end

    end

    function enemy:combat(dx, dy, length)
        
        local vx, vy = dx/length, dy/length
        local query = world:queryCircleArea(self:getX() + vx * 40, self:getY() + vy * 40, 35, {"Player"})

        --add a delay/cooldown on attacking
        for _, plr in ipairs(query) do
            --check for block
            --check if player can be damaged
            plr.health = plr.health - 10 --change damage value based on a variable later
        end

    end

    enemy:setCollisionClass("Enemy")
    table.insert(enemies, enemy)
end


function enemies:update(dt)

    for _, e in ipairs(enemies) do
        if e.state == "default" then
            e:move()

        elseif e.state == "stunned" then

            e.stunTimer = e.stunTimer - dt
            if e.stunTimer < 0 then
                e.stunTimer = 0
                e.state = "default"
            end

        end

    end

end

--local query = world:queryRectangleArea(self:getX() + vx * 20, self:getY() + vy * 20, 40, 100, {"Player"}) 
--rectangles may be better to use when attacking as they give better htiboxes however there was an issue with them interacting with circles 
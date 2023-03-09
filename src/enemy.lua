enemies = {}

function enemies:spawn(x, y, type) --spawn a new enemy

    local enemy
    if type == "test" then
        enemy = world:newCircleCollider(x, y, 20)
        enemy.speed = 50
        
    elseif type == "" then
        --code for different mob type

    end

    function enemy:move()
        local enemyX, enemyY = self:getPosition()
        local playerX, playerY = player:getPosition()

        local dx, dy = playerX - enemyX, playerY - enemyY
        local length = math.sqrt(dx^2 + dy^2)
        local vx, vy = dx/length, dy/length

        if length < 200 then --within detection range
            --consider colliders
            self:setLinearVelocity(vx * self.speed, vy * self.speed)

        else
            --wander
            self:setLinearVelocity(0, 0)
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

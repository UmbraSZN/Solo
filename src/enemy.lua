enemies = {}

function enemies:spawn(x, y, type) --spawn a new enemy

    local enemy
    if type == "test" then
        enemy = world:newCircleCollider(x, y, 20)
        
    elseif type == "" then
        enemy = world:newCircleCollider(x, y, 20)

    end

    enemy:setCollisionClass("Enemy")
end




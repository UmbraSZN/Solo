enemies = {}

function enemies:spawn(x, y, type) --spawn a new enemy

    local enemy
    if type == "test" then
        enemy = world:newCircleCollider(x, y, 20)
        
    elseif type == "" then
        --code for different mob type

    end

    enemy:setCollisionClass("Enemy")
    table.insert(enemies, enemy)
end




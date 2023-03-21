effects = {}

function effects:spawn(x, y, type, rot, scale)
    
    local effect = {}
    effect.x = x 
    effect.y = y
    effect.rot = rot or 0
    effect.scale = scale or 1
    effect.dead = false
    effect.type = type

    if type == "swordSwipe" then
        effect.spriteSheet = love.graphics.newImage("assets/sprites/blueSlashSpriteSheet.png")
        effect.width = 124
        effect.height = 150
        local g = anim8.newGrid(124, 150, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(g("1-5", 1), 0.05, function() effect.dead = true end)

    elseif type == "" then

    end

    
    table.insert(effects, effect)
end


function effects:update(dt)

    for _, e in ipairs(effects) do
        if e.anim then
            e.anim:update(dt)
        end
    end

    for i, v in ipairs(effects) do
        if effects[i].dead then
            table.remove(effects, i)
        end
    end
end

function effects:draw()

    for _, e in ipairs(effects) do
        if e.anim then
            e.anim:draw(e.spriteSheet, e.x, e.y, e.rot, e.scale, e.scale, e.width/2, e.height/2)
        end
    end
end






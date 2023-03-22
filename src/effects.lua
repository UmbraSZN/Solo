effects = {}

function effects:spawn(x, y, type, rot, scale, lifetime)
    
    local effect = {}
    effect.x = x 
    effect.y = y
    effect.rot = rot or 0
    effect.scale = scale or 1
    effect.lifetime = lifetime or nil
    effect.dead = false
    effect.type = type

    if type == "swordSwipe" then
        effect.spriteSheet = love.graphics.newImage(sprites.swordSwipe)
        effect.width = 124
        effect.height = 150
        local g = anim8.newGrid(124, 150, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(g("1-5", 1), 0.04, function() effect.dead = true end)

    elseif type == "sword" then --maybe remove?
        effect.spriteSheet = love.graphics.newImage(sprites.sword)
        effect.width = effect.spriteSheet:getWidth()
        effect.height = effect.spriteSheet:getHeight()
        local g = anim8.newGrid(effect.width, effect.height, effect.width, effect.height)
        effect.anim = anim8.newAnimation(g("1-1", 1), 0.01, function() effect.dead = true end)

    elseif type == "gate" then
        effect.spriteSheet = love.graphics.newImage(sprites.gate)
        effect.width = 300
        effect.height = 300
        local g = anim8.newGrid(300, 300, effect.spriteSheet:getWidth(), effect.spriteSheet:getHeight())
        effect.anim = anim8.newAnimation(g("1-16", 1), 0.1)

        function effect:update(dt)
            if self.lifetime then
                self.lifetime = self.lifetime - dt
                if self.lifetime <= 0 then 
                    self.dead = true
                end
            end
        end

    end

    
    table.insert(effects, effect)
end


function effects:update(dt)

    for _, e in ipairs(effects) do
        if e.anim then
            e.anim:update(dt)
        end

        if e.update then
            e:update(dt)
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






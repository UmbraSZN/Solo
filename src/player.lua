player = world:newCircleCollider(200, 150, 8) --x, y, radius
player:setCollisionClass("Player")
player.state = "default"
player.iFrames = 0
player.animTimer = 0 
player.dashCdTimer = 0
player.stunTimer = 0
player.attackTimer = 0
player.dashDuration = 0.25
player.dashCd = 1
player.regenTimer = 0

local g = anim8.newGrid(32, 32, sprites.player:getWidth(), sprites.player:getHeight())
player.animations = {}
player.animations.down = anim8.newAnimation(g("1-4", 1), 0.15)
player.animations.left = anim8.newAnimation(g("1-4", 2), 0.15)
player.animations.up = anim8.newAnimation(g("1-4", 3), 0.15)
player.animations.right = anim8.newAnimation(g("1-4", 4), 0.15)

player.anim = player.animations.down

loadData() --sets playerstats
player.health = 100 + (player.playerstats.vitality * 5)


function player:update(dt)
    
    player.damage = 5 + (player.playerstats.strength * 2)
    player.speed = 70 + (player.playerstats.agility * 0.25)
    player.maxHealth = 100 + (player.playerstats.vitality * 5)

    if player.health <= 0 then
        player.health = player.maxHealth 
        player:setLinearVelocity(0, 0)
        gamestate.switch(dead)
        return 
    end

    if player.state ~= "stunned" and player.state ~= "dashing" then
        player:setLinearDamping(0)

        --moving player(w, a, s, d)
        local vx, vy = 0, 0 --vectors
        local isMoving = false
        if love.keyboard.isDown("a") then
            vx = player.speed * -1
            player.anim = player.animations.left
            isMoving = true
        end

        if love.keyboard.isDown("d") then
            vx = player.speed
            player.anim = player.animations.right
            isMoving = true
        end

        if love.keyboard.isDown("s") then
            vy = player.speed
            player.anim = player.animations.down
            isMoving = true
        end

        if love.keyboard.isDown("w") then
            vy = player.speed * -1
            player.anim = player.animations.up
            isMoving = true
        end

        if vx ~= 0 and vy ~= 0 then
            vx = vx/math.sqrt(2)
            vy = vy/math.sqrt(2)
        end

        if isMoving == false then
            player.anim:gotoFrame(4)
        end

        player:setLinearVelocity(vx, vy)
        player.anim:update(dt)


    elseif player.state == "stunned" then

        player.stunTimer = manageCd(dt, player.stunTimer)
        if player.stunTimer == 0 then
            player.state = "default"
        end

    elseif player.state == "dashing" then

        player.animTimer = manageCd(dt, player.animTimer)
        if player.animTimer == 0 then
            player.state = "default"
        end
    end

    if player.state ~= "dashing" then
        player.dashCdTimer = manageCd(dt, player.dashCdTimer)
    end

    if player.state == "attacking" then
        player.state = "default"
        local px, py = player:getPosition()
        local mx, my = cam:mousePosition()
        local vx, vy = normalise(px, py, mx, my)
        local rot = math.atan2(vy, vx)

        effects:spawn(px + vx * 20, py + vy * 20, "swordSwipe", rot - math.pi/4, 0.5)
        local query = world:queryCircleArea(self:getX() + vx * 20, self:getY() + vy * 20, 20, {"Enemy"})
        for _, e in ipairs(query) do
            e:hit(player.damage, 0.1, vx, vy)
        end

    else
        player.attackTimer = manageCd(dt, player.attackTimer)

    end

    player.iFrames = manageCd(dt, player.iFrames)
    
    player:updateLevel()
    player:regen(dt)
    player:checkDead()
end

function player:regen(dt)
    --regen 0.5% per second
    player.regenTimer = manageCd(dt, player.regenTimer)
    if player.regenTimer == 0 and player.health < player.maxHealth then
        player.regenTimer = 1
        player.health = player.health + player.maxHealth * 0.005
        if player.health > player.maxHealth then
            player.health = player.maxHealth
        end
    end
end

function player:dodge()
    player.state = "dashing"
    player.iFrames = player.dashDuration
    player.animTimer = player.dashDuration
    player.dashCdTimer = player.dashCd

    local vx, vy = 0, 0 --vectors 
    if love.keyboard.isDown("a") then
        vx = -1
    end

    if love.keyboard.isDown("d") then
        vx = 1
    end

    if love.keyboard.isDown("s") then
        vy = 1
    end

    if love.keyboard.isDown("w") then
        vy = -1
    end

    if vx ~= 0 and vy ~= 0 then
        vx = vx/math.sqrt(2)
        vy = vy/math.sqrt(2)
    end

    if vx == 0 and vy == 0 then
        player.iFrames = 0
        player.animTimer = 0
        player.dashCdTimer = 0
    end

    player:setLinearDamping(0.5)
    player:setLinearVelocity(vx * player.speed * 3, vy * player.speed * 3)
end


function player:attack(type)

    player.state = "attacking"

    if type == "light" then
        --set light values
        player.attackTimer = 0.2

    elseif type == "ability1" then
        --set ability values
        
    end

end


function player:hit(dmg, stun, vx, vy)

    if self.iFrames == 0 then  --can be hit        
        --deal damage
        self.stunTimer = stun
        self.state = "stunned"
        self.health = self.health - dmg
        self:setLinearVelocity(vx * 300, vy * 300)
    else
        --dodge (no damage)
        print("dodged")
    end

end

function player:checkDead() --update code
    if player.health <= 0 then
        --love.event.quit()
    end
end

function player:updateLevel()
    local expFormula = math.floor(4*(self.playerstats.lvl)^1.4)
    if self.playerstats.exp >= expFormula then
        self.playerstats.exp = self.playerstats.exp - expFormula
        self.playerstats.lvl = self.playerstats.lvl + 1
        print("Levelled up\nLevel: ", self.playerstats.lvl)
        self.playerstats.points = self.playerstats.points + 3
    end
end

function player:drawBars()
    love.graphics.push("all")
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    --health bar
    local bw = ww * 1/3
    local bh = 35
    local bx = ww * 1/3
    local by = wh - bh - 15
    love.graphics.setColor(0, 0, 0) --black
    love.graphics.rectangle("line", bx, by, bw, bh)
    local bw = player.health/player.maxHealth * bw
    love.graphics.setColor(1, 0, 0) --red
    love.graphics.rectangle("fill", bx, by, bw, bh)

    --exp bar
    local bw = ww * 1/2
    local bh = 10
    local bx = ww * 1/4
    local by = wh - bh
    love.graphics.setColor(0, 0, 0) --black
    love.graphics.rectangle("line", bx, by, bw, bh)
    local bw = (player.playerstats.exp)/math.floor(4*(self.playerstats.lvl)^1.4) * bw
    if bw > ww * 1/2 then bw = ww * 1/2 end
    love.graphics.setColor(1, 223/255, 0) --yellow 
    love.graphics.rectangle("fill", bx, by, bw, bh)
    love.graphics.pop()
end


function player:drawInvestmentScreen()

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    local font = love.graphics.getFont()
    local fw = 180
    local fh = font:getHeight() * 4 + 5

    love.graphics.push("all")
    --frame
    love.graphics.setColor(48/255, 128/255, 254/255, 0.5) --bright blue (transparent)
    love.graphics.rectangle("fill", ww - fw - 10, wh - fh - 10, fw, fh)
    love.graphics.setColor(48/255, 128/255, 254/255, 1) --bright blue
    love.graphics.rectangle("line", ww - fw - 10, wh - fh - 10, fw, fh)
    
    --text
    love.graphics.setColor(1, 1, 1) --white
    love.graphics.printf("Vitality: ".. player.playerstats.vitality, ww - fw - 5, wh - fh, fw)
    love.graphics.printf("Strength: ".. player.playerstats.strength, ww - fw - 5, wh - fh + font:getHeight() + 5, fw)
    love.graphics.printf("Agility: ".. player.playerstats.agility, ww - fw - 5, wh - fh + (font:getHeight() * 2) + 10, fw)
    love.graphics.pop()

    --buttons
    for i = #buttons, 1, -1 do
        if buttons[i].text == "+" then
            table.remove(buttons, i)
        end
    end
    buttons:new(
        "+", --text
        ww - 35, --x
        wh - fh, --y
        23, --w
        23, --h
        function()
            player.playerstats.points = player.playerstats.points - 1
            player.playerstats.vitality = player.playerstats.vitality + 1
        end
    )

    buttons:new(
        "+", --text
        ww - 35, --x
        wh - fh + font:getHeight() + 5, --y
        23, --w
        23, --h
        function()
            player.playerstats.points = player.playerstats.points - 1
            player.playerstats.strength = player.playerstats.strength + 1
        end
    )

    buttons:new(
        "+", --text
        ww - 35, --x
        wh - fh + (font:getHeight() * 2) + 10, --y
        23, --w
        23, --h
        function()
            player.playerstats.points = player.playerstats.points - 1
            player.playerstats.agility = player.playerstats.agility + 1
        end
    )

    buttons:update(dt)
    buttons:draw()
end

function player:draw()
    local x, y = self:getPosition()

    player.anim:draw(sprites.player, x, y-6, nil, 1, nil, 16, 16)

end



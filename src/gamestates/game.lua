local game = {}


function game:enter(from, mapToLoad)
    buttons:destroyAll()
    loadMap(mapToLoad)
end


function game:resize(w, h)
end

function game:update(dt)
    player:update(dt)
    enemies:update(dt)
    gates:update(dt)
    world:update(dt)
    effects:update(dt)
    cam:update(dt)
end

function game:draw()
    
        if map == "Dungeon" then
            local effect = moonshine(moonshine.effects.vignette)
            effect.vignette.opacity = 1
            effect.vignette.softness = 0.6
            effect.vignette.radius = 0.9
            effect(function()
                drawGame()
            end)
        else
            drawGame()
        end
    
    love.graphics.print("Health: ".. player.health, 10, 10)

end



function game:keypressed(key)

    if key == "o" then --debugging
        local testEnemy = enemies:spawn(120, 240, "testrange")

    elseif key == "l" then --debugging
        local testEnemy = enemies:spawn(200, 240, "testclose")

    elseif key == "space" and player.state == "default" and player.dashCdTimer == 0 then --dodge/dash
        player:dodge()

        
    elseif key == "p" then --debugging
        print("X: ", player:getX())
        print("Y: ", player:getY())

    elseif key == "i" then --debugging
        --spawn gate
        gates:spawn(200, 200, "E")

    elseif key == "escape" then
        gamestate.push(pause)

    end
end

function game:mousepressed(x, y, button)
    local cx, cy = cam:mousePosition() --position of mouse in relation to the world
    
    if button == 1 then --left click

        buttons:click(x, y)
        if player.state == "default" and player.attackTimer == 0 then --player is in normal gameplay
            player:attack("light")

        end

    end

end


return game


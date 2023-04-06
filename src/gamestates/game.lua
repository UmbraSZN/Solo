local game = {}


function game:enter(from, mapToLoad)
    buttons:destroyAll()
    loadMap(mapToLoad)
end


function game:resize(w, h)
end

function game:resume(from)
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
            shaders.darkness(function()
                drawGame()
            end)
        else
            drawGame()
        end
        player:drawBars()

        if player.playerstats.points > 0 then
            player:drawInvestmentScreen()
        end
    
    love.graphics.print("Level: ".. player.playerstats.lvl, 10, 10)

end



function game:keypressed(key)

    if key == "o" then --debugging
        local testEnemy = enemies:spawn(120, 240, "ranged")
        player.playerstats.agility = 500 --REMOVE

    elseif key == "l" then --debugging
        local testEnemy = enemies:spawn(200, 240, "melee")

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


function loadMap(mapName)
    destroyAll()
    print(mapName)
    gameMap = sti("assets/maps/" .. mapName .. ".lua")
    map = mapName
    --print(gameMap) --table
    addWalls()
    if mapName == "Dungeon" then
        player:setPosition(200, 300)
        effects:spawn(200, 250, "gate", 0, 0.1)
        gates:spawn(500, 5500)
        addEnemies()
    end
end

function drawMap()

    if gameMap.layers["Ground"] then
        gameMap:drawLayer(gameMap.layers["Ground"])
    end

    if gameMap.layers["More Ground"] then
        gameMap:drawLayer(gameMap.layers["More Ground"])
    end

    if gameMap.layers["Ground acc"] then
        gameMap:drawLayer(gameMap.layers["Ground acc"])
    end

    if gameMap.layers["Walls"] then
        gameMap:drawLayer(gameMap.layers["Walls"])
    end

    if gameMap.layers["Walls border"] then
        gameMap:drawLayer(gameMap.layers["Walls border"])
    end

    if gameMap.layers["Trees&more"] then
        gameMap:drawLayer(gameMap.layers["Trees&more"])
    end

    if gameMap.layers["Houses"] then
        gameMap:drawLayer(gameMap.layers["Houses"])
    end

    if gameMap.layers["Bridges"] then
        gameMap:drawLayer(gameMap.layers["Bridges"])
    end
    
end

walls = {}
function addWalls()

    if gameMap.layers["Collisions"] then
        for i, obj in ipairs(gameMap.layers["Collisions"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setCollisionClass("Wall")
            wall:setType("static")
            table.insert(walls, wall)
        end
    end

end
    
    
function addEnemies()

    if gameMap.layers["Enemies"] then
        local enemyTotal = 0 --make total enemies based on gate rank (more with higher gate rank)
        for i, obj in ipairs(gameMap.layers["Enemies"].objects) do
            --attempt enemy spawn
            local rng = love.math.random() --make rng weight based on gate rank (more with higher gate rank)
            if rng < 0.25 then
                enemies:spawn(obj.x, obj.y, "ranged")
                enemyTotal = enemyTotal + 1
            elseif rng > 0.75 then
                enemies:spawn(obj.x, obj.y, "melee")
                enemyTotal = enemyTotal + 1
            end

        end
        print(enemyTotal)
    end
end


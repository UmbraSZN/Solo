function loadMap(mapName)
    gameMap = sti("assets/maps/" .. mapName .. ".lua")
    addWalls()
end

function drawMap()

    if gameMap.layers["Ground"] then
        gameMap:drawLayer(gameMap.layers["Ground"])
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
        for i, obj in pairs(gameMap.layers["Collisions"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setCollisionClass("Wall")
            wall:setType("static")
            table.insert(walls, wall)
        end
    end

end
    
    

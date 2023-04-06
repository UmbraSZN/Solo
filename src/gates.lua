gates = {}
local timer = 5
function gates:spawn(x, y, level)

    local gate = world:newBSGRectangleCollider(x - 6, y - 10, 12, 20, 10) 
    gate:setCollisionClass("Gate")
    gate:setType("static")
    gate.timer = 10 --will increase later

    if level == "E" then
        gate.timer = 60

    --add more gate levels
    
    elseif level == nil then
        gate.timer = math.huge
    
    end


    function gate:update(dt)

        gate.timer = gate.timer - dt 

        if gate.timer <= 0 then
            --remove gate
            for i = #gates, 1, -1 do
                if self == gates[i] then
                    table.remove(gates, i)
                end
            end
            self:destroy()
            print("gate expired")
        end

        if self:enter("Player") then
            --teleport player
            if map == "Dungeon" then
                gamestate.switch(game, "Overworld Map")
            else
                gamestate.switch(game, "Dungeon")
            end
        end
    end

    effects:spawn(x, y, "gate", 0, 0.1, gate.timer)
    table.insert(gates, gate)
end


function gates:update(dt)
    if map == "Overworld Map" then
        gates:attemptSpawn(dt)
    end

    for _, g in ipairs(gates) do
        g:update(dt)

    end

end

function gates:attemptSpawn(dt)
    timer = manageCd(dt, timer)
    if timer == 0 then
        timer = 5

        local rng = love.math.random(1, 5)
        if rng == 5 then
            --spawn a gate
            for i, obj in ipairs(gameMap.layers["Gates"].objects) do
                gates:spawn(obj.x, obj.y, "E")
                break
            end
        end
    end

end


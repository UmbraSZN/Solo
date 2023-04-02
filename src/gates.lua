gates = {}

function gates:spawn(x, y, level)

    local gate = world:newBSGRectangleCollider(x - 6, y - 10, 12, 20, 10) 
    gate:setCollisionClass("Gate")
    gate:setType("static")
    gate.timer = 10 --will increase later

    if level == "E" then
        

    elseif level == "D" then


    elseif level == "C" then


    elseif level == "B" then


    elseif level == "A" then

    
    elseif level == "S" then

    
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
            --teleport player to dungeon
            if map == "Dungeon" then
                gamestate.pop()
            else
                gamestate.push(game, "Dungeon")
            end
        end
    end

    effects:spawn(x, y, "gate", 0, 0.1, gate.timer)
    table.insert(gates, gate)
end


function gates:update(dt)

    for _, g in ipairs(gates) do
        g:update(dt)

    end

end








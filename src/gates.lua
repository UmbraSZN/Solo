gates = {}

function gates:spawn(x, y, level)

    local gate = world:newBSGRectangleCollider(x - 15, y - 25, 30, 50, 10) 
    gate:setCollisionClass("Gate")
    gate:setType("static")
    gate.timer = 10 --will increase later
    effects:spawn(x, y, "gate", 0, 0.25, gate.timer)

    if level == "E" then
        

    elseif level == "D" then


    elseif level == "C" then


    elseif level == "B" then


    elseif level == "A" then

    
    elseif level == "S" then

    
    end

    --add more specific gate functions

    function gate:update(dt)

        gate.timer = gate.timer - dt 
        --print(gate.timer)

        if gate.timer <= 0 then
            --remove gate
            for i, v in ipairs(gates) do
                if self == v then
                    table.remove(gates, i)
                end
            end
            self:destroy()
            print("gate expired")
        end

        if self:enter("Player") then
            print("tp")
            --teleport player to dungeon
        end
    end


    table.insert(gates, gate)
end


function gates:update(dt)

    for _, g in ipairs(gates) do
        g:update(dt)

    end

end








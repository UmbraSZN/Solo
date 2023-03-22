gates = {}

function gates:spawn(x, y, level)

    local r = love.math.random(10, 40) --randomised size
    local gate = world:newCircleCollider(x, y, r) 
    if level == "E" then
        

    elseif level == "D" then


    elseif level == "C" then


    elseif level == "B" then


    elseif level == "A" then

    
    elseif level == "S" then

    
    end

    --add more specific gate functions

    function gate:update(dt)
    end


    table.insert(gates, gate)
end


function gates:update(dt)

    for _, g in ipairs(gates) do
        

    end

end








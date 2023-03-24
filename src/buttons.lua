buttons = {}

function buttons:new(text, x, y, w, h, func)
    table.insert(buttons, {text = text, x = x, y = y, w = w, h = h, func = func})
end

function buttons:update(dt)
    local cx, cy = love.mouse.getPosition()
    for i, b in ipairs(buttons) do
        if cx > b.x and cx < b.x + b.w and cy > b.y and cy < b.y + b.h then --within the button area
            print("in area")
        else
            print("not in area")
        end 
    end
end

function buttons:draw()

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    for i, b in ipairs(buttons) do 
        --add set colour and font and size
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
    end
end


function buttons:click(x, y)
    for i, b in ipairs(buttons) do

        if x > b.x and x < b.x + b.w and y > b.y and y < b.y + b.h then --within the button area
            print("clicked")
            b.func()
        end 
    
    end
end



function buttons:destroy(buttonsToDestroy) --may not need? not tested

    local destroy = buttonsToDestroy or {}
    for i, b in ipairs(buttons) do
        for _, d in ipairs(destroy) do
            if d == b then
                table.remove(buttons, i)
            end
        end
    end

end
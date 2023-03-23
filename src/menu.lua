buttons = {}

function buttons:new(text, x, y, w, h, func)
    table.insert(buttons, {text = text, x = x, y = y, w = w, h = h, func = func})
end

function buttons:draw()

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    for i, b in ipairs(buttons) do 
        --set colour and font and size
        --love.graphics.print(b.text, b.x, b.y)

        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
    end
end


function buttons:click(x, y)
    for i, b in ipairs(buttons) do
        -- if x > b.x and x < b.x + b.text:getWidth() and y > b.y and y < b.y + b.text:getHeight() then
        --     print("x")
        -- end
    
    end
end


buttons = {}

function buttons:new(text, x, y)
    table.insert(buttons, {text = text, x = x, y = y})
end

function buttons:draw()
    for i, b in ipairs(buttons) do 
        love.graphics.print(b.text, b.x, b.y)
    end
end












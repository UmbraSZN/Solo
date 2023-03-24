buttons = {}

function buttons:new(text, x, y, w, h, func)
    table.insert(buttons, {text = text, x = x, y = y, w = w, h = h, func = func, mouseOn = false})
end
--normal button on 1080p = 480x135 (1/4 x 1/8)
--all buttons take up around half the height of the screen

function buttons:menu(menuType)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonGapY = wh * 70/1080
    local text
    local func
    local bw = ww * 1/4
    local bh = wh * 1/8
    local bx = ww * 3/8
    local by = wh * 330/1080

    if menuType == "main" then
        --3 buttons
        --3 rows 1 column
        text = "Play"
        func = function()
            gamestate.switch(game)
        end
        buttons:new(text, bx, by, bw, bh, func)

        text = "Settings"
        func = function()
            print("Settings")
        end
        buttons:new(text, bx, by + bh + buttonGapY, bw, bh, func)

        text = "Quit"
        func = function()
            love.event.quit()
        end
        buttons:new(text, bx, by + bh * 2 + buttonGapY * 2, bw, bh, func)

    elseif menuType == "settings" then

    elseif menuType == "paused" then

    elseif menuType == "slots" then

    end

    
end

function buttons:update(dt)
    local cx, cy = love.mouse.getPosition()
    for i, b in ipairs(buttons) do
        if cx > b.x and cx < b.x + b.w and cy > b.y and cy < b.y + b.h then --within the button area
            b.mouseOn = true
        else
            b.mouseOn = false
        end 
    end
end

function buttons:draw()

    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    for i, b in ipairs(buttons) do 
        --add set colour and font and size
        love.graphics.push("all") 
        
        love.graphics.setColor(217/255, 217/255, 217/255) --light grey (#D9D9D9)
        if b.mouseOn then love.graphics.setColor(1, 1, 1) end --white when hovering
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
  
        love.graphics.setColor(0, 0, 0) --black
        local font = love.graphics.getFont()
        love.graphics.printf(b.text, b.x, b.y, b.w, "justify", 0, 1, 1, -b.w/2 + font:getWidth(b.text)/2, -b.h/2 + font:getHeight(b.text)/2)

        love.graphics.pop() 
        
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

function buttons:destroyAll()
    for i = #buttons, 1, -1 do
        table.remove(buttons, i)
    end
end



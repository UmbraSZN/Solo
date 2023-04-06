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
        --3 rows, 1 column
        text = "Play"
        func = function()
            --print(loadData(player.playerstats)) -----------------
            gamestate.push(game, "Overworld Map")
        end
        buttons:new(text, bx, by, bw, bh, func)

        text = "Settings"
        func = function()
            print("Settings")
            gamestate.push(settings)
        end
        buttons:new(text, bx, by + bh + buttonGapY, bw, bh, func)

        text = "Quit"
        func = function()
            love.event.quit()
        end
        buttons:new(text, bx, by + bh * 2 + buttonGapY * 2, bw, bh, func)

    elseif menuType == "settings" then
        --6 buttons
        --3 rows, 2 columns
        buttons:destroyAll() --gets rid of old buttons
        bx = ww * 380/1920

        --fullscreen (toggle - true/false) [left1]
        text = "Fullscreen"
        func = function()
            print("Fullscreen")
            local fs = love.window.getFullscreen()
            love.window.setFullscreen(not fs)
            
            buttons:destroyAll()
            local state = gamestate.current()
            if state == menu then
                buttons:menu("main")
            elseif state == game then
                buttons:menu("game")
            elseif state == pause then
                buttons:menu("paused")
            elseif state == slots then
                buttons:menu("slots")
            elseif state == keybinds then
                buttons:menu("keybinds")
            elseif state == settings then
                buttons:menu("settings")
            end
        end
        buttons:new(text, bx, by, bw, bh, func)

        --difficulty (toggle - easy/medium/hard) [left2]
        text = "Difficulty"
        func = function()
            print("Difficulty")
            --difficulty selector
        end
        buttons:new(text, bx, by + bh + buttonGapY, bw, bh, func)

        --keybinds [left3]
        text = "Keybinds"
        func = function()
            print("Keybinds")
            --open keybinds menu
            --buttons:destroyAll()
            --buttons:menu("keybinds")
            gamestate.push(keybinds)
        end
        buttons:new(text, bx, by + 2 * bh + 2 * buttonGapY, bw, bh, func)

        bx = ww * 1060/1920
        --resolution (toggle - 480p/720p/1080p) [right1]
        text = "Resolution"
        func = function()
            print("Resolution")
            --set resolution
        end
        buttons:new(text, bx, by, bw, bh, func)

        --volume (slider - %) [right2]
        text = "Volume"
        func = function()
            print("Volume")
            --add slider
        end
        buttons:new(text, bx, by + bh + buttonGapY, bw, bh, func)

        --back (to previous menu) [right3]
        text = "Back"
        func = function()
            print("Back")
            gamestate.pop()
        end
        buttons:new(text, bx, by + 2 * bh + 2 * buttonGapY, bw, bh, func)

    elseif menuType == "paused" then
        --3 buttons
        --3 row, 1 column
        text = "Resume"
        func = function()
            --gamepaused = false
            gamestate.pop()
        end
        buttons:new(text, bx, by, bw, bh, func)

        text = "Settings"
        func = function()
            print("Settings")
            --gamestate.switch(settings)
            gamestate.push(settings)
        end
        buttons:new(text, bx, by + bh + buttonGapY, bw, bh, func)

        text = "Exit to main menu"
        func = function()
            gamestate.switch(menu)
        end
        buttons:new(text, bx, by + bh * 2 + buttonGapY * 2, bw, bh, func)

    elseif menuType == "slots" then


    elseif menuType == "keybinds" then
        --keybinds
        
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
        love.graphics.printf(b.text, b.x, b.y, b.w, "left", 0, 1, 1, -b.w/2 + font:getWidth(b.text)/2, -b.h/2 + font:getHeight(b.text)/2)

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

function buttons:reDraw()
    local temp = buttons
    buttons:destroyAll()
end


--add a how to play button in the rop right (little question mark)



--[[
gamestates:
main menu
settings
keybinds
game
paused
slots
loading (may not need)

main menu:
3 buttons
play
settings
quit

settings:
6 buttons
fullscreen
resolution
difficulty
volume
keybinds
back

game:
0 buttons

paused:
3 buttons
resume
settings
exit to main menu

loading: (may not need)
0 buttons

slots:
3 buttons
slot 1
slot 2
slot 3

keybinds:
x buttons
Up [W]
Left [A]
Down [S]
Right[D]
Dash [Space] 
Heavy [R]
Block [F]
Interact [ ] (may not need)
Ability 1 [LeftShift] ?
Ability 2 [E] 
Ability 3/Ultimate [Q] ?
]]
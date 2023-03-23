local menu = {}

function menu:update(dt)

end

function menu:draw()

end

function menu:mousepressed(x, y, button)

end

function menu:keypressed(key)               --replace with buttons
    if key == "return" then
        gamestate.switch(game)
        print("Entering game")
    end
end



return menu


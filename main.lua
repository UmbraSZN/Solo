function love.load()
    require("src/startup/gameStart")
    startGame()
    
    world:setQueryDebugDrawing(true)
    -- local testCollider = world:newRectangleCollider(100, 150, 80, 200)
    -- testCollider:setType("static")
    -- testCollider:setCollisionClass("Wall")

    loadMap("Overworld Map")
end


function love.keypressed(key)
    if key == "f11" then
        --fullscreen
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
end


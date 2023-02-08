function startGame()
    love.graphics.setBackgroundColor(22/255, 22/255, 22/255)

    local wf = require("libraries/windfield")
    world = wf.newWorld(0, 0, false) --create world


    require("src/startup/require")
    requireAll()
end



function startGame()
    wf = require("libraries/windfield")
    world = wf.newWorld(0, 0, false) --create world
    
    require("src/startup/colliders")
    createCollisionClasses()

    require("src/startup/require")
    requireAll()
end



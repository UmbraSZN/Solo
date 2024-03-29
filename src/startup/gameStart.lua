function startGame()
    love.graphics.setBackgroundColor(28/255, 28/255, 28/255) --dark grey (#1C1C1C)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(love.graphics.newFont(20))

    local wf = require("libraries/windfield")
    world = wf.newWorld(0, 0, false) --create world
    anim8 = require("libraries/anim8")
    moonshine = require("libraries/moonshine")
    sti = require("libraries/sti")

    require("src/startup/require")
    requireAll()
    gamestates()
end

function gamestates()
    gamestate = require("libraries/hump/gamestate")
    menu = require("src/gamestates/menu")
    game = require("src/gamestates/game")
    settings = require("src/gamestates/settings")
    keybinds = require("src/gamestates/keybinds")
    pause = require("src/gamestates/pause")
    dead = require("src/gamestates/dead")

    gamestate.registerEvents()
    gamestate.switch(menu)
end



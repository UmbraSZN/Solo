function startGame()
  love.math.setRandomSeed(os.time()) --unique random number generation
  
  love.graphics.setBackgroundColor(22,22,22) --grey
  wf = require("libraries/windfield")
  world = wf.newWorld(0, 0, false) --create world
  local border = world:newLineCollider(0, 2, 1000, 0)
  border:setType("static")

  require("src/startup/colliders")
  createCollisionClasses()
  
  require("src/startup/resources")
  require("src/startup/require")
  requireAll()

  --start game in menu
end
function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest") --pixel scaling

  require("src/startup/gameStart")
  startGame()
  
end


function love.update(dt)
  player:update(dt)
  world:update(dt)
end

function love.draw()
  --player:draw()  --player is currently only a collider so its drawn by the world
  world:draw() 
end
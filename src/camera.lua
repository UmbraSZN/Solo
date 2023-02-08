camera = require("libraries/hump/camera")
cam = camera(0, 0)

function cam:update(dt)
    local camX, camY = player:getPosition()
    cam:lookAt(camX, camY)
end



camera = require("libraries/hump/camera")
cam = camera(0, 0, 3)
--cam.smoother = camera.smooth.damped(15) --better camera movement (won't work with new cam fix)
--cam:lockPosition(correctedX, correctedY) --better camera movement

function cam:update(dt)
    local camX, camY = player:getPosition()
    --fix vertical lines
    local floorX = math.floor(camX)
    local floorY = math.floor(camY)
    local floorDecimalX = math.floor((camX - floorX)*25)/25
    local floorDecimalY = math.floor((camY - floorY)*25)/25
    local correctedX = floorX + floorDecimalX
    local correctedY = floorY + floorDecimalY
    
    cam:lookAt(correctedX, correctedY)
    
end



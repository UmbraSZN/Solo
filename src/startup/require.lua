function requireAll()
    require("src/startup/resources")
    require("src/startup/colliders")
    createCollisionClasses()

    require("src/player")
    require("src/camera")
    require("src/enemy")
    require("src/effects")
    require("src/effects")
    require("src/startup/resources")
end


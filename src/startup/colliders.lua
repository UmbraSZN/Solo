function createCollisionClasses()
    world:addCollisionClass("Player")
    world:addCollisionClass("Enemy", {ignores = {"Enemy"}})
    world:addCollisionClass("Wall")
end


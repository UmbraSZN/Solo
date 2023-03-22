function createCollisionClasses()
    world:addCollisionClass("Player")
    world:addCollisionClass("Enemy", {ignores = {"Enemy"}})
    world:addCollisionClass("Wall")
    world:addCollisionClass("Gate", {ignores = {"Enemy"}, enter = {"Player"}})
end


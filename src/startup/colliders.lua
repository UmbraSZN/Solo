function createCollisionClasses()
    world:addCollisionClass("Player")
    world:addCollisionClass("Enemy", {ignores = {"Enemy"}})
    world:addCollisionClass("EnemyProj", {ignores = {"Enemy", "EnemyProj"}, enter = {"Player", "Walls"}})
    world:addCollisionClass("Wall")
    world:addCollisionClass("Gate", {ignores = {"Enemy"}, enter = {"Player"}})
end


enemies = {}

function enemies:spawn(x, y, type) --spawning new enemies

  local enemy
  if type == "" then
    enemy = {} --collider
    --set other attributes

  elseif type == "" then
    enemy = {} --collider
    --set other attributes

    --add more enemy types
  end

  table.insert(enemies, enemy)
end

function enemies:wander() --random movement when out of combat

end

function enemies:search() --searching for player

end

function enemies:pathfinding() --following player

end

function enemies:combat() --combat ai

end
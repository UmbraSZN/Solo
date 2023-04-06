function saveData(data)
    love.filesystem.write("data.lua", table.show(data, "player.playerstats"))
end

function loadData()
    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    else
        newData()
        return nil
    end
    
end

function newData()
    player.playerstats = {
        points = 0, --invest into a stat
        exp = 0, --current experience
        lvl = 1, --current level
        strength = 0, --scales damage
        vitality = 0, --scales max health
        agility = 0, --scales speed
    }
end


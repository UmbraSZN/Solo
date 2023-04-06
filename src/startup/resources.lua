sprites = {}
sprites.sword = love.graphics.newImage("assets/sprites/sword.png")
sprites.swordSwipe = love.graphics.newImage("assets/sprites/blueSlashSpriteSheet.png")
sprites.gate = love.graphics.newImage("assets/sprites/gateSpriteSheet.png")
sprites.fireball = love.graphics.newImage("assets/sprites/fireballSpriteSheet.png")
sprites.skeleton = love.graphics.newImage("assets/sprites/skeletonSpriteSheet.png")
sprites.player = love.graphics.newImage("assets/sprites/playerSpriteSheet.png")

shaders = {}
shaders.blur = moonshine(moonshine.effects.gaussianblur)
shaders.darkness = moonshine(moonshine.effects.vignette)
shaders.darkness.vignette.opacity = 1
shaders.darkness.vignette.softness = 0.6
shaders.darkness.vignette.radius = 0.9
















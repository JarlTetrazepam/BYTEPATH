Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()

    generateRecs(self)
end

function Stage:update(dt)
    self.timer:update(dt)
    self.area:update(dt)

    if #self.area.gameObjects == 0 then
        generateRecs(self)
    end
end

function Stage:draw()
self.area:draw()
end

function generateRecs(self)
    for i = 1, 10 do
        self.area:addGameObject("Rectangle", love.math.random(800), love.math.random(600), {w = love.math.random(200), h = love.math.random(299)})
    end
end
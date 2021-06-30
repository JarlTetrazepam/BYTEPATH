Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()
    self.mainCanvas = love.graphics.newCanvas(gw*2, gw*2)
end

function Stage:update(dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()

    love.graphics.circle("line", gw/2, gh/2, 50)
    self.area:draw()

    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode("alpha")
end
Circle = GameObject:extend()

function Circle:new(area, x, y, options)
    Circle.super.new(self, area, x, y, options)
end

function Circle:update(dt)
    Circle.super.update(self, dt)
end

function Circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.r)
end
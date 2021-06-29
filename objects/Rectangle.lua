Rectangle = GameObject:extend()

function Rectangle:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
end

function Rectangle:update(dt)
    self.timer:update(dt)
end

function Rectangle:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end
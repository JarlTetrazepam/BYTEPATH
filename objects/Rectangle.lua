Rectangle = GameObject:extend()

function Rectangle:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.rectanglePhysics = hc.rectangle(self.x, self.y, self.w or 0, self.h or 0)
end

function Rectangle:update(dt)
    self.timer:update(dt)
end

function Rectangle:draw()
    self.rectanglePhysics:draw("fill")
end
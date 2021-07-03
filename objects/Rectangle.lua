Rectangle = GameObject:extend()

function Rectangle:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.physicObj = hc.rectangle(self.x, self.y, self.w or 0, self.h or 0)
    self.physicObj.object = self
end

function Rectangle:update(dt)
    self.timer:update(dt)
end

function Rectangle:draw()
    self.physicObj:draw("fill")
end

function Rectangle:destroy()
    Rectangle.super.destroy(self)
end

function Rectangle:die()
    self.dead = true
end
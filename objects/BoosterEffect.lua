BoosterEffect = GameObject:extend()

function BoosterEffect:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.color = defaultColor
    self.visible = true
    self.w = options.w or 11
    self.expandValue = 1
    self.widthOffset = 0
    self.depth = 80
    self.timer:after(0.2, function ()
        self.color = boostColor
        self.timer:after(0.35, function ()
            self:die()
        end)
        self.timer:every(0.05, function ()
            self.visible = not self.visible
        end, 6)
    end)
    self.timer:tween(0.35, self, {expandValue = 1.5, widthOffset = self.w/4}, "in-out-cubic")
end

function BoosterEffect:update(dt)
    self.timer:update(dt)
end

function BoosterEffect:draw()
    if self.visible then
        love.graphics.setColor(self.color)
        pushRotate(self.x, self.y, math.pi/3.5)
        love.graphics.rectangle("fill", self.x + 0.5*self.w/2, self.y + 0.5*self.w/2, self.w / 2, self.h or self.w / 2)
        love.graphics.rectangle("line", self.x - self.widthOffset, self.y - self.widthOffset, self.w * self.expandValue, self.w * self.expandValue)
        love.graphics.pop()
        love.graphics.setColor(defaultColor)
    end
end

function BoosterEffect:destroy()
    BoosterEffect.super.destroy(self)
end

function BoosterEffect:die()
    self.dead = true
end
AttackObjectEffect = GameObject:extend()

function AttackObjectEffect:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.color = options.color or defaultColor
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

function AttackObjectEffect:update(dt)
    self.timer:update(dt)
end

function AttackObjectEffect:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x, self.y, math.pi/3.5)
    love.graphics.rectangle("fill", self.x + self.w/3, self.y + self.w/3, self.w/3, self.h or self.w/3)
    love.graphics.rectangle("line", self.x - self.widthOffset - 2, self.y - self.widthOffset - 2, self.w * self.expandValue + 4, self.w * self.expandValue + 4)
    love.graphics.setColor(defaultColor)
    if self.visible then
        love.graphics.rectangle("line", self.x - self.widthOffset, self.y - self.widthOffset, self.w * self.expandValue, self.w * self.expandValue)
    end
    love.graphics.pop()
end

function AttackObjectEffect:destroy()
    AttackObjectEffect.super.destroy(self)
end

function AttackObjectEffect:die()
    self.dead = true
end
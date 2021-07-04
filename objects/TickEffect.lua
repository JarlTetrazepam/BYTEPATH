TickEffect = GameObject:extend()

function TickEffect:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.w = 10
    self.h = 15
    self.yOffset = 0
    self.parent = options.parent or nil
    self.color = defaultColor
    self.barColor = {0,1,0}

    self.timer:tween(0.3, self, {h = 0, yOffset = self.h}, "in-out-cubic", function ()
        self:die()
    end)
    self.timer:after(0.15, function ()
        self.color = self.barColor
    end)
end

function TickEffect:update(dt)
    self.timer:update(dt)

    -- Move effect together with parent
    if self.parent then
        self.x, self.y = self.parent.x, self.parent.y
    end
end

function TickEffect:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x + self.w / 1.5, self.y - self.w * 2 - self.yOffset, self.w, self.h)
    love.graphics.setColor(defaultColor)
end

function TickEffect:destroy()
    TickEffect.super.destroy(self)
end

function TickEffect:die()
    self.dead = true
end
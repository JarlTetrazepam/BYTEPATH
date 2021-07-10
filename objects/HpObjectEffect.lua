HpObjectEffect = GameObject:extend()

function HpObjectEffect:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.color = defaultColor
    self.visible = true
    self.w = options.w or 5

    self.vertices = options.vertices or {}

    self.expandValue = 1
    self.depth = 80
    self.timer:after(0.4, function ()
        self.color = hpColor
        self.timer:after(0.35, function ()
            self:die()
        end)
        self.timer:every(0.05, function ()
            self.visible = not self.visible
        end, 6)
    end)
    self.timer:tween(0.35, self, {expandValue = 2}, "in-out-cubic")
end

function HpObjectEffect:update(dt)
    self.timer:update(dt)
end

function HpObjectEffect:draw()
    if self.visible then
        love.graphics.circle("line", self.x, self.y, self.w * self.expandValue)
        love.graphics.setColor(self.color)

        local points = M.map(self.vertices, function (point, key)
            if key % 2 == 1 then
                return self.x + point
            else
                return self.y + point
            end
        end)
        love.graphics.polygon("line", points)
        love.graphics.setColor(defaultColor)
    end
end

function HpObjectEffect:destroy()
    HpObjectEffect.super.destroy(self)
end

function HpObjectEffect:die()
    self.dead = true
end
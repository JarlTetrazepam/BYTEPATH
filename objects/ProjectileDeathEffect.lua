ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.w = options.w or 5

    self.firstStage = true
    self.color = options.color or {1,1,1}
    self.currentColor = defaultColor

    -- Color change
    self.timer:after(0.1, function ()
        self.currentColor = self.color
        self.timer:after(0.15, function ()
            self.dead = true
        end)
    end)
end

function ProjectileDeathEffect:update(dt)
    self.timer:update(dt)
end

function ProjectileDeathEffect:draw()
    pushRotate(self.x, self.y, math.pi/6)

    love.graphics.setColor(self.currentColor)
    love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.w / 2, self.w, self.w)
    love.graphics.pop()
end

function ProjectileDeathEffect:destroy()
    ProjectileDeathEffect.super.destroy(self)
end
TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.r = options.r or random(3, 5)
    self.colon = options.color or ammoColor

    self.timer:tween(options.duration or random(0.5, 0.8), self, {r = 0}, "linear", function ()
        self:die()
    end)
end

function TrailParticle:update(dt)
    self.timer:update(dt)
end

function TrailParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.r)
    love.graphics.setColor(defaultColor)
end

function TrailParticle:destroy()
    TrailParticle.super.destroy(self)
end

function TrailParticle:die()
    self.dead = true
end
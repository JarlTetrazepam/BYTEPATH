ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y, options)
    ShootEffect.super.new(self, area, x, y, options)

    self.w = 6
    self.timer:tween(0.1, self, {w = 0}, "in-out-cubic", function ()
        self.dead = true
    end)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)

    if self.player then
        self.x = self.player.x + self.distanceFromShooter * math.cos(self.player.radian)
        self.y = self.player.y + self.distanceFromShooter * math.sin(self.player.radian)
    end
end

function ShootEffect:draw()
    love.graphics.setColor(defaultColor)
    pushRotate(self.x, self.y, self.player.radian + math.pi / 4)
    love.graphics.rectangle("fill", self.x - self.w / 2, self.y - self.w / 2, self.w, self.w)
    love.graphics.pop()
end

function ShootEffect:destroy()
    ShootEffect.super.destroy(self)
end
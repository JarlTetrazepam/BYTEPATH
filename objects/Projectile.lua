Projectile = GameObject:extend()

function Projectile:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.r = options.r or 2
    self.velocity = options.velocity or 2

    self.color = hpColor

    self.physicObj = hc.circle(self.x, self.y, self.r)
    self.physicObj.object = self

    if not self.dead then
        self.timer:after(2, function ()
            self:die()
        end)
    end
end

function Projectile:update(dt)
    self.timer:update(dt)

    self.physicObj:move(self.velocity * math.cos(self.radian),
        self.velocity * math.sin(self.radian))

    self.physicObj.x, self.physicObj.y = self.physicObj:center()
    -- Die when out of bounds
    if self.physicObj.x < 0 or self.physicObj.x > gw or self.physicObj.y < 0 or self.physicObj.y > gh then
        self:die()
    end
end

function Projectile:draw()
    love.graphics.setColor(defaultColor)
    self.physicObj:draw("line")
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end

function Projectile:die()
    self.area:addGameObject("ProjectileDeathEffect",
        self.physicObj.x,
        self.physicObj.y,
        {color = hpColor, w = self.r * 3})
    self.dead = true
end
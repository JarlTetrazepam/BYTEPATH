Projectile = GameObject:extend()

function Projectile:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.w = options.w or 3

    if options.velocity then self.velocity = options.velocity + 1.5 else self.velocity = 1.5 end

    self.color = options.color or defaultColor

    self.physicObj = hc.rectangle(self.x - self.w/2, self.y - self.w, self.w, self.w * 2)
    self.physicObj.object = self
    
    self.physicObj:setRotation(self.radian + math.rad(90))
end

function Projectile:update(dt)
    self.timer:update(dt)

    self.physicObj:move(self.velocity * math.cos(self.radian),
        self.velocity * math.sin(self.radian))

    self.physicObj.x, self.physicObj.y = self.physicObj:center()
    self.x, self.y = self.physicObj:center()
    -- Die when out of bounds
    if self.physicObj.x < 0 or self.physicObj.x > gw or self.physicObj.y < 0 or self.physicObj.y > gh then
        self:die()
    end
end

function Projectile:draw()
    pushRotate(self.x, self.y, self.radian + math.rad(90))
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x - self.w/2, self.y - self.w, self.w, self.w)
    love.graphics.setColor(defaultColor)
    love.graphics.rectangle("fill", self.x - self.w/2, self.y, self.w, self.w)
    love.graphics.pop()
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end

function Projectile:die()
    self.area:addGameObject("ProjectileDeathEffect",
        self.physicObj.x,
        self.physicObj.y,
        {color = self.color, w = self.w * 2})
    self.dead = true
end
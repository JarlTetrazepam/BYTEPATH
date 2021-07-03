Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.w, self.h = 8, 8
    self.physicObj = hc.circle(self.x, self.y, self.w)
    self.physicObj.object = self

    self.radian = -math.pi/2
    self.radianVelocity = 1.66*math.pi
    self.velocity = 0
    self.maxVelocity = 1
    self.acceleration = 1

    self.timer:every(0.24, function ()
        self:shoot()
    end)
    self.timer:every(5, function ()
        self:tick()
    end)

    input:bind("k", function ()
        self:die()
    end)
end

function Player:update(dt)
    Player.super.update(self, dt)

    -- Basic movement
    if input:down("left") then
        self.radian = self.radian - self.radianVelocity * dt
    end
    if input:down("right") then
        self.radian = self.radian + self.radianVelocity * dt
    end
    self.velocity = math.min(self.velocity + self.acceleration * dt, self.maxVelocity)
    self.physicObj:move(self.velocity * math.cos(self.radian),
        self.velocity * math.sin(self.radian))

    -- Die when out of bounds
    if self.x < 0 or self.x > gw or self.y < 0 or self.y > gh then
        self:die()
    end
end

function Player:draw()
    love.graphics.setColor(defaultColor)
    self.physicObj:draw("line")
    love.graphics.line(self.x, self.y, self.x + 2 * -self.w * math.cos(self.radian), self.y + 2 * -self.w * math.sin(self.radian))
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:shoot()
    local distanceFromShooter = 1.2 * self.w
    self.area:addGameObject("ShootEffect",
        (self.x + distanceFromShooter * math.cos(self.radian)), 
        (self.y + distanceFromShooter * math.sin(self.radian)), 
        {player = self, distanceFromShooter = distanceFromShooter})
    self.area:addGameObject("Projectile",
        self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
        self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
        {radian = self.radian})
end

function Player:die()
    self.dead = true
    flash(4)
    camera:shake(6, 60, 0.4)
    slowTime(0.4, 1)
    for i = 1, random(10, 30), 1 do
        self.area:addGameObject("ExplodeParticle", self.x, self.y)
    end
end

function Player:tick()
    self.area:addGameObject("TickEffect", self.x, self.y, {parent = self})
end
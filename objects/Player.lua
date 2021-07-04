Player = GameObject:extend()

function Player:new(area, x, y, options)
    Player.super.new(self, area, x, y, options)
    self.w, self.h = 8, 8
    self.physicObj = hc.circle(self.x, self.y, self.w)
    self.physicObj.object = self

    self.radian = -math.pi/2
    self.radianVelocity = 1.66*math.pi
    self.velocity = 0
    self.maxVelocity = 1
    self.baseMaxVelocity = 1
    self.acceleration = 1

    self.trailColor = skillPointColor

    self.timer:every(0.24, function ()
        self:shoot()
    end)
    self.timer:every(5, function ()
        self:tick()
    end)

    input:bind("k", function ()
        self:die()
    end)

    -- Ship picking
    self.ship = options.ship or nil
    self.polygons = {}
    self:shipManager()
end

function Player:update(dt)
    Player.super.update(self, dt)

    -- Boost controls
    self.maxVelocity = self.baseMaxVelocity
    self.boosting = false
    if input:down("up") then
        self.boosting = true
        self.maxVelocity = 1.5 * self.baseMaxVelocity
    end
    if input:down("down") then
        self.boosting = true
        self.maxVelocity = 0.5 * self.baseMaxVelocity
    end
    self.trailColor = skillPointColor
    if self.boosting then
        self.trailColor = boostColor
    end

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
    pushRotate(self.x, self.y, self.radian)
    love.graphics.setColor(backgroundColor)
    self.physicObj:draw("line")
    love.graphics.setColor(defaultColor)
    for _, polygon in ipairs(self.polygons) do
        local points = M.map(polygon, function (value, key)
            if key % 2 == 1 then
                return self.x + value --+ random(-1, 1)
            end
            return self.y + value --+ random(-1, 1)
        end)
        love.graphics.polygon("line", points)
    end
    love.graphics.pop()
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:shoot()
    local distanceFromShooter = 1.25 * self.w
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

function Player:shipManager()
    if self.ship == "Fighter" then

        self.timer:every(0.01, function ()
            self.area:addGameObject("TrailParticle",
                self.x - 0.9 * self.w * math.cos(self.radian) + 0.2 * self.w * math.cos(self.radian - math.pi/2),
                self.y - 0.9 * self.h * math.sin(self.radian) + 0.2 * self.w * math.sin(self.radian - math.pi/2),
                {parent = self, r = random(1, 2), duration = random(0.35, 0.4), color = self.trailColor})
            
            self.area:addGameObject("TrailParticle",
                self.x - 0.9 * self.w * math.cos(self.radian) + 0.2 * self.w * math.cos(self.radian + math.pi/2),
                self.y - 0.9 * self.h * math.sin(self.radian) + 0.2 * self.w * math.sin(self.radian + math.pi/2),
                {parent = self, r = random(1, 2), duration = random(0.35, 0.4), color = self.trailColor})
        end)

        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w * 1.5, -self.w,
            -self.w/2 * 1.5, -self.w/4,
            -self.w/2, -self.w/2,
            self.w/2, -self.w/2
        }
        self.polygons[3] = {
            -self.w/2, self.w/2,
            -self.w/2, self.w/2,
            -self.w/2 * 1.5, self.w/4,
            -self.w * 1.5, self.w,
            0, self.w,
            self.w/2, self.w/2
        }
    end

    if self.ship == "Whale" then

        self.timer:every(0.01, function ()
            self.area:addGameObject("TrailParticle",
                self.x - self.w * 2.4 * math.cos(self.radian + math.pi * 0.1475),
                self.y - self.w * 2.4 * math.sin(self.radian + math.pi * 0.1475),
                {parent = self, r = random(2,2.5), duration = random(0.2, 0.25), color = self.trailColor})
            self.area:addGameObject("TrailParticle",
                self.x - self.w * 2.4 * math.cos(self.radian - math.pi * 0.1475),
                self.y - self.w * 2.4 * math.sin(self.radian - math.pi * 0.1475),
                {parent = self, r = random(2,2.5), duration = random(0.2, 0.25), color = self.trailColor})
        end)

        self.polygons[1] = {
            self.w, 0,
            0, -self.w,
            -1.5*self.w, -self.w/2,
            -1.5*self.w, self.w/2,
            0, self.w
        }
        self.polygons[2] = {
            -self.w/2, -self.w/2 - 0.66 * self.w/2,
            -1.5*self.w, -1.5*self.w,
            -2*self.w, -1.5*self.w,
            -2*self.w, -self.w/2,
            -1.5*self.w, -self.w/2
        }
        self.polygons[3] = {
            -self.w/2, self.w/2 + 0.66 * self.w/2,
            -1.5 * self.w, self.w/2,
            -2 * self.w, self.w/2,
            -2 * self.w, 1.5 * self.w,
            -1.5 * self.w, 1.5 * self.w
        }
    end
end
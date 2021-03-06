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
    self.class = "Player"

    -- Boost
    self.boostBaseResource = 100
    self.boostResource = self.boostBaseResource
    self.boostBaseRegen = 10
    self.boostRegen = self.boostBaseRegen
    self.boostBaseDrain = 50
    self.boostDrain = self.boostBaseDrain
    self.boostBlocked = false
    self.boostUiColor = boostColor
    self.boostUiSecondaryColor = boostUiSecondaryColor
    self.boostUiWidth = 100 / self.boostBaseResource * self.boostResource
    self.boostUiBackgroundWidth = self.boostUiWidth
    self.boostCooldown = 2

    -- HP
    self.baseHp = 100
    self.hp = self.baseHp
    self.hpUiColor = hpColor
    self.hpUiSecondaryColor = hpUiSecondaryColor
    self.hpUiWidth = 100 / self.baseHp * self.hp
    self.hpUiBackgroundWidth = self.hpUiWidth

    -- Ammo
    self.baseAmmo = 100
    self.ammo = self.baseAmmo
    self.ammoUiWidth = 100 / self.baseAmmo * self.ammo
    self.ammoUiBackgroundWidth = self.ammoUiWidth
    self.ammoUiColor = ammoColor
    self.ammoUiSecondaryColor = ammoUiSecondaryColor

    self.uiBarHeight = 5

    self.depth = 75

    self.trailColor = skillPointColor

    self.timer:every(5, function ()
        self:tick()
    end)

    input:bind("k", function ()
        self:die()
    end)

    self.shootTimer = 0
    self:setAttack("Neutral")

    -- Ship picking
    self.ship = options.ship or "Fighter"
    self.polygons = {}
    self:shipManager()
end

function Player:update(dt)
    Player.super.update(self, dt)

    -- HP

    -- Ammo

    -- Boost controls
    self.maxVelocity = self.baseMaxVelocity
    self.boosting = false
    if input:down("up") and not self.boostBlocked then
        self.boosting = true
        self.maxVelocity = 1.8 * self.baseMaxVelocity
    end
    if input:down("down") and not self.boostBlocked then
        self.boosting = true
        self.maxVelocity = 0.75 * self.baseMaxVelocity
    end
    self.trailColor = ammoColor
    if self.boosting then
        self.boostResource = math.max(self.boostResource - self.boostDrain * dt, 0)
        self.timer:after("boostUiBackgroundAfter", 0.15, function ()
            self.timer:tween("boostUiBackgroundTween", 0.25, self, {boostUiBackgroundWidth = self.boostUiWidth}, "in-out-cubic")
        end)
        self.trailColor = boostColor
    end

    -- Boost resource management
    self.boostResource = math.min(self.boostResource + self.boostRegen * dt, self.boostBaseResource)
    if self.boostResource < 1 then
        if self.boosting then
            self.boosting = false
        end
        self.boostBlocked = true
        self.timer:after(self.boostCooldown, function ()
            self.boostBlocked = false
        end)
    end

    -- UI
    self.boostUiWidth = 100 / self.boostBaseResource * self.boostResource
    if self.boostUiBackgroundWidth < self.boostUiWidth then
        self.boostUiBackgroundWidth = self.boostUiWidth
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

    -- Collision
    if not self.dead then
        for collidingObject, escapeVector in pairs(hc.collisions(self.physicObj)) do
            if collidingObject.object then
                if collidingObject.object.class == "Ammo" then
                    self:changeAmmo(5)
                end
                if collidingObject.object.class == "Booster" then
                    self:changeBooster(25)
                end
                if collidingObject.object.class == "HpObject" then
                    self:changeHp(25)
                end
                if collidingObject.object.class == "SkillPointObject" then
                    changeSp(1)
                end

                if collidingObject.object.class == "AttackObject" then
                    self:setAttack(collidingObject.object.attack)
                end

                if not collidingObject.object.friendly then
                    collidingObject.object:die()
                end
            end
        end
    end

    -- Switch Attack type
    if self.ammo == 0 then
        self:setAttack("Neutral")
    end

    -- Shoot timer
    self.shootTimer = self.shootTimer + dt
    if attacks[self.currentAttack].cooldown < self.shootTimer then
        self.shootTimer = 0
        self:shoot()
    end
end

function Player:draw()
    pushRotate(self.x, self.y, self.radian)
    love.graphics.setColor(0,0,0,0)
    self.physicObj:draw("line")
    love.graphics.setColor(defaultColor)
    for _, polygon in ipairs(self.polygons) do
        local points = M.map(polygon, function (value, key)
            if key % 2 == 1 then
                return self.x + value + random(-0.5, 0.5)
            end
            return self.y + value + random(-0.5, 0.5)
        end)
        love.graphics.polygon("line", points)
    end
    love.graphics.pop()

    -- UI
    -- HP
    love.graphics.setColor(self.hpUiSecondaryColor)
    love.graphics.rectangle("fill", 10, 5, self.hpUiBackgroundWidth, self.uiBarHeight)
    love.graphics.setColor(self.hpUiColor)
    love.graphics.rectangle("fill", 10, 5, self.hpUiWidth, self.uiBarHeight)

    -- Boost
    love.graphics.setColor(boostUiSecondaryColor)
    love.graphics.rectangle("fill", 10, 12, self.boostUiBackgroundWidth, self.uiBarHeight)
    if not self.boostBlocked then
        love.graphics.setColor(self.boostUiColor)
    end
    love.graphics.rectangle("fill", 10, 12, self.boostUiWidth, self.uiBarHeight)

    -- Ammo
    love.graphics.setColor(self.ammoUiSecondaryColor)
    love.graphics.rectangle("fill", 10, 19, self.ammoUiBackgroundWidth, self.uiBarHeight)
    love.graphics.setColor(self.ammoUiColor)
    love.graphics.rectangle("fill", 10, 19, self.ammoUiWidth, self.uiBarHeight)

    love.graphics.setColor(defaultColor)
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

    if self.currentAttack == "Neutral" then
        self.area:addGameObject("Projectile",
        self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
        self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
        {radian = self.radian, friendly = true, velocity = self.velocity})
    end

    if self.currentAttack == "Rapid" then
        self:changeAmmo(-attacks[self.currentAttack].ammoCost)
        self.area:addGameObject("Projectile",
        self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
        self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
        {radian = self.radian, friendly = true, velocity = self.velocity, attack = self.currentAttack})
    end

    if self.currentAttack == "Double" then
        self:changeAmmo(-attacks[self.currentAttack].ammoCost)
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
            {radian = self.radian - math.rad(15), friendly = true, velocity = self.velocity, attack = self.currentAttack})
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
            {radian = self.radian + math.rad(15), friendly = true, velocity = self.velocity, attack = self.currentAttack})
    end

    if self.currentAttack == "Triple" then
        self:changeAmmo(-attacks[self.currentAttack].ammoCost)
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
            {radian = self.radian - math.rad(15), friendly = true, velocity = self.velocity, attack = self.currentAttack})
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
            {radian = self.radian + math.rad(15), friendly = true, velocity = self.velocity, attack = self.currentAttack})
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
            {radian = self.radian, friendly = true, velocity = self.velocity, attack = self.currentAttack})
    end

    if self.currentAttack == "Spread" then
        self:changeAmmo(-attacks[self.currentAttack].ammoCost)
        self.area:addGameObject("Projectile",
        self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
        self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
        {radian = self.radian + math.rad(random(-20, 20)), friendly = true, velocity = self.velocity, attack = self.currentAttack})
    end

    if self.currentAttack == "Back" then
        self:changeAmmo(-attacks[self.currentAttack].ammoCost)
        self.area:addGameObject("Projectile",
        self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
        self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
        {radian = self.radian, friendly = true, velocity = self.velocity, attack = self.currentAttack})
    self.area:addGameObject("Projectile",
        self.x - 1.5 * distanceFromShooter * math.cos(self.radian),
        self.y - 1.5 * distanceFromShooter * math.sin(self.radian),
        {radian = self.radian - math.rad(180), friendly = true, velocity = self.velocity, attack = self.currentAttack})
    end

    if self.currentAttack == "Side" then
        self:changeAmmo(-attacks[self.currentAttack].ammoCost)
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian),
            {radian = self.radian, friendly = true, velocity = self.velocity, attack = self.currentAttack})
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian + math.rad(90)),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian + math.rad(90)),
            {radian = self.radian + math.rad(90), friendly = true, velocity = self.velocity, attack = self.currentAttack})
        self.area:addGameObject("Projectile",
            self.x + 1.5 * distanceFromShooter * math.cos(self.radian - math.rad(90)),
            self.y + 1.5 * distanceFromShooter * math.sin(self.radian - math.rad(90)),
            {radian = self.radian - math.rad(90), friendly = true, velocity = self.velocity, attack = self.currentAttack})
    end
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

    if self.ship == "Raider" then

        self.timer:every(0.01, function ()
            self.area:addGameObject("TrailParticle",
            self.x - self.w * math.cos(self.radian),
            self.y - self.w * math.sin(self.radian),
            {parent = self, r = random(1.5, 2.5), duration = random(0.35, 0.4), color = self.trailColor})
        end)

        self.polygons[1] = {
            self.w, 0,
            0, -self.w/4,
            -0.75 * self.w, 0,
            0, self.w/4
        }
        self.polygons[2] = {
            0, -self.w/4,
            -0.3*self.w, -0.6 * self.w,
            0.75*self.w, -self.w,
            -0.75*self.w, -self.w,
            -self.w, -0.6*self.w,
            -0.75 * self.w, 0
        }
        self.polygons[3] = {
            0, self.w/4,
            -0.75 * self.w, 0,
            -self.w, 0.6*self.w,
            -0.75*self.w, self.w,
            0.75*self.w, self.w,
            -0.3*self.w, 0.6*self.w
        }
    end

    if self.ship == "Zeta" then
        self.timer:every(0.01, function ()
            self.area:addGameObject("TrailParticle",
            self.x - self.w * math.cos(self.radian),
            self.y - self.w * math.sin(self.radian),
            {parent = self, r = random(1.5, 2.5), duration = random(0.35, 0.4), color = self.trailColor})
        end)

        self.polygons[1] = {
            self.w, 0,
            0.8*self.w, -0.6*self.w,
            0.6*self.w, -0.8*self.w,
            0, -self.w,
            -0.6*self.w, -0.8*self.w,
            -0.8*self.w, -0.6*self.w,
            -self.w, 0,
            -0.8*self.w, 0.6*self.w,
            -0.6*self.w, 0.8*self.w,
            0, self.w,
            0.6*self.w, 0.8*self.w,
            0.8*self.w, 0.6*self.w
        }
        self.polygons[2] = {
            0, -self.w,
            -1.2*self.w, -self.w,
            -0.8*self.w, -0.6*self.w,
            -0.6*self.w, -0.8*self.w
        }
        self.polygons[3] = {
            0, self.w,
            -0.6*self.w, 0.8*self.w,
            -0.8*self.w, 0.6*self.w,
            -1.2*self.w, self.w
        }
    end

    if self.ship == "Ray" then
        self.timer:every(0.01, function ()
            self.area:addGameObject("TrailParticle",
                self.x - 1.2*self.w * math.cos(self.radian + math.pi*0.1944),
                self.y - 1.2*self.w * math.sin(self.radian + math.pi*0.1944),
                {parent = self, r = random(1, 2), duration = random(0.35, 0.4), color = self.trailColor})
            self.area:addGameObject("TrailParticle",
                self.x - 1.2*self.w * math.cos(self.radian - math.pi*0.1944),
                self.y - 1.2*self.w * math.sin(self.radian - math.pi*0.1944),
                {parent = self, r = random(1, 2), duration = random(0.35, 0.4), color = self.trailColor})
        end)

        self.polygons[1] = {
            self.w, 0,
            -self.w/2, -self.w/2,
            -self.w, -self.w,
            -self.w, self.w,
            -self.w/2, self.w/2
        }
    end
end

function Player:changeAmmo(amount)
    self.ammo = math.max(math.min(self.ammo + amount, self.baseAmmo), 0)

    -- UI
    self.ammoUiWidth = 100 / self.baseAmmo * self.ammo
    self.timer:after("ammoUiBackgroundAfter", 0.1, function ()
        self.timer:tween("ammoUiBackgroundTween", 0.1, self, {ammoUiBackgroundWidth = self.ammoUiWidth}, "in-out-cubic")
    end)

    if self.ammoUiBackgroundWidth < self.ammoUiWidth then
        self.ammoUiBackgroundWidth = self.ammoUiWidth
    end
end

function Player:changeBooster(amount)
    self.boostResource = math.max(math.min(self.boostResource + amount, self.boostBaseResource), 0)
end

function Player:changeHp(amount)
    self.hp = math.max(math.min(self.hp + amount, self.baseHp), 0)
end

function Player:setAttack(type)
    self.currentAttack = type
    self.shotCooldown = attacks[type].cooldown
    self:changeAmmo(self.baseAmmo)
end
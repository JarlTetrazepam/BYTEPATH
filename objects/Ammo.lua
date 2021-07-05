Ammo = GameObject:extend()

function Ammo:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.w = 8
    self.radian = random(2 * math.pi)
    self.velocity = random(0.1, 0.2)
    self.class = "Ammo"

    self.physicObj = hc.rectangle(self.x, self.y, self.w or 0, self.h or self.w / 1.2 or 0)
    self.physicObj.object = self
end

function Ammo:update(dt)
    self.timer:update(dt)

    self.x, self.y = self.physicObj:center()
    if self.area.room.playerObject then
        self.direction = unitVector(self.area.room.playerObject.x - self.x, self.area.room.playerObject.y - self.y)
        self.physicObj:move(self.direction[1] * self.velocity, self.direction[2] * self.velocity)
    end
    self.physicObj:rotate(math.pi/4 * dt)

end

function Ammo:draw()
    love.graphics.setColor(ammoColor)
    self.physicObj:draw("line")
    love.graphics.setColor(defaultColor)
end

function Ammo:destroy()
    Ammo.super.destroy(self)
end

function Ammo:die()
    self.area:addGameObject("ProjectileDeathEffect", self.x, self.y, {color = ammoColor, w = self.w/4 * 3, duration = random(0.1, 0.2)})
    for i = 1, random(5,8) do
        self.area:addGameObject("ExplodeParticle", self.x, self.y, {w = 3, color = ammoColor, velocity = random(0.8)})
    end
    self.dead = true
end
Projectile = GameObject:extend()

function Projectile:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.class = "Projectile"
    self.physicObj = hc.circle(self.x, self.y, 10)
    self.physicObj.object = self
    self.speedmult = 4
    self.velocityX = unitVector(((gw / 2) - self.x), ((gh / 2) - self.y))[1] * self.speedmult
    self.velocityY = unitVector(((gw / 2) - self.x), ((gh / 2) - self.y))[2] * self.speedmult
end

function Projectile:update(dt)
    self.timer:update(dt)
    self.physicObj:move(self.velocityX, self.velocityY)

    for collidingObject, vector in pairs(hc.collisions(self.physicObj)) do
        --print(vector.x, vector.y, self.velocityX, self.velocityY)
        --camera:shake(1, 10, 0.3)
        print(collidingObject.object.class)

        -- Entry angle = exit angle
        local selfX, selfY = self.physicObj:center()
        local objectX, objectY = collidingObject:center()
        if self.velocityX > self.velocityY then
            self.velocityX = vector.x
            self.velocityY = selfY - objectY
        elseif self.velocityX < self.velocityY then
            self.velocityX = selfX - objectX
            self.velocityY = vector.y
        else -- Account for self.velocityX = self.velocityY
            self.velocityX = vector.x
            self.velocityY = vector.y
        end

        -- Keep speed constant after collision, as per http://vrld.github.io/HardonCollider/tutorial.html
        self.velocityX = unitVector(self.velocityX, self.velocityY)[1] * self.speedmult / 2
        self.velocityY = unitVector(self.velocityX, self.velocityY)[2] * self.speedmult / 2

        --collidingObject:move(-vector.x, -vector.y)
    end

    if self.dead then
        hc.remove(self.physicObj)
    end
end

function Projectile:draw()
    self.physicObj:draw("fill")
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end
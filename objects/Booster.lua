Booster = GameObject:extend()

function Booster:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.w = options.w or 9
    if random(-1, 1) > 0 then
        self.x = self.w
        self.startingSide = "left"
    else
        self.x = gw - self.w*2
        self.startingSide = "right"
    end
    self.y = random(gh)
    self.radian = random(2 * math.pi)
    self.velocity = random(1, 2)

    self.physicObj = hc.rectangle(self.x, self.y, self.w or 0, options.h or self.w or 0)
    self.physicObj2 = hc.rectangle(self.x + self.w*0.25, self.y + self.w*0.25, self.w*0.5 or 0, self.w*0.5)
    self.physicObj.object = self
    self.class = "Booster"
end

function Booster:update(dt)
    self.timer:update(dt)

    self.x, self.y = self.physicObj:bbox()
    if self.startingSide == "left" then
        self.physicObj:move(self.velocity, 0)
        self.physicObj2:move(self.velocity, 0)
    else
        self.physicObj:move(-self.velocity, 0)
        self.physicObj2:move(-self.velocity, 0)
    end
    self.physicObj:rotate(self.radian * dt)
    self.physicObj2:rotate(self.radian * dt)

    if self.x < 0 or self.x > gw + self.w or self.y < 0 or self.y > gh then
        self.dead = true
    end
end

function Booster:draw()
    love.graphics.setColor(boostColor)
    self.physicObj:draw("line")
    self.physicObj2:draw("fill")
    love.graphics.setColor(defaultColor)
end

function Booster:destroy()
    Booster.super.destroy(self)
end

function Booster:die()
    self.area:addGameObject("BoosterEffect", self.physicObj:center())
    self.area:addGameObject("InfoText", self.x + self.w, self.y, {text = "+BOOST", color = boostColor})
    self.dead = true
end
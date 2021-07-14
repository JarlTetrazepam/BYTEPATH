AttackObject = GameObject:extend()

function AttackObject:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.attack = options.attack or "Double" -- Prevent game crash by defaulting to Double
    self.color = attacks[self.attack].color

    self.w = options.w or 10
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
    self.rotateFactor = 0

    self.physicObj = hc.rectangle(self.x, self.y, self.w or 0, options.h or self.w or 0)
    self.physicObj.object = self
    self.class = "AttackObject"
end

function AttackObject:update(dt)
    self.timer:update(dt)

    if self.startingSide == "left" then
        self.physicObj:move(self.velocity, 0)
    else
        self.physicObj:move(-self.velocity, 0)
    end
    self.x, self.y = self.physicObj:bbox()
    self.rotateFactor = self.rotateFactor + 10 * dt

    if self.x < 0 or self.x > gw + self.w or self.y < 0 or self.y > gh then
        self.dead = true
    end
end

function AttackObject:draw()
    pushRotate(self.x + self.w/2, self.y + self.w/2, self.rotateFactor)
    love.graphics.setColor(self.color)
    self.physicObj:draw("line")
    love.graphics.setColor(defaultColor)
    love.graphics.rectangle("line", self.x + 1, self.y + 1, self.w - self.w/4, self.h or self.w - self.w/4)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x + self.w/4 + 1, self.y + self.w/4 + 1, self.w/4, self.w/4)
    love.graphics.pop()
    love.graphics.setColor(defaultColor)
end

function AttackObject:destroy()
    AttackObject.super.destroy(self)
end

function AttackObject:die()
    self.area:addGameObject("AttackObjectEffect", self.x, self.y, {color = self.color, w = self.w})
    self.area:addGameObject("InfoText", self.x + self.w, self.y, {text = string.upper(self.attack), color = self.color})
    self.dead = true
end
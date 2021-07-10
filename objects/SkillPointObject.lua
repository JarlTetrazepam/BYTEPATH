SkillPointObject = GameObject:extend()

function SkillPointObject:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.w = options.w or 6
    if random(-1, 1) > 0 then
        self.x = self.w
        self.startingSide = "left"
    else
        self.x = gw - self.w*2
        self.startingSide = "right"
    end
    self.y = random(gh)
    self.radian = random(2 * math.pi)
    self.velocity = random(0.5, 1)

    self.vertices = {
        0.5*self.w, 0,
        0, -self.w,
        -0.5*self.w, 0,
        0, self.w
    }
    self.points = M.map(self.vertices, function (point, key)
        if key % 2 == 1 then
            return self.x + point
        else
            return self.y + point
        end
    end)
    self.physicObj = hc.polygon(unpack(self.points))
    self.physicObj.object = self
    self.class = "SkillPointObject"
end

function SkillPointObject:update(dt)
    self.timer:update(dt)

    self.x, self.y = self.physicObj:bbox()
    if self.startingSide == "left" then
        self.physicObj:move(self.velocity, 0)
    else
        self.physicObj:move(-self.velocity, 0)
    end
    self.physicObj:rotate(self.radian * dt)

    if self.x < 0 or self.x > gw + self.w or self.y < 0 or self.y > gh then
        self.dead = true
    end
end

function SkillPointObject:draw()
    love.graphics.setColor(skillPointColor)
    self.physicObj:draw("fill")
    love.graphics.setColor(defaultColor)
end

function SkillPointObject:destroy()
    SkillPointObject.super.destroy(self)
end

function SkillPointObject:die()
    for i = 1, random(6, 8), 1 do
        self.area:addGameObject("ExplodeParticle", self.x, self.y, {w = 5, color = self.color, velocity = random(0.4, 1)})
    end
    self.area:addGameObject("InfoText", self.x + self.w * 2.5, self.y - self.w, {text = "+1SP", color = skillPointColor})
    self.dead = true
end
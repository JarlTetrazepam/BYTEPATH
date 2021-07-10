HpObject = GameObject:extend()

function HpObject:new(area, x, y, options)
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
        self.w, -0.3*self.w,
        0.3*self.w, -0.3*self.w,
        0.3*self.w, -self.w,
        -0.3*self.w, -self.w,
        -0.3*self.w, -0.3*self.w,
        -self.w, -0.3*self.w,
        -self.w, 0.3*self.w,
        -0.3*self.w, 0.3*self.w,
        -0.3*self.w, self.w,
        0.3*self.w, self.w,
        0.3*self.w, 0.3*self.w,
        self.w, 0.3*self.w
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
    self.class = "HpObject"
end

function HpObject:update(dt)
    self.timer:update(dt)

    self.x, self.y = self.physicObj:bbox()
    if self.startingSide == "left" then
        self.physicObj:move(self.velocity, 0)
    else
        self.physicObj:move(-self.velocity, 0)
    end
    self.physicObj:rotate(self.radian * dt * 0.5)

    if self.x < 0 or self.x > gw + self.w or self.y < 0 or self.y > gh then
        self.dead = true
    end
end

function HpObject:draw()
    love.graphics.setColor(hpColor)
    self.physicObj:draw("fill")
    self.outcircleX, self.outcircleY, self.outcircleR = self.physicObj:outcircle()
    love.graphics.setColor(defaultColor)
    love.graphics.circle("line", self.outcircleX, self.outcircleY, self.outcircleR + self.w/3)
end

function HpObject:destroy()
    HpObject.super.destroy(self)
end

function HpObject:die()
    self.area:addGameObject("HpObjectEffect", self.x, self.y, {vertices = self.vertices})
    self.area:addGameObject("InfoText", self.x + self.w * 2.5, self.y - self.w, {text = "+HP", color = hpColor})
    self.dead = true
end
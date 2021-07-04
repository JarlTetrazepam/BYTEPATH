ExplodeParticle = GameObject:extend()

function ExplodeParticle:new(area, x, y, options)
    self.super.new(self, area, x, y, options)

    self.color = options.color or defaultColor
    self.velocity = options.velocity or random(2)
    self.radian = random(0, math.pi * 2)
    self.length = options.length or random(0.5, 4)
    self.w = 2

    self.physicObj = hc.rectangle(self.x, self.y, self.w, self.length)
    self.physicObj.object = self

    self.timer:tween(options.duration or random(0.3, 0.5), self, {velocity = 0, length = 0, w = 0},
        "linear", function ()
                    self:die()
                  end)
end

function ExplodeParticle:update(dt)
    self.timer:update(dt)

    self.x, self.y = self.physicObj:center()

    self.physicObj:move(
        math.cos(self.radian) * self.velocity,
        math.sin(self.radian) * self.velocity)
end

function ExplodeParticle:draw()
    pushRotate(self.x, self.y, self.radian)
    love.graphics.setColor(self.color)
    self.timer:after(0.1, function ()
        if not self.dead then
            love.graphics.setColor(1,1,1)
        end
    end)
    self.physicObj:draw("fill")
    love.graphics.setColor(1,1,1)
    love.graphics.pop()
end

function ExplodeParticle:destroy()
    ExplodeParticle.super.destroy(self)
end

function ExplodeParticle:die()
    self.dead = true
end
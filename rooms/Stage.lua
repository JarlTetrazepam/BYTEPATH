Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.timer = Timer()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)

    self.playerObject = self.area:addGameObject("Player", gw/2, gh/2, {ship = "Zeta"})

    input:bind("a", "left")
    input:bind("d", "right")
    input:bind("w", "up")
    input:bind("s", "down")

    input:bind("p", function ()
        self.area:addGameObject("Ammo", random(gw), random(gh))
        self.area:addGameObject("Booster")
        self.area:addGameObject("HpObject")
        self.area:addGameObject("SkillPointObject")
    end)
    input:bind("o", function ()
        self.area:addGameObject("AttackObject", random(gw), random(gh), {attack = tableRandom(attacks)})
    end)
end

function Stage:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw/2, gh/2)

    self.area:update(dt)
    self.timer:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.mainCanvas)
    love.graphics.clear()

    camera:attach(0, 0, gw, gh)

    self.area:draw()
    camera:detach()

    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.mainCanvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode("alpha")
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
    self.player = nil
end
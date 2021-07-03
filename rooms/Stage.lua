Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.timer = Timer()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)

    self.playerObject = self.area:addGameObject("Player", gw/2, gh/2)
    for i = 1, 10, 1 do
        --self.area:addGameObject("Circle", random(gw), random(gh))
    end

    input:bind("a", "left")
    input:bind("d", "right")
    input:bind("w", "up")
    input:bind("s", "down")
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
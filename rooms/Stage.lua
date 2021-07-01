Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)

    local borderTop = hc.rectangle(0, 0, gw, 10)
    local borderBottom = hc.rectangle(0, gh, gw, 10)
    local borderRight = hc.rectangle(0, 0, 10, gh)
    local borderLeft = hc.rectangle(gw, 0, 10, gh)

    input:bind("r", function ()
        for _, object in pairs(self.area.gameObjects) do
            object.dead = true
        end
        self.area:addGameObject("Player", gw/2, gh/2)
        for i = 1, 10 do
            self.area:addGameObject("Projectile", random(gw), random(gh))
        end
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
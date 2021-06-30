Stage = Object:extend()

function Stage:new()
    self.area = Area()
    self.timer = Timer()
    self.mainCanvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject("Player", gw/2, gh/2)
    input:bind("k", function ()
        if self.player then
            self.player.dead = true
            self.player = nil 
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
HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, lineWidth, outerRadius)
    background = Circle(x, y, radius)
    self.lineWidth = lineWidth
    self.outerRadius = outerRadius
end

function HyperCircle:update(dt)
    
end

function HyperCircle:draw()
    love.graphics.setColor(0,0,0)
    love.graphics.circle("fill", background.x, background.y, self.outerRadius)
    love.graphics.setColor(1,1,1)
    background:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.circle("line", background.x, background.y, self.outerRadius)
end
RectangleRoom = Object:extend()

function RectangleRoom:new()
    
end

function RectangleRoom:update(dt)
    
end

function RectangleRoom:draw()
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", 200, 400, 200, 50)
end
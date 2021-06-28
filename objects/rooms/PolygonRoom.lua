PolygonRoom = Object:extend()

function PolygonRoom:new()
    
end

function PolygonRoom:update(dt)
    
end

function PolygonRoom:draw()
    love.graphics.setColor(1,0,0)
    love.graphics.polygon("fill", 100, 100, 200, 100, 150, 200)
end
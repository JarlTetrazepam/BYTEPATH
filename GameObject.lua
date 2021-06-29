GameObject = Object:extend()

function GameObject:new(area, x, y, options)
    local options = options or {}
    if options then
        for key, option in pairs(options) do
            self[key] = option
        end
    end

    self.area = area
    self.y = y
    self.x = x
    self.id = UUID()
    self.timer = Timer()
    self.creationTime = love.timer.getTime()
    self.dead = false

end

function GameObject:update(dt)
    if self.timer then
        self.timer:update(dt)
    end
end

function GameObject:draw()

end
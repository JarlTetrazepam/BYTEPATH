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
    if self.physicObj then
        self.x, self.y = self.physicObj:center()
    end
end

function GameObject:draw()

end

function GameObject:destroy()
    self.timer:destroy()
    if self.physicObj then
        hc.remove(self.physicObj)
    end
    self.physicObj = nil
end
Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.playerPhysicObject = hc.circle(self.x, self.y, 20)
end

function Player:update(dt)
    Player.super.update(self, dt)
    if self.dead then
        hc.remove(self.playerPhysicObject)
    end
end

function Player:draw()
    self.playerPhysicObject:draw("line")
end
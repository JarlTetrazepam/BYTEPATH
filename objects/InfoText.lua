InfoText = GameObject:extend()

function InfoText:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.color = defaultColor
    self.visible = true
    self.depth = 80

    self.text = options.text or "test"
    self.characters = {}
    for i = 1, #self.text do
        table.insert(self.characters, self.text:utf8sub(i, i))
    end

    self.timer:after(0.2, function ()
        self.color = boostColor
        self.timer:after(0.35, function ()
            self:die()
        end)
        self.timer:every(0.05, function ()
            self.visible = not self.visible
        end, 6)
    end)
end

function InfoText:update(dt)
    self.timer:update(dt)
end

function InfoText:draw()
    if self.visible then
        love.graphics.setColor(self.color)

        love.graphics.setColor(defaultColor)
    end
end

function InfoText:destroy()
    InfoText.super.destroy(self)
end

function InfoText:die()
    self.dead = true
end
InfoText = GameObject:extend()

function InfoText:new(area, x, y, options)
    self.super.new(self, area, x, y, options)
    self.color = defaultColor
    self.visible = true
    self.depth = 80

    self.font = font
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
        love.graphics.setFont(self.font)
        for i = 1, #self.characters do
            local width = 0
            if i > 1 then
                for j = 1, i-1 do
                    width = width + self.font:getWidth(self.characters[j])
                end
            end
            love.graphics.print(self.characters[i], self.x + width, self.y, 
                                0, 1, 1, 0, self.font:getHeight()/2)
        end
        love.graphics.setColor(defaultColor)
    end
end

function InfoText:destroy()
    InfoText.super.destroy(self)
end

function InfoText:die()
    self.dead = true
end
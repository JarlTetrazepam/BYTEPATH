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

    self.backgroundColors = {}
    self.foregroundColors = {}
    self.allColors = M.append(defaultcolors, negativeColors)

    self.timer:after(0.7, function ()
        self.timer:every(0.2, function () -- Change letter
            local randomCharacters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
            local randomIndex = random(#randomCharacters)
            self.characters[random(#self.characters)] = randomCharacters:utf8sub(randomIndex, randomIndex)
        end)

        self.timer:every(0.035, function () -- Change background
            for i, character in ipairs(self.characters) do
                if random(10) == 3 then
                    self.backgroundColors[i] = self.allColors[random(#self.allColors)]
                else
                    self.backgroundColors[i] = nil
                end
                if random(20) == 1 then
                    self.foregroundColors[i] = self.allColors[random(#self.allColors)]
                else
                    self.foregroundColors[i] = nil
                end
            end
        end)

        self.color = options.color or defaultColor
        self.timer:after(0.4, function ()
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
        love.graphics.setFont(self.font)
        for i = 1, #self.characters do
            local width = 0
            if i > 1 then
                for j = 1, i-1 do
                    width = width + self.font:getWidth(self.characters[j])
                end
            end
            if self.backgroundColors[i] then
                love.graphics.setColor(self.backgroundColors[i])
                love.graphics.rectangle("fill", self.x + width, self.y - self.font:getHeight()/2,
                                        self.font:getWidth(self.characters[i]), self.font:getHeight())
            end
            love.graphics.setColor(self.foregroundColors[i] or self.color or defaultColor)
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
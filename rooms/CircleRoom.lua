CircleRoom = Object:extend()

function CircleRoom:new()
    self.area = Area()
    self.timer = Timer()

    function process()
        timer:cancel("every")
        for i = 1, 10, 1 do
            timer:after(i * 0.25, function ()
                self.area:addGameObject("Circle", love.math.random(800), love.math.random(600), {r = love.math.random(100)})
            end)
        end
        timer:after(2.5, function ()
            timer:every("every", love.math.random(0.5, 1), function ()
                table.remove(self.area.gameObjects, love.math.random(#self.area.gameObjects))
                if #self.area.gameObjects == 0 then
                    process()
                end
            end)
        end)
    end

    process()
end

function CircleRoom:update(dt)
    self.area:update(dt)
    self.timer:update(dt)
end

function CircleRoom:draw()
    self.area:draw()
end
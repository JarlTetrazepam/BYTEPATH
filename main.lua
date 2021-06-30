Object = require 'libs/classic-master/classic'
Timer = require 'libs/EnhancedTimer-master/EnhancedTimer'
Input = require 'libs/boipushy-master/Input'
M = require 'libs/Moses-master/moses'
Camera = require("libs/hump-master/camera")

require 'GameObject'
require 'utils'

function love.load()
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setLineStyle("rough")
	resize(1)
    local objectFiles = {}
    recursiveEnumerate('objects', objectFiles)
    requireFiles(objectFiles)

    local roomFiles = {}
    recursiveEnumerate('rooms', roomFiles)
    requireFiles(roomFiles)

    timer = Timer()
    input = Input()
	camera = Camera()

    currentRoom = nil
	gotoRoom("Stage")
	input:bind("f3", function ()
		camera:shake(4, 60, 1)
	end)
end

function love.update(dt)
	camera:update(dt)
    timer:update(dt)
    if currentRoom then currentRoom:update(dt) end
end

function love.draw()
    if currentRoom then currentRoom:draw() end
end

-- Room --
function gotoRoom(roomType, ...)
    currentRoom = _G[roomType](...)
end

-- Load --
function recursiveEnumerate(folder, fileList)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(fileList, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, fileList)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

function love.run()
    if love.math then love.math.setRandomSeed(os.time()) end
    if love.load then love.load(arg) end
    if love.timer then love.timer.step() end

    local dt = 0
    local fixed_dt = 1/60
    local accumulator = 0

    while true do
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == 'quit' then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        accumulator = accumulator + dt
        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.0001) end
    end
end

function resize(scale)
	love.window.setMode(scale*gw, scale*gh)
	sx = scale
	sy = scale
end
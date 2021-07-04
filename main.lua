Object = require 'libs/classic-master/classic'
Timer = require 'libs/EnhancedTimer-master/EnhancedTimer'
Input = require 'libs/boipushy-master/Input'
M = require 'libs/Moses-master/moses'
Camera = require("libs/hump-master/camera")
hc = require "libs/HC"

require 'GameObject'
require 'utils'
require "globals"

function love.load()
	timer = Timer()
    input = Input()
	camera = Camera()

	resize(2.5)
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setLineStyle("rough")
    local objectFiles = {}
    recursiveEnumerate('objects', objectFiles)
    requireFiles(objectFiles)

	flashFrames = nil

    local roomFiles = {}
    recursiveEnumerate('rooms', roomFiles)
    requireFiles(roomFiles)

    currentRoom = nil
	gotoRoom("Stage")

	-- Check for memory leaks
	input:bind('f1', function()
		print("Before collection: " .. collectgarbage("count")/1024)
		collectgarbage()
		print("After collection: " .. collectgarbage("count")/1024)
		print("Object count: ")
		local counts = type_count()
		for k, v in pairs(counts) do print(k, v) end
		print("-------------------------------------")
	end)

	input:bind("f2", function ()
		gotoRoom("Stage")
	end)

	input:bind("f3", function ()
		if currentRoom then
			currentRoom:destroy()
			currentRoom = nil
		end
	end)

	-- For dramtic slow-mo
	slowAmount = 1

	input:bind("t", function ()
		slowTime(0.5, 0.5)
	end)
end

function love.update(dt)
	camera:update(dt)
    timer:update(dt)
    if currentRoom then currentRoom:update(dt) end
end

function love.draw()
    if currentRoom then currentRoom:draw() end

	if flashFrames then
		flashFrames = flashFrames - 1
		if flashFrames == -1 then
			flashFrames = nil
		end
	end
	if flashFrames then
		love.graphics.setColor(backgroundColor)
		love.graphics.rectangle("fill", 0, 	0, sx * gw, sy * gh)
		love.graphics.setColor(defaultColor)
	end
end

-- Room --
function gotoRoom(roomType, ...)
	if currentRoom and currentRoom.destroy then
		currentRoom:destroy()
	end
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
            dt = love.timer.getDelta() * slowAmount
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
	sx = scale
	sy = scale
	love.window.setMode(scale*gw, scale*gh)
end
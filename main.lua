Object = require "libs/classic-master/classic"
Input = require("libs/boipushy-master/Input")

-- Main loop START
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 1.0 / 60.0
    local t = 0.0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		--if love.timer then dt = love.timer.step() end

        t = t + dt

		-- Call update and draw
		if love.update then love.update(t) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
-- Main loop END

function add()
	local sum = 0
	sum = sum + 1
	print(sum)
end

function love.load()
	local objectFiles = {}
	recursiveEnumerate("objects", objectFiles)
	makeFileRequired(objectFiles)
	input = Input()
	input:bind("+", "add")
end

function recursiveEnumerate(filePath, fileList)
	local fileOrFolderList = love.filesystem.getDirectoryItems(filePath)
	for _, item in ipairs(fileOrFolderList) do
		local fileOrFolder = filePath .. "/" .. item
		if love.filesystem.isFile(fileOrFolder) then
			table.insert(fileList, fileOrFolder)
		elseif love.filesystem.isDirectory(fileOrFolder) then
			recursiveEnumerate(fileOrFolder, fileList)
		end
	end
end

function makeFileRequired(files)
	for _, file in ipairs(files) do
		local fileName = file:sub(1, -5)
		require(fileName)
	end
end

function love.update(dt)
	if input:down("add", 0.25) then add() end
end

function love.draw()

end
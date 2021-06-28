Object = require "libs/classic-master/classic"
Input = require("libs/boipushy-master/Input")
Timer = require("libs/EnhancedTimer-master/EnhancedTimer")

-- Main loop START
function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
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
		if love.timer then dt = love.timer.step() end
 
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
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

function love.load()
	local objectFiles = {}
	recursiveEnumerate("objects", objectFiles)
	makeFileRequired(objectFiles)
	input = Input()
	timer = Timer()

	HP = {x = 300, y = 250, w = 400, h = 50}
	HPBg = {x = 300, y = 250, w = 400, h = 50}
	input:bind("d", "damage")

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

function damage(val)
	local deducted = HP.w - val
	if deducted < 0 then
		deducted = 0
	end
	if HP.w > 0 and HPBg.w > 0 then
		timer:tween("w",0.3, HP, {w = deducted}, "in-out-cubic", function()
			timer:tween("w",1, HPBg, {w = HP.w}, "in-out-cubic")
		end)
	end
end

function love.update(dt)
	timer:update(dt)
	if input:down("damage", 0.8) then
		dmgVal = love.math.random(10, 40)
		damage(dmgVal) 
	end
end

function love.draw()
	love.graphics.setColor(0.6,0,0)
	love.graphics.rectangle("fill", HPBg.x, HPBg.y, HPBg.w, HPBg.h)
	love.graphics.setColor(1,0.2,0.2)
	love.graphics.rectangle("fill", HP.x, HP.y, HP.w, HP.h)
end
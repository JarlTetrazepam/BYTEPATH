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

function love.load()
    love.window.setMode(1000, 800, {vsync=1})
    image = love.graphics.newImage('Idle (1).png')
end

function love.update(dt)

end

function love.draw()
    love.graphics.print(love.timer.step(), 900, 500)
    love.graphics.draw(image, love.math.random(0, 800), 0)
end
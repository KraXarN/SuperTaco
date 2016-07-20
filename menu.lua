menu = {}

function menu.load()
	-- Music
	play("menu")
	-- TESTING: Compress
	if love.filesystem.exists("save") == false then
		love.filesystem.createDirectory("save")
	end
	if love.filesystem.write("save/zero.sav", love.math.compress("PROGRESS=FALSE", "lz4", -1)) == false then
		error("Error saving progress")
	end
	-- Menu option
	opt = 0
end

function menu.move(key)
	-- Check menu keys
	if key == "up" and opt > 0 then
		opt = opt - 1
	elseif key == "down" and opt < 3 then
		opt = opt + 1
	elseif key == "return" then
		if opt == 0 then
			-- New Game
			scene = "player"
			--musicMenu:stop()
			level.load()
			player.load()
		elseif opt == 1 then
			-- Load Game
		elseif opt == 2 then
			-- Options
			scene = "options"
			options.load()
		elseif opt == 3 then
			-- Exit Game
			love.event.quit()
		end
	end
end

function menu.draw()
	-- Set font
	love.graphics.setFont(fontTitle)
	-- Draw menu (TODO: Work with multiple resulotions)
	--[[
	if opt == 0 then
		love.graphics.print("=> Start Game \n   Options \n   Exit", 128, 280)
	elseif opt == 1 then
		love.graphics.print("   Start Game \n=> Options \n   Exit", 128, 280)
	else
		love.graphics.print("   Start Game \n   Options \n=> Exit", 128, 280)
	end
	--]]
	--love.graphics.print("Opt: " .. opt, 16, 48)
	love.graphics.print("New Game \nLoad Game \nOptions \nExit", 128, 280)
	love.graphics.polygon("line", 84, 284+opt*32, 108, 296+opt*32, 84, 308+opt*32, 90, 296+opt*32)
end


function menu_update(dt)
end

function menu_keypress(key)
	menu.move(key)
end

function menu_draw()
	menu.draw()
end

-- OLD CODE

--[[
function love.keypressed(key)
	-- Debug
	print("Key pressed: " .. key)
	-- Check menu keys
	if key == "up" and opt > 0 then
		opt = opt - 1
	elseif key == "down" and opt < 2 then
		opt = opt + 1
	elseif key == "return" then
		if opt == 0 then
			-- Start Game
		elseif opt == 1 then
			-- Options
		elseif opt == 2 then
			-- Exit Game
			love.event.quit()
		end
	end
end
--]]

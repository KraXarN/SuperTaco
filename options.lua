--[[
	( Max FPS )
	( VSync )
	Window Size (Scale)
	Fullscreen
	( MSAA )
	-
	Music Volume
	Sound Volume
	-
	Controller
	Keyboard
	Sound Test
	-
	Apply / Go back
--]]

--[[
{
	"fullscreen": false,
	"maxFps": 60,
	"msaa": 0,
	"musicVolume": 75,
	"soundVolume": 100,
	"vSync": false,
	"windowScale": 2
}
--]]

options = {}

function options.load()
	-- Set font
	--love.graphics.setFont(fontMenu) -- Change with text
	-- Reset arrow pos
	opt = 0
	-- OGL info
	glName, glVersion, glVendor, glDevice = love.graphics.getRendererInfo()
	-- TODO: Temp checks if not set, remove?
	text = {
		vSync = "ERR_NOT_SET",
		msaa = "ERR_NOT_SET"
	}
	love.graphics.setFont(fontMenu)
end

function options.move(key)
	if key == "up" and opt > 0 then
		if opt == 4 or opt == 7 or opt == 11 then
			opt = opt - 2
		else
			opt = opt - 1
		end
	elseif key == "down" and opt < 11 then
		if opt == 2 or opt == 5 or opt == 9 then
			opt = opt + 2
		else
			opt = opt + 1
		end
		-- Check enter, l and r in options.change
	end
end

function options.updateText()
	-- TODO: Ignore dt?
	-- VSync
	if setting.vSync then
		text.vSync = "On"
	else
		text.vSync = "Off"
	end
	-- MSAA
	if setting.msaa == 0 then
		text.msaa = "Off"
	else
		text.msaa = setting.msaa .. "x"
	end
end

function options.change(key)
	-- TODO: end or elseif?
	-- VSync
	if opt == 0 then
		if key == "left" and setting.vSync == true then
			setting.vSync = false
		elseif key == "right" and setting.vSync == false then
			setting.vSync = true
		elseif key == "return" then
			options.changeWindow()
		end
	end
	-- Window Size
	if opt == 1 then
		if key == "left" and setting.windowScale > 0.75 then
			setting.windowScale = setting.windowScale - 0.25
		elseif key == "right" and setting.windowScale < 1.5 then
			setting.windowScale = setting.windowScale + 0.25
		elseif key == "return" then
			options.changeWindow()
		end
	end
	-- MSAA
	if opt == 2 then
		if key == "left" and setting.msaa > 0 then
			setting.msaa = setting.msaa - 2
		elseif key == "right" and setting.msaa < love.graphics.getSystemLimits().canvasmsaa then
			setting.msaa = setting.msaa + 2
		elseif key == "return" then
			options.changeWindow()
		end
	end
	-- Music Volume
	if opt == 4 then
		if key == "left" and setting.musicVolume > 0 then
			setting.musicVolume = setting.musicVolume - 5
		elseif key == "right" and setting.musicVolume < 100 then
			setting.musicVolume = setting.musicVolume + 5
		elseif key == "return" then
			play("menu")
		end
	end
	-- Sound Volume
	if opt == 5 then
		if key == "left" and setting.soundVolume > 0 then
			setting.soundVolume = setting.soundVolume - 5
		elseif key == "right" and setting.soundVolume < 100 then
			setting.soundVolume = setting.soundVolume + 5
		end
	end
	-- TODO: Controller 7
	-- TODO: Keyboard 8
	-- Sound Test 9
	if opt == 9 and key == "return" then
		soundtest.load()
		scene = "soundtest"
	end
	-- Apply
	if opt == 11 and key == "return" then
		options.save()
		opt = 0
		scene = "menu"
	end
end

function options.changeWindow()
	local windowFlags = {
		fullscreen = setting.fullscreen,
		vsync = setting.vSync,
		msaa = setting.msaa
	}
	if love.window.setMode(setting.windowScale * 1280, setting.windowScale * 720, windowFlags) == false then
		error("Error setting window size")
	end
end

function options.save()
	love.filesystem.write("settings.json", JSON:encode_pretty(setting))
end


function options_update(dt)
	options.updateText()
end

function options_keypress(key)
	options.move(key)
	options.change(key)
end

function options_draw()
	-- TODO: Move to options.draw?
	love.graphics.print(
		--"Max FPS: " .. setting.maxFps .. -- TODO: No max fps?
		"VSync: " .. text.vSync ..
		-- "\nWindow Size: " .. setting.windowScale .. "x" .. " (" .. setting.windowScale * 1280 .. "x" .. setting.windowScale * 720 .. ")" .. -- TODO: Fullscreen as last option?
		"\nWindow Size: " .. setting.windowScale * 1280 .. "x" .. setting.windowScale * 720 .. " (" .. setting.windowScale .. "x)" ..
		"\nMSAA: " .. text.msaa ..

		"\n\nMusic Volume: " .. setting.musicVolume .. "%" ..
		"\nSound Volume: " .. setting.soundVolume .. "%" ..

		"\n\nController" .. "\nKeyboard" .. "\nSound Test" .. "\n\nApply",
	128, 64)
	love.graphics.polygon("line", 90, 66+opt*29, 114, 78+opt*29, 90, 90+opt*29, 96, 78+opt*29)
	-- info
	love.graphics.setFont(fontDebug)
	love.graphics.print(glName .. " " .. glVersion .. "\n" .. glVendor .. " " .. glDevice, love.graphics.getWidth() - 500, love.graphics.getHeight() - 70) -- TODO: Change pos based on size
	love.graphics.setFont(fontMenu)
end

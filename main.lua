-- Require
--require "player"
require "menu"
require "level"
require "options"
require "soundtest"

require "lovedebug"
--JSON = (loadfile "json.lua")()
JSON = require "json"

-- TESTING: Compressing
--compressok = love.filesystem.write("image0.lz4", love.math.compress(love.image.newImageData("image/spritesheet_ground.png"), "lz4", 0))

-- Gloval vars
scene = "menu"

gravity = 900

-- TESTING
start = love.timer.getTime()

function love.load()
	-- Config file
	if love.filesystem.exists("settings.json") == false then
		print("WARNING: No settings file found")
		setting = {
			maxFps = 60,
			vSync = false,
			windowScale = 1,
			fullscreen = false,
			fullscreenMode = "desktop",
			msaa = 0,
			musicVolume = 75,
			soundVolume = 100
		}
		if love.filesystem.write("settings.json", JSON:encode_pretty(setting)) == false then
			error("Unknown error writing settings file")
		end
	else
		setting = JSON:decode(love.filesystem.read("settings.json"))
	end
	-- Window
	local windowFlags = {
		fullscreen = setting.fullscreen,
		vsync = setting.vSync,
		msaa = setting.msaa
	}
	if love.window.setMode(setting.windowScale * 1280, setting.windowScale * 720, windowFlags) == false then
		error("Error setting window size")
	end
	love.graphics.setBackgroundColor(53, 152, 219)
	--[[
	if setting.fullscreen then
		love.window.setFullscreen(true, "desktop") -- TODO: Load from / check setting.fullscreenMode
	end
	--]]
	-- Font
	fontTitle = love.graphics.newFont("font/FutureSquare.ttf", 28)
	fontMenu = love.graphics.newFont("font/FutureNarrow.ttf", 26)
	fontDebug = love.graphics.newFont("font/Mini.ttf", 18)
	-- Load menu class, rest is loaded as needed
	menu.load()
	-- Dump debug info
	--[[
	if love.filesystem.exists("debug") == false then
		love.filesystem.createDirectory("debug") -- TODO: Only create if -debug?
	end
	love.filesystem.write("debug/fullscreen_modes_1.json", JSON:encode_pretty(love.window.getFullscreenModes(1)))
	love.filesystem.write("debug/supported.json", JSON:encode_pretty(love.graphics.getSupported()))
	love.filesystem.write("debug/compressed_image_formats.json", JSON:encode_pretty(love.graphics.getCompressedImageFormats()))
	love.filesystem.write("debug/system_limits.json", JSON:encode_pretty(love.graphics.getSystemLimits()))
	--]]

	-- Debug: Fullscreen resulotions
	debugLog = "Supported fullscreen resulotions: "
	debugFM = love.window.getFullscreenModes(1)
	for i=1, table.getn(debugFM) do
		if i == table.getn(debugFM) then
			debugLog = debugLog .. debugFM[i].height .. "x" .. debugFM[i].width
		else
			debugLog = debugLog .. debugFM[i].height .. "x" .. debugFM[i].width .. ", "
		end
	end
	-- Debug: Supprted
	debugS = love.graphics.getSupported()
	debugLog = debugLog .. "\n\nclampzero: " .. tostring(debugS.clampzero) .. "\nlighten: " .. tostring(debugS.lighten) .. "\nmulticanvasformats: " .. tostring(debugS.multicanvasformats)
	-- Debug: Compressed image formats
	debugCIF = love.graphics.getCompressedImageFormats()
	debugCIFy = "\n\nSupported image formats: "
	debugCIFn = "\n\nUnsupported image formats: "
	for k, v in pairs(debugCIF) do
		if v then
			debugCIFy = debugCIFy .. k .. ", "
		else
			debugCIFn = debugCIFn .. k .. ", "
		end
	end
	debugLog = debugLog .. debugCIFy .. debugCIFn -- Remove last 2 chars?
	-- Debug: System limits
	debugSL = love.graphics.getSystemLimits()
	debugLog = debugLog .. "\n\nMaximum size of points: " .. debugSL.pointsize .. "\nMaximum width or height of images and canvases: " .. debugSL.texturesize .. "\nMaximum number of canvases: " .. debugSL.multicanvas .. "\nMaximum AA samples: " .. debugSL.canvasmsaa

	love.filesystem.write("debug.log", debugLog)
end

function love.update(dt)
	update(scene, dt)
end

function love.keypressed(key)
	-- Debug
	--print("Key pressed: " .. key)
	keypress(scene, key)
end

function love.draw()
	-- Scene
	draw(scene)
	-- Debug
	love.graphics.print(love.timer.getFPS() .. "\n" .. math.floor(love.timer.getTime()-start), 16, 0)
end


function update(scene, dt)
	if scene == "menu" then
		menu_update(dt)
	elseif scene == "player" then
		level_update(dt)
	elseif scene == "options" then
		options_update(dt)
	elseif scene == "soundtest" then
		soundtest_update(dt)
	else
		error("Invalid scene: " .. scene)
	end
end

function draw(scene)
	if scene == "menu" then
		menu_draw()
	elseif scene == "player" then
		level_draw()
	elseif scene == "options" then
		options_draw()
	elseif scene == "soundtest" then
		soundtest_draw()
	else
		error("Invalid scene: " .. scene)
	end
end

function keypress(scene, key)
	if scene == "menu" then
		menu_keypress(key)
	elseif scene == "options" then
		options_keypress(key)
	elseif scene == "soundtest" then
		soundtest_keypress(key)
	end
end


function play(music, loop)
	love.audio.stop()
	music = love.audio.newSource("music/" .. music .. ".xm")
	if loop == false or loop == nil then
		music:setLooping(false)
	else
		music:setLooping(true)
	end
	music:setVolume(setting.musicVolume / 100)
	-- DEBUG: Don't play music
	--music:play()
end

function sfx(sound)
	-- TODO
end

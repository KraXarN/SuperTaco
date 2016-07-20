soundtest = {}

function soundtest.load()
	love.graphics.setFont(fontMenu)
	opt = 0
	selm = 1 -- Selected Music
	sels = 1 -- Selected Sound
	track = nil
	sound = {mus = {}, sfx = {}}
	-- All music tracks
	sound.mus.track = {"Menu", "Main Theme", "Boss", "Game Completed", "Game Over", "Dummy"}
	-- All music files
	sound.mus.file = {"menu", "main", "boss", "game", "ded", "dummy"}
	-- TODO: All sfx tracks
	-- TODO: All sfx files
	-- Info
	info = {
		playing = "ERR_NO_TRACK", -- Temp error
		position = 0,
		duration = 0,
		loadtime = 0
	}
end

function soundtest.move(key)
	if key == "up" and opt > 0 then
		if opt == 3 then
			opt = opt - 2
		else
			opt = opt - 1
		end
	elseif key == "down" and opt < 4 then
		if opt == 1 then
			opt = opt + 2
		else
			opt = opt + 1
		end
	end
end

function soundtest.change(key)
	-- Music
	if opt == 0 then
		if key == "left" and selm > 1 then
			selm = selm - 1
		elseif key == "right" and selm < table.getn(sound.mus.track) then
			selm = selm + 1
		elseif key == "return" then
			soundtest.play()
			info.playing = sound.mus.track[selm]
			info.duration = info.music:getDuration()
		end
	end
	-- TODO: Sfx
	-- Stop all
	if opt == 3 and key == "return" then
		love.audio.stop()
	end
	-- Go back
	if opt == 4 and key == "return" then
		opt = 0
		scene = "options"
	end
end

function soundtest.update()
	-- TODO: Ignore dt?
	if info.music ~= nil then
		info.position = math.floor(info.music:tell())
	end
end

function soundtest.play()
	time_before = love.timer.getTime()
	love.audio.stop()
	info.music = love.audio.newSource("music/" .. sound.mus.file[selm] .. ".xm") -- Or use music parameter?
	-- Loop?
	info.music:setVolume(setting.musicVolume / 100)
	info.music:play()
	time_after = love.timer.getTime()
	info.loadtime = math.floor((time_after - time_before) * 100000) / 100
end

function soundtest.draw()
	love.graphics.polygon("line", 90, 66+opt*29, 114, 78+opt*29, 90, 90+opt*29, 96, 78+opt*29)
	love.graphics.print("Music: " .. sound.mus.track[selm] .. "\nSoundFX: TODO" .. "\n\nStop all \nGo back", 128, 64)
	love.graphics.setFont(fontDebug)
	if info.playing ~= "ERR_NO_TRACK" then -- Temp?
		love.graphics.print("Playing " .. info.playing .. ": " .. info.position .. " / " .. info.duration .. "\nLoaded in: " .. info.loadtime .. " ms", love.graphics.getWidth() - 400, love.graphics.getHeight() - 100)
	end
	love.graphics.setFont(fontMenu)
end


function soundtest_update(dt)
	soundtest.update(dt)
end

function soundtest_keypress(key)
	soundtest.move(key)
	soundtest.change(key)
end

function soundtest_draw()
	soundtest.draw()
end

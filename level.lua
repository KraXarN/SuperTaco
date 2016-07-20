level = {}

require "player"

local bump = require "bump"
local sti = require "sti"

local world = bump.newWorld(64)

function level.new(level)
	map = sti.new("level/" .. level .. ".lua", {"bump"})
	map:bump_init(world)
	-- Start music
	play("main")
end

function level.load()
	-- Temp
	level.new("1-1")
	-- Create player
	--map:addCustomLayer("Sprites", 3)
	sprite = map.layers["Sprites"]
	sprite.player = {
		image = love.graphics.newImage("image/player_tmp.png"),
		x = 64,
		y = 64,
		r = 0,
		name = "Player"
	}
	-- Add collision to player
	world:add(sprite.player, 64, 64, 64, 64)
end

function level.update(dt)
	map:update(dt)
end

function level.draw()
	map:draw()
	map:bump_draw(world)
	--[[
	for k, v in pairs(map:getLayerProperties("Sprites")) do
		print(k .. ": " .. tostring(v))
	end
	--]]
	love.graphics.rectangle("line", world:getRect(sprite.player))
	--love.graphics.print("Spawn: " .. map:getLayerProperties("Spawn"), 16)
	--love.filesystem.write("layer_spawn.cfg", table.print(map:getLayerProperties("Spawn")))
	--love.graphics.draw(sprite.player.image, sprite.player.x, sprite.player.y, sprite.player.r)
end

--[[
function level.updatePlayer(dt)
	for _, sprite in pairs(self.sprites) do
		sprite.r = sprite.r + math.rad(90 * dt)
	end
end

function drawPlayer()
	for _, sprite in pairs(self.sprites) do
		local x = math.floor(sprite.x)
		local y = math.floor(sprite.y)
		local r = sprite.r
		love.graphics.draw(sprite.image, x, y, r)
	end
end
--]]


function level_update(dt)
	level.update(dt)
	player_update(dt)
end

function level_draw()
	level.draw()
	player_draw()
end

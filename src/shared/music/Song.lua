--[[
	Wraps charts, and offers methods for the gameloop to progress the song.
]]

--how many seconds after a song is "finished" before it is considered finished.
local SONG_FINISH_OFFSET = 5 

local Song = {}
Song.__index = Song

function Song.new(chart, difficulty, startTick)
	local song = {}
	song.chart = chart
	song.difficulty = difficulty
	song._tick = startTick or 0
	print("New song", chart, difficulty)

	return setmetatable(song, Song)
end

function Song:tick(dt:number)
	self._tick += dt
end

function Song:getBeats() 
	return self.chart.Difficulty[self.difficulty]
end

function Song:getTick(): number
	return self._tick
end

--[[ @returns Whether or not a song has ticked past it's duration, offset by SONG_FINISH_OFFSET ]]
function Song:isFinished()
	return self._tick > (self.chart.MaxDuration + SONG_FINISH_OFFSET)
end

return Song
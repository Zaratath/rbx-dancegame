--[[
	Stores an individual player's beat data associated with a song.
	Generated when a player joins the dancefloor or when a song is created.
]]

--seconds of grace period before beats begin after the PlayerBeats has been instantiated.
local START_WINDUP = 5 
--beat accuracy thresholds. in seconds
local ACC_THRESHOLD = {0.4, 0.2, 0.10}

local PlayerBeats = {}
PlayerBeats.__index = PlayerBeats

function PlayerBeats.new(song, startTick)
	local pb = {}
	
	local beats = {
		{}, {}, {}, {} --4 chords
	}

	for i,beat in ipairs(song:getBeats()) do
		if beat.TimePosition > (startTick + START_WINDUP) then
			table.insert(beats[beat.Chord], beat)
		end
	end

	print("PlayerBeat initialized.", startTick, beats)
	pb.song = song
	pb.beats = beats
	return setmetatable(pb, PlayerBeats)
end

--[[ Should only be called on the clientside, as the server will always be ahead of clients due to latency.
	honest clients will notify the server of any missed beats.
	@returns the beats missed.
]]
function PlayerBeats:getExpiredBeats(): number
	local missedBeats = {} 
	for _,chord in ipairs(self.beats) do
		for j,beat in ipairs(chord) do
			if beat.TimePosition < (self.song:getTick() - ACC_THRESHOLD[1]) then
				table.insert(missedBeats, beat)
			end
		end
	end
	return missedBeats
end

function checkBeatRanges(beatPos, hit, hitrange:number) 
	return hit.TimePos < (beatPos + ACC_THRESHOLD[hitrange]) and hit.TimePos > (beatPos - ACC_THRESHOLD[hitrange])
end

--[[ 
	Evaluates a Hit against this PlayerBeats object.
	@returns, accuracy of the beat hit. 3 for perfect, 2 for mid, 1 for low, 0 for miss. 
]]
function PlayerBeats:checkHit(hit): number
	local nextBeat = self.beats[hit.Chord][1]
	--there's no next beat on this chord, misplay
	if not nextBeat then return 0 end

	local beatPos = nextBeat.TimePosition

	--hit outside of the next beats acc threshold, misplay
	if hit.TimePos > (beatPos + ACC_THRESHOLD[1]) 
	or hit.TimePos < (beatPos - ACC_THRESHOLD[1]) then
		return 0
	end

	-- decrementing, checking higher accuracy first. 
	for i=3,1,-1 do
		if checkBeatRanges(beatPos, hit, i) then
			return i
		end
	end
end

--[[
	Removes the first beat of the given chord
	Should be called if a beatwas actually hit (checkHit returned above 0), or a beat expired.
	@returns beat removed.
]]
function PlayerBeats:removeBeat(chord)
	return table.remove(self.beats[chord], 1)
end


return PlayerBeats
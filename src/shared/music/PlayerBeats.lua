--[[
	Stores an individual player's beat data associated with a song.
	Generated when a player joins the dancefloor or when a song is created.
]]

--seconds of grace period before notes begin after the PlayerBeats has been instantiated.
local START_WINDUP = 5 
--note accuracy thresholds. in seconds
local ACC_THRESHOLD = {0.15, 0.1, 0.05}

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

	pb.beats = beats
	return setmetatable(pb, PlayerBeats)
end


function checkNoteRanges(notePos, hit, hitrange:number) 
	return notePos < (hit.timePos + ACC_THRESHOLD[hitrange])  or notePos > (hit.timePos - ACC_THRESHOLD[hitrange])
end

--[[ 
	Evaluates a Hit against this PlayerBeats object.
	@returns, accuracy of the note hit. 3 for perfect, 2 for mid, 1 for low, 0 for miss. 
]]
function PlayerBeats:checkHit(hit): number
	local nextNote = self.beats[hit.chord][1]
	--there's no next note on this chord, misplay. counts as a miss?
	if not nextNote then return 0 end

	local notePos = nextNote.TimePosition

	print("checkHit", notePos, hit.timePos)
	--hit outside of the next notes acc threshold, also miss.
	if notePos > (hit.timePos + ACC_THRESHOLD[1]) 
	and notePos < (hit.timePos - ACC_THRESHOLD[1]) then
		return 0
	end

	for i=1,3 do
		if checkNoteRanges(notePos, hit, i) then
			return i
		end
	end
end

--[[
	Removes the first note of the given chord
	Should be called if a note was actually hit. (checkHit returned above 0)
	@returns note removed.
]]
function PlayerBeats:removeNote(chord)
	return table.remove(self.beats[chord], 1)
end


return PlayerBeats
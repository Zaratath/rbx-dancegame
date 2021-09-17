--[[
	Provides methods to select songs. 
]]

local Charts = require(game.ReplicatedStorage.Common.music.Charts)

local SongSelector = {}

--[[
	Just returns the first (and only) song for now, for demonstration purposes.
	TODO implement player voting for the song choice?
]]
function SongSelector.selectSong()
	return Charts.getChartByName(Charts.getChartNames()[1])
end

--[[
	Just returns the first difficulty of a chart. Again could be tied into a voting system of sorts,
	so players vote on a specific song at a specific difficulty.
	Fun to explore: but outside of the scope of the challenge I think!
]]
function SongSelector.selectDifficulty(chart)
	for k,_ in pairs(chart.Difficulty) do
		return k
	end
end

return SongSelector


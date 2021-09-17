--[[
	Indexes all songs in the song directory, and parses their charts.
]]
local Chart = require(script.Parent.Chart)
local songsDir = script.Parent.songs
local CHARTSTRING_NAME = "chartstring"
local AUDIO_NAME = "sound"

local ChartsByName = {}
local AudioByName = {}

-- Indexing and parsing songs.
for _,songDir in pairs(songsDir:GetChildren()) do
	local module = songDir:FindFirstChild(CHARTSTRING_NAME);
	local audio = songDir:FindFirstChild(AUDIO_NAME);
	local chartName = songDir.Name
	if (not module) or (not audio) then 
		error("A song was misshapen, Missing either audio or chart: " .. chartName)
	end

	local chart = Chart.new(require(module))
	chart.name = chartName
	ChartsByName[chartName] = chart
	AudioByName[chartName] = audio
	print("Indexed song: " .. chartName, " Length: " .. chart.MaxDuration)
end

local Charts = {}

--[[ @returns Chart by index. Nil if no song exists at that index ]]
function Charts.getChartByName(name: string) 
	return ChartsByName[name]
end

function Charts.getChartNames()
	local t = {}
	for k,_ in pairs(ChartsByName) do
		table.insert(t, k)
	end
	return t
end

function Charts.getAudioByName(name: string): Sound
	return AudioByName[name]
end

return Charts